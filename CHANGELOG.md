# Changelog

## 0.1.1

- Fix Linux builds and resolve the C runtime with platform-specific library names.
- Preserve profiling settings when importing compiled model caches instead of setting a property after compilation.
- Align element types and error codes with OpenVINO 2026.4 and add a CPU inference and cache smoke test.
- Document cache compatibility and caller-owned tensor memory.

## 0.1.0 - Initial Standalone Release

### Added

- Established the first standalone OpenVINO C API wrapper baseline for Resonance
- Established the core wrappers: `Core`, `Model`, `CompiledModel`, `InferRequest`, and `Tensor`
- Added `compileOrImportModel()` for `.blob`-aware cold-start and warm-start flows
- Added `getProfilingInfo()` and the profiling data structures exposed by the wrapper
- Added the initial example program under `examples/basic_infer.nim`
- Added the first complete open-source documentation set for the standalone library

### Preserved

- `.blob` compiled-model import and export support
- `PERF_COUNT` profiling support
- the Windows x64 variadic ABI compatibility wrapper `perf_count_wrapper.c`

### Notes

- This release establishes Resonance as a standalone infrastructure library for Nim and OpenVINO integration.
