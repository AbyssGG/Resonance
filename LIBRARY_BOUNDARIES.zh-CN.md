# 库边界说明

## 目标

Resonance 是一个面向 Nim + OpenVINO C API 集成场景的独立基础设施库。

这份文档的目标，是划清两类职责之间的工程边界：

- 可复用的推理基础设施
- 建立在这层基础设施之上的高层领域逻辑

## 应该放进 Resonance 的内容

Resonance 应该承载底层且可复用的运行时层：

- `src/resonance/c_api.nim`
- `src/resonance/core.nim`
- `src/resonance/model.nim`
- `src/resonance/compiled_model.nim`
- `src/resonance/infer_request.nim`
- `src/resonance/tensor.nim`
- `src/resonance/errors.nim`
- `src/resonance/perf_count_wrapper.c`

这些模块共同定义了包命名空间、资源所有权模型，以及面向 OpenVINO 的 API 表面。

## 包内模块分工

整个包结构是刻意按“基础库”方式组织的：

| 包内模块 | 职责 |
| --- | --- |
| `src/resonance/c_api.nim` | 原始 FFI 绑定与 OpenVINO 句柄类型 |
| `src/resonance/core.nim` | Core 运行时、设备发现、模型编译、blob 导入 |
| `src/resonance/model.nim` | 已加载模型的句柄封装 |
| `src/resonance/compiled_model.nim` | 编译模型封装与 blob 导出 |
| `src/resonance/infer_request.nim` | 输入绑定、推理执行、profiling 收集 |
| `src/resonance/tensor.nim` | host-backed tensor 创建与缓冲区复用 |
| `src/resonance/errors.nim` | 状态码到异常的统一转换 |
| `src/resonance/perf_count_wrapper.c` | Windows x64 variadic ABI 兼容层 |

## 应该留在库外的内容

下面这些类别不应该进入基础库：

- tokenizer 实现
- 文本归一化
- 音频生成逻辑
- 绑定具体模型的 decoder 循环
- 面向单一模型族的后处理
- benchmark、CLI、GUI 入口
- 资源路径策略与应用预检规则

## 边界规则

Resonance 遵循以下规则：

1. 只保留直接面向 OpenVINO Runtime 原语的能力。
2. 保留 Intel NPU 工作流所需的 `.blob` 缓存和 profiling 支持。
3. 不混入产品策略、资源管理和应用交互逻辑。
4. 优先提供小而稳的基础原语，而不是做成框架。
5. 保持对下游 Nim 项目来说稳定、可预期的公共 API。

## 推荐集成方式

更高层的仓库应当把 Resonance 视为基础设施层：

- 直接 vendoring，或者以 submodule 形式引入
- 适合时独立发布，并通过 Nimble 安装
- 领域对象、模型策略和应用编排逻辑继续放在应用仓库里

## 为什么这条边界重要

- 能让封装层更容易审查和维护
- 能避免模型专属逻辑渗入核心库
- 能为 Windows ABI 兼容工作提供稳定归属地
- 能让这个包在 TTS、ASR、LLM、视觉等项目里复用
