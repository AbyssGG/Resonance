# 路线图

## v0.1 - 独立基线

- [x] 建立 Resonance 独立的 OpenVINO C API 绑定层
- [x] 独立出 `Core / Model / CompiledModel / InferRequest / Tensor`
- [x] 保留 Windows x64 variadic ABI 兼容包装层
- [x] 提供 `.blob` 缓存导入导出入口
- [x] 补齐首版 English-first 开源 Markdown 文档集

## v0.2 - 打包完善

- [ ] 增加 `nimble test`
- [ ] 增加最小 smoke test
- [ ] 更完整地说明 OpenVINO Runtime 安装方式
- [ ] 为首次接触项目的用户补一份最小模型准备指南
- [x] 完成 Apache-2.0 许可证和初始 v0.1.0 发布策略

## v0.3 - API 扩展

- [ ] 增加输入输出端口名称访问能力
- [ ] 增加异步推理 API
- [ ] 增加 remote tensor 和 remote context 支持
- [ ] 增加更多 property set/get 封装
- [ ] 明确与 OpenVINO Runtime 版本的兼容预期

## v0.4 - 更高层的运行时辅助

- [ ] 增加模型 warmup helper
- [ ] 增加设备选择策略 helper
- [ ] 增加编译缓存目录策略 helper
- [ ] 增加 profiling 聚合工具
- [ ] 增加 `perf_count_wrapper.c` 集成相关回归验证

## 长期方向

- [ ] 保持核心库足够薄、足够可复用
- [ ] 避免把 Resonance 做成应用框架
- [ ] 在不绑定某个单一产品的前提下，把 Intel NPU 工作流做成一等公民
- [ ] 在更高层 TTS / ASR / LLM / 视觉项目中复用它
- [ ] 彻底与模型专属的语音合成逻辑解耦

## 不纳入范围

- tokenizer 实现
- 音频流水线
- 特定模型的 ONNX 导出脚本
- GUI 应用
- 运行时 Python 桥接
