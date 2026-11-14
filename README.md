# Resonance

Resonance is a Nim wrapper and binding library for the OpenVINO C API.

It is a standalone library focused on:

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
2. Install OpenVINO Runtime and make its C library discoverable (`openvino_c.dll` on Windows, `libopenvino_c.so` on Linux, or `libopenvino_c.dylib` on macOS). If the distribution only provides a versioned library, provide the corresponding unversioned development-library link.
3. Build and run the example from the repository root with an OpenVINO IR model and a device:

```bash
nim c -r --path:src examples/basic_infer.nim model.xml CPU cache/model.blob
```

Minimal usage:

```nim
import resonance

let core = newCore()
echo core.getAvailableDevices()
```

Run `nimble test` with the runtime and CPU plugin available to execute the CPU smoke test. The C bindings target the OpenVINO 2026.4 headers; this release has been tested with 2026.4.1 on Linux. Other versions and platforms require validation.

The bundled example also demonstrates `compileOrImportModel()`, which is the recommended path when you want predictable NPU cold-start behavior with `.blob` cache reuse.

A blob cache path must be unique to the model, device, OpenVINO runtime and compile options, including profiling. Existing blobs are imported as-is; changing these inputs requires a new cache path or removing the old blob. `newTensor` wraps caller-owned memory: keep its buffer alive and unchanged in size until the tensor and any inference using it are finished.

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

## AI-Assisted Development

This project was developed with the assistance of Google Gemini 3.1 Pro.

AI was used as a development assistant for tasks such as code generation, debugging, documentation, API exploration, and development workflow support.

The project architecture, technical direction, integration decisions, testing, hardware validation, and final code review were performed by the project author.

AI assistance does not change the project's core technical implementation or its open-source licensing.

## License

This project is licensed under the [Apache License 2.0](./LICENSE).

## Related Docs

- [README.zh-CN.md](./README.zh-CN.md)
- [ARCHITECTURE.md](./ARCHITECTURE.md)
- [ARCHITECTURE.zh-CN.md](./ARCHITECTURE.zh-CN.md)
- [ROADMAP.md](./ROADMAP.md)
- [ROADMAP.zh-CN.md](./ROADMAP.zh-CN.md)
- [LIBRARY_BOUNDARIES.md](./LIBRARY_BOUNDARIES.md)
- [LIBRARY_BOUNDARIES.zh-CN.md](./LIBRARY_BOUNDARIES.zh-CN.md)
- [CHANGELOG.md](./CHANGELOG.md)
- [CHANGELOG.zh-CN.md](./CHANGELOG.zh-CN.md)
- [LANGUAGE.md](./LANGUAGE.md)
- [LANGUAGE.zh-CN.md](./LANGUAGE.zh-CN.md)
