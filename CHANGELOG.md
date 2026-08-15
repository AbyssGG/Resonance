# Changelog

## 0.1.0 - Initial Extraction

- Extracted the OpenVINO C API binding layer from `NimVoice`
- Established the five core wrappers: `Core / Model / CompiledModel / InferRequest / Tensor`
- Preserved `.blob` import and export support
- Preserved `PERF_COUNT` profiling support
- Integrated the Windows x64 variadic ABI compatibility wrapper `perf_count_wrapper.c`
- Added the initial example and open-source documentation set
