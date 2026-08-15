# Resonance

Resonance is a Nim wrapper and binding library for the OpenVINO C API.

It extracts the reusable inference foundation from `NimVoice` and turns it into a standalone library focused on:

- low-level OpenVINO C API bindings
- safe Nim ownership wrappers
- tensor and infer request helpers
- compiled-model import/export
- Intel NPU-oriented runtime helpers
- Windows x64 variadic ABI compatibility for profiling properties

Resonance is a library, not an end-user application. It does not ship TTS pipelines, GUI code, or model-specific business logic.

## Why Resonance

- Pure Nim runtime integration with `openvino_c.dll`
- No Python runtime dependency
- Thin enough to stay close to OpenVINO
- High-level enough to avoid raw pointer ownership bugs
- Designed around real Intel NPU deployment constraints

## Layering

```text
Nim App
  -> resonance/core
  -> resonance/model
  -> resonance/compiled_model
  -> resonance/infer_request
  -> resonance/tensor
  -> resonance/c_api
  -> openvino_c.dll
```

## Current API Surface

### Low-level

- `OvStatus`
- `OvElementType`
- `OvShape`
- `OvProfilingInfo`
- `ov_*` C function imports
- `nv_compile_model_with_perf_count`
- `nv_enable_perf_count`

### Safe wrappers

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

## Design Principles

1. Stay close to the OpenVINO C API.
2. Make ownership explicit and automatic with Nim destructors.
3. Treat compiled-model blob caching as core infrastructure.
4. Keep Intel NPU workflows first-class.
5. Separate reusable inference plumbing from application logic.

## Repository Structure

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

1. Install Nim 2.x.
2. Prepare the OpenVINO Runtime and ensure `openvino_c.dll` is available at runtime.
3. Build and run the example from the repository root:

```bash
nimble demo
```

Minimal usage:

```nim
import resonance

let core = newCore()
echo core.getAvailableDevices()
```

The bundled example also demonstrates `compileOrImportModel()`, which is the recommended path when you want predictable NPU cold-start behavior with `.blob` cache reuse.

## Scope Boundaries

Resonance should contain:

- OpenVINO bindings
- safe wrappers
- error handling
- profiling helpers
- blob cache helpers
- reusable examples

Resonance should not contain:

- TTS pipeline logic
- tokenizer logic
- model-specific post-processing
- GUI code
- application CLI behavior

## Community

- [CONTRIBUTING.md](./CONTRIBUTING.md)
- [CODE_OF_CONDUCT.md](./CODE_OF_CONDUCT.md)
- [SECURITY.md](./SECURITY.md)
- [SUPPORT.md](./SUPPORT.md)

## License

This project is licensed under the [Apache License 2.0](./LICENSE).

## Related Docs

- [README.zh-CN.md](./README.zh-CN.md)
- [ARCHITECTURE.md](./ARCHITECTURE.md)
- [ARCHITECTURE.zh-CN.md](./ARCHITECTURE.zh-CN.md)
- [ROADMAP.md](./ROADMAP.md)
- [ROADMAP.zh-CN.md](./ROADMAP.zh-CN.md)
- [MIGRATION_FROM_NIMVOICE.md](./MIGRATION_FROM_NIMVOICE.md)
- [MIGRATION_FROM_NIMVOICE.zh-CN.md](./MIGRATION_FROM_NIMVOICE.zh-CN.md)
- [CHANGELOG.md](./CHANGELOG.md)
- [CHANGELOG.zh-CN.md](./CHANGELOG.zh-CN.md)
- [LANGUAGE.md](./LANGUAGE.md)
- [LANGUAGE.zh-CN.md](./LANGUAGE.zh-CN.md)
