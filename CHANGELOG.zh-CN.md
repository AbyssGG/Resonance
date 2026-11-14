# 更新日志

## 0.1.1

- 修复 Linux 编译，并按平台加载 C 运行库。
- 导入编译模型缓存时保留原有 profiling 配置，避免对已编译模型设置属性。
- 将元素类型和错误码与 OpenVINO 2026.4 对齐，增加 CPU 推理及缓存冒烟测试。
- 说明缓存兼容性和调用方持有 tensor 内存的要求。

## 0.1.0 - 首个独立发布版本

### 新增

- 建立 Resonance 的首个独立 OpenVINO C API 封装基线
- 建立核心包装对象：`Core`、`Model`、`CompiledModel`、`InferRequest`、`Tensor`
- 增加 `compileOrImportModel()`，统一处理 `.blob` 冷启动和热启动路径
- 增加 `getProfilingInfo()` 以及对应的 profiling 数据结构
- 增加 `examples/basic_infer.nim` 最小示例程序
- 增加首套可独立开源使用的文档体系

### 保留

- `.blob` 编译模型导入导出能力
- `PERF_COUNT` profiling 支持
- Windows x64 variadic ABI 兼容包装层 `perf_count_wrapper.c`

### 备注

- 这个版本标志着 Resonance 已作为独立的 Nim + OpenVINO 基础设施库正式发布。
