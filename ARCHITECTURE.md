# Architecture

## Positioning

`Resonance` is not a user-facing TTS application or synthesizer. It is a Nim wrapper / binding layer around the OpenVINO C API.

The intended layering is:

```text
Application Layer
  - TTS / ASR / inference applications
  - model-specific pipelines
  - benchmarking / GUI / CLI tools

Resonance
  - Nim resource wrappers
  - OpenVINO C API bindings
  - blob cache import/export
  - profiling hooks

OpenVINO Runtime
  - CPU / GPU / Intel NPU plugins
```

## Module Responsibilities

### `resonance/c_api.nim`

- Defines OpenVINO C types and `importc` bindings
- Declares low-level profiling and tensor APIs
- Compiles `perf_count_wrapper.c`

### `resonance/errors.nim`

- Provides `OpenVinoError`
- Centralizes status checking and error message composition

### `resonance/model.nim`

- Wraps `ov_model_t`
- Owns model handle destruction

### `resonance/compiled_model.nim`

- Wraps `ov_compiled_model_t`
- Provides `createInferRequest()` and `exportModelToFile()`

### `resonance/infer_request.nim`

- Wraps `ov_infer_request_t`
- Provides input tensor binding, synchronous inference, and profiling extraction

### `resonance/tensor.nim`

- Wraps `ov_tensor_t`
- Provides host-pointer tensors, dynamic reshape support, and shape accessors

### `resonance/core.nim`

- Serves as the main high-level entry point
- Provides device enumeration, model loading, compilation, and blob import/export
- Exposes `compileOrImportModel()` as an NPU-friendly warm-start path

## Memory Ownership

The library follows a simple ownership model:

- Once a C handle enters a Nim wrapper, the wrapper exclusively owns its destruction
- Wrapper lifetimes are managed through ARC/ORC and `=destroy`
- Unless OpenVINO explicitly returns borrowed memory, values are copied into Nim strings or seqs

## Windows ABI Compatibility

OpenVINO property APIs use variadic calls. On Windows x64 this introduces ABI differences between MSVC and MinGW. `perf_count_wrapper.c` exists to collapse those fragile variadic calls into fixed-signature functions that Nim can invoke reliably.

This is one of the key pieces of engineering value in `Resonance` and should not be reimplemented repeatedly in higher-level projects.
