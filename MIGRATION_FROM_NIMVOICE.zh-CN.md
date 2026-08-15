# 从 NimVoice 拆分说明

这是 `MIGRATION_FROM_NIMVOICE.md` 的中文占位页。

## 状态

- 英文版 `MIGRATION_FROM_NIMVOICE.md` 是当前主版本
- 本文件用于中文切换入口
- 具体拆分规则以英文版为准

## 对应英文文档

- [MIGRATION_FROM_NIMVOICE.md](./MIGRATION_FROM_NIMVOICE.md)

## 简要说明

本次拆分的核心目标是：

- 将底层 OpenVINO 封装从 `NimVoice` 中独立出来
- 保留 Intel NPU 所需的 `.blob` 缓存与 profiling 能力
- 避免把上层 TTS 业务逻辑混入基础库
