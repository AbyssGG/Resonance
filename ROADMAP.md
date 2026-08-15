# Roadmap

## v0.1 - Standalone Baseline

- [x] Establish the standalone OpenVINO C API binding layer for Resonance
- [x] Split out `Core / Model / CompiledModel / InferRequest / Tensor`
- [x] Carry over the Windows x64 variadic ABI compatibility wrapper
- [x] Provide `.blob` cache import and export entry points
- [x] Add the initial English-first open-source Markdown documentation

## v0.2 - Packaging

- [ ] Add `nimble test`
- [ ] Add a minimal smoke test
- [ ] Document OpenVINO Runtime installation in more detail
- [ ] Add a minimal model preparation guide for first-time users
- [x] Finalize the Apache-2.0 license and establish the initial v0.1.0 release policy

## v0.3 - API Expansion

- [ ] Add input and output port name access
- [ ] Add asynchronous inference APIs
- [ ] Add remote tensor and remote context support
- [ ] Add more property set/get wrappers
- [ ] Clarify version-compatibility expectations with OpenVINO Runtime releases

## v0.4 - Higher-Level Runtime Helpers

- [ ] Add a model warmup helper
- [ ] Add a device selection strategy helper
- [ ] Add a compiled-cache directory policy helper
- [ ] Add profiling aggregation utilities
- [ ] Add regression coverage around `perf_count_wrapper.c` integration

## Long-Term

- [ ] Keep the core library thin and reusable
- [ ] Avoid turning Resonance into an application framework
- [ ] Make Intel NPU workflows first-class without hardcoding one product
- [ ] Reuse it across higher-level TTS / ASR / LLM / vision projects
- [ ] Fully decouple `Resonance` from model-specific voice synthesis logic

## Out of Scope

- tokenizer implementations
- audio pipelines
- ONNX export scripts for specific models
- GUI applications
- Python bridging layers at runtime
