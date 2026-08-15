# 架构说明

## 目标

Resonance 为需要通过 OpenVINO C API 进行推理的 Nim 应用提供一层可复用的基础设施。

整个库有意分成两层：

1. 底层 FFI 绑定
2. 高层安全封装

## 分层模型

```text
应用层
  |
  +-- resonance
      |
      +-- core.nim
      +-- compiled_model.nim
      +-- infer_request.nim
      +-- tensor.nim
      +-- model.nim
      +-- errors.nim
      |
      +-- c_api.nim
      +-- perf_count_wrapper.c
      |
      +-- openvino_c.dll
```

## 各模块职责

### `src/resonance.nim`

- 重新导出对外公开的包接口
- 为应用层提供单一 `import resonance` 入口

### `c_api.nim`

- 导入原始 OpenVINO C 符号
- 定义枚举和 opaque handle 类型
- 暴露 tensor、model、infer request、profiling、import/export 等 C 接口
- 编译 `perf_count_wrapper.c`

### `errors.nim`

- 把原始 `OvStatus` 转成 Nim 异常
- 在有额外上下文时保留 `ov_get_last_err_msg()` 信息

### `core.nim`

- 托管 `OvCore`
- 发现设备
- 读取模型
- 编译模型
- 导入编译后的 blob
- 必要时在 blob 导入后重新开启 profiling
- 暴露 `compileOrImportModel()` 作为常用的热启动入口

### `model.nim`

- 托管 `OvModel`
- 作为加载后的 IR/ONNX 模型句柄层

### `compiled_model.nim`

- 托管 `OvCompiledModel`
- 创建 infer request
- 导出编译后的 blob

### `infer_request.nim`

- 托管 `OvInferRequest`
- 绑定输入 tensor
- 执行推理
- 读取输出 tensor
- 收集 profiling 计数器

### `tensor.nim`

- 托管 `OvTensor`
- 创建 host-backed tensor
- 对可复用缓冲区重新设定 shape
- 暴露类型安全的数据指针访问

## 所有权模型

每一个 OpenVINO 原生句柄，都在 Nim 里对应一个带析构函数的 `ref object`：

- `Core`
- `Model`
- `CompiledModel`
- `InferRequest`
- `Tensor`

这样既保留了易用性，也明确了原生资源的生命周期。一旦某个原生句柄被放入包装器对象中，释放职责就归这个包装器所有。

## 为什么 Host-backed Tensor 很重要

`newTensor()` 基于 `ov_tensor_create_from_host_ptr`，这意味着：

- 真正的底层缓冲区由调用方控制
- OpenVINO 只是拿到一层逻辑视图
- `setShape()` 可以在不重复分配内存的情况下复用同一个缓冲区

这对自回归循环和其它变长推理场景非常关键，因为这类场景往往会频繁改变逻辑长度。

## Blob 缓存策略

编译模型的 blob 导入导出在 Resonance 中是核心能力，不是附加功能。

原因：

- NPU 编译成本通常远高于 blob 导入
- 实际应用需要可预测的冷启动性能
- 这类能力应该属于库的契约，而不是上层应用临时拼接

因此 `compileOrImportModel()` 被设计成一等入口。它同时返回编译后的模型对象和 `cacheHit` 标记，方便调用方区分冷编译和热导入路径。

## Profiling 策略

OpenVINO 对 profiling 的开启依赖 variadic property API。在 Windows x64 上，Nim 直接调用 variadic C API 会比较脆弱，因为 MSVC 和 MinGW 在 ABI 细节上并不一致。

Resonance 通过 `perf_count_wrapper.c` 解决这个问题，提供：

- `nv_compile_model_with_perf_count`
- `nv_enable_perf_count`

这样 Nim 侧只需要调用固定参数的 C 函数，同时保留 profiling 能力。

## 错误模型

这个封装层不会把原始状态码直接暴露成上层业务的常规控制流。

- 底层调用返回 `OvStatus`
- 高层包装统一通过 `requireStatus()` 检查
- 失败时抛出 `OpenVinoError`
- 如果 OpenVINO 提供了更多信息，会附加 `ov_get_last_err_msg()`

这样既保持了 API 简洁，也保留了足够的调试上下文。

## 非目标

Resonance 不打算提供：

- 图转换工具链
- tokenizer 库
- 模型仓库管理
- 应用专属预处理
- TTS / ASR 这类领域流水线

## 库边界

适合进入 Resonance 的部分：

- OpenVINO 绑定
- 句柄生命周期管理
- profiling 支持
- blob 导入导出辅助
- tensor 复用模式

不应该进入 Resonance 的部分：

- 文本归一化
- 绑定具体模型的 decoder 循环
- 音频生成逻辑
- GUI / 运行时交互逻辑
