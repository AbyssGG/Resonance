# Resonance

Resonance 是一个面向 OpenVINO C API 的 Nim 封装与绑定库。

它是一个独立基础库，重点解决：

- OpenVINO C API 底层绑定
- Nim 对原生句柄的安全托管
- Tensor / Infer Request 便捷封装
- 编译模型的导入导出
- Intel NPU 场景下的运行时辅助能力
- Windows x64 下 variadic 属性调用兼容

Resonance 是库，不是终端应用。它不包含 TTS 产品逻辑、GUI 或具体模型业务流程。

## 为什么要做 Resonance

- 纯 Nim 运行时，直接对接 `openvino_c.dll`
- 不依赖 Python 运行时
- 足够贴近 OpenVINO 原生能力
- 又比裸 FFI 更安全，避免句柄释放和指针生命周期问题
- 从一开始就围绕 Intel NPU 的真实部署问题设计

## 分层结构

```text
Nim 应用
  -> resonance/core
  -> resonance/model
  -> resonance/compiled_model
  -> resonance/infer_request
  -> resonance/tensor
  -> resonance/c_api
  -> openvino_c.dll
```

## 当前 API 范围

### 底层绑定

- `OvStatus`
- `OvElementType`
- `OvShape`
- `OvProfilingInfo`
- `ov_*` C 函数导入
- `nv_compile_model_with_perf_count`
- `nv_enable_perf_count`

### 安全封装

- `newCore()`
- `getAvailableDevices()`
- `readModel()`
- `compileModel()`
- `compileModelWithProfiling()`
- `importModel()`
- `compileOrImportModel()`
- `createInferRequest()`
- `setInputTensor()`
- `getOutputTensor()`
- `infer()`
- `getProfilingInfo()`
- `newTensor()`
- `setShape()`
- `getShape()`
- `getData()`
- `getSize()`

## 设计原则

1. 尽量贴近 OpenVINO C API 原貌。
2. 用 Nim 析构函数自动管理原生句柄生命周期。
3. 把 `.blob` 编译缓存当成核心能力，而不是附加功能。
4. 把 Intel NPU 工作流作为一等公民。
5. 严格分离通用推理层与上层应用逻辑。

## 仓库结构

```text
src/
  resonance.nim
  resonance/
    c_api.nim
    core.nim
    model.nim
    compiled_model.nim
    infer_request.nim
    tensor.nim
    errors.nim
    perf_count_wrapper.c

examples/
  basic_infer.nim
```

## 快速开始

1. 安装 Nim 2.x。
2. 准备 OpenVINO Runtime，并确保运行时可以找到 `openvino_c.dll`。
3. 在仓库根目录执行：

```bash
nimble demo
```

最小示例：

```nim
import resonance

let core = newCore()
echo core.getAvailableDevices()
```

仓库自带示例还演示了 `compileOrImportModel()` 的用法。这是做 Intel NPU 冷启动优化时更推荐的入口，因为它把 `.blob` 缓存复用纳入了默认工作流。

## 范围边界

Resonance 应该包含：

- OpenVINO 绑定
- 安全封装
- 错误处理
- profiling 辅助
- blob 缓存辅助
- 可复用示例

Resonance 不应该包含：

- TTS 业务流水线
- tokenizer 逻辑
- 模型专属后处理
- GUI 代码
- 应用级 CLI 行为

## 社区文档

- [CONTRIBUTING.md](./CONTRIBUTING.md)
- [CODE_OF_CONDUCT.md](./CODE_OF_CONDUCT.md)
- [SECURITY.md](./SECURITY.md)
- [SUPPORT.md](./SUPPORT.md)

## 许可证

本项目使用 [Apache License 2.0](./LICENSE)。

## 相关文档

- [README.md](./README.md)
- [ARCHITECTURE.md](./ARCHITECTURE.md)
- [ARCHITECTURE.zh-CN.md](./ARCHITECTURE.zh-CN.md)
- [ROADMAP.md](./ROADMAP.md)
- [ROADMAP.zh-CN.md](./ROADMAP.zh-CN.md)
- [LIBRARY_BOUNDARIES.md](./LIBRARY_BOUNDARIES.md)
- [LIBRARY_BOUNDARIES.zh-CN.md](./LIBRARY_BOUNDARIES.zh-CN.md)
- [CHANGELOG.md](./CHANGELOG.md)
- [CHANGELOG.zh-CN.md](./CHANGELOG.zh-CN.md)
- [LANGUAGE.md](./LANGUAGE.md)
- [LANGUAGE.zh-CN.md](./LANGUAGE.zh-CN.md)
