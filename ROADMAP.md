# Roadmap

## v0.1 - Extraction Baseline

- [x] Extract the OpenVINO C API binding layer from `NimVoice`
- [x] Split out `Core / Model / CompiledModel / InferRequest / Tensor`
- [x] Carry over the Windows x64 variadic ABI compatibility wrapper
- [x] Provide `.blob` cache import and export entry points
- [x] Add the initial open-source Markdown documentation

## v0.2 - Packaging

- [ ] Add `nimble test`
- [ ] Add a minimal smoke test
- [ ] Document OpenVINO Runtime installation
- [x] Finalize the Apache-2.0 license and establish the initial v0.1.0 release policy

## v0.3 - API Expansion

- [ ] Add input and output port name access
- [ ] Add asynchronous inference APIs
- [ ] Add remote tensor and remote context support
- [ ] Add more property set/get wrappers

## v0.4 - Higher-Level Runtime Helpers

- [ ] Add a model warmup helper
- [ ] Add a device selection strategy helper
- [ ] Add a compiled-cache directory policy helper
- [ ] Add profiling aggregation utilities

## Long-Term

- [ ] Publish it as a foundation library for a full bare-metal NPU voice stack
- [ ] Reuse it across higher-level TTS / ASR / LLM NPU projects
- [ ] Fully decouple `Resonance` from model-specific voice synthesis logic
