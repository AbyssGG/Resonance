# Resonance

**Resonance: A Nim OpenVINO C API Wrapper / Binding Library**

`Resonance` is the extracted OpenVINO integration layer from `NimVoice`. Its goal is to turn this stack into a standalone, reusable, open-source Nim wrapper / binding library:

```text
Nim
  ↓
OpenVINO C API
  ↓
Intel NPU
```

This repository focuses on OpenVINO C API bindings, handle ownership, model compilation, tensor management, profiling, and Intel NPU-oriented runtime helpers. It is a library layer, not a synthesizer product.

## Why Resonance

- Pure Nim bindings with no Python runtime dependency
- Preserves `.blob` compiled-model caching required for efficient Intel NPU workflows
- Wraps `Core / Model / CompiledModel / InferRequest / Tensor`
- Uses Nim `=destroy` destructors to manage OpenVINO C handles safely
- Includes a Windows x64 variadic ABI compatibility layer for properties such as `PERF_COUNT`

## Current Scope

The current extracted surface area includes:

- `newCore()`
- `getAvailableDevices()`
- `readModel()`
- `compileModel()`
- `compileModelWithProfiling()`
- `importModel()`
- `compileOrImportModel()`
- `createInferRequest()`
- `setInputTensor() / getOutputTensor() / infer()`
- `getProfilingInfo()`
- `newTensor() / setShape() / getShape() / getSize()`

## Project Layout

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

## Quick Start

1. Prepare the OpenVINO Runtime and ensure `openvino_c.dll` is available on the system search path.
2. Install Nim 2.x.
3. Run from the repository root:

```bash
nimble demo
```

Or import it directly in your project:

```nim
import resonance

let core = newCore()
echo core.getAvailableDevices()
```

## Design Notes

- This library targets the OpenVINO C API rather than the C++ API in order to keep ABI boundaries simple and deployment predictable.
- `perf_count_wrapper.c` is a critical Windows x64 compatibility shim used to call OpenVINO's variadic property APIs safely.
- `.blob` import and export support is treated as core infrastructure for Intel NPU cold-start optimization, not as an optional add-on.

## Open Source Checklist

Recommended items before publishing:

- Finalize the license
- Add CI at least for `nim check` and example builds
- Add one real inference example and a minimal test-model guide
- Continue separating higher-level TTS-specific logic from this library

## Community

- [CONTRIBUTING.md](./CONTRIBUTING.md)
- [CODE_OF_CONDUCT.md](./CODE_OF_CONDUCT.md)
- [SECURITY.md](./SECURITY.md)
- [SUPPORT.md](./SUPPORT.md)

## License

This project is licensed under the [Apache License 2.0](./LICENSE).

## Related Docs

- [LANGUAGE.md](./LANGUAGE.md)
- [LANGUAGE.zh-CN.md](./LANGUAGE.zh-CN.md)
- [README.zh-CN.md](./README.zh-CN.md)
- [ARCHITECTURE.md](./ARCHITECTURE.md)
- [ARCHITECTURE.zh-CN.md](./ARCHITECTURE.zh-CN.md)
- [ROADMAP.md](./ROADMAP.md)
- [ROADMAP.zh-CN.md](./ROADMAP.zh-CN.md)
- [MIGRATION_FROM_NIMVOICE.md](./MIGRATION_FROM_NIMVOICE.md)
- [MIGRATION_FROM_NIMVOICE.zh-CN.md](./MIGRATION_FROM_NIMVOICE.zh-CN.md)
- [CHANGELOG.md](./CHANGELOG.md)
- [CHANGELOG.zh-CN.md](./CHANGELOG.zh-CN.md)
