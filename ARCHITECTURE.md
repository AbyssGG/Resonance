# Architecture

## Goal

Resonance provides a reusable inference foundation for Nim applications that need to talk to OpenVINO through the C API.

The library is intentionally split into two layers:

1. low-level FFI bindings
2. safe high-level wrappers

## Layer Model

```text
Application
  |
  +-- resonance
      |
      +-- core.nim
      +-- compiled_model.nim
      +-- infer_request.nim
      +-- tensor.nim
      +-- model.nim
      +-- errors.nim
      |
      +-- c_api.nim
      +-- perf_count_wrapper.c
      |
      +-- openvino_c.dll
```

## Module Responsibilities

### `src/resonance.nim`

- re-exports the public package surface
- gives applications one import point for the wrapper stack

### `c_api.nim`

- imports raw OpenVINO C symbols
- defines enums and opaque handle types
- exposes tensor, model, infer request, profiling, and import/export calls
- compiles `perf_count_wrapper.c`

### `errors.nim`

- turns raw `OvStatus` failures into Nim exceptions
- preserves `ov_get_last_err_msg()` details when available

### `core.nim`

- owns `OvCore`
- discovers devices
- reads models
- compiles models
- imports compiled blobs
- re-enables profiling on imported blobs when needed
- exposes `compileOrImportModel()` for the common warm-start path

### `model.nim`

- owns `OvModel`
- acts as the loaded IR/ONNX handle layer

### `compiled_model.nim`

- owns `OvCompiledModel`
- creates infer requests
- exports compiled blobs

### `infer_request.nim`

- owns `OvInferRequest`
- binds input tensors
- runs inference
- reads output tensors
- collects profiling counters

### `tensor.nim`

- owns `OvTensor`
- creates host-backed tensors
- reshapes reusable buffers
- exposes typed pointer access

## Ownership Model

Each OpenVINO handle wrapper is a Nim `ref object` with a destructor:

- `Core`
- `Model`
- `CompiledModel`
- `InferRequest`
- `Tensor`

This keeps the public API ergonomic while still making native ownership explicit. Once a raw OpenVINO handle is stored inside a wrapper, that wrapper becomes responsible for releasing it.

## Why Host-backed Tensors Matter

`newTensor()` uses `ov_tensor_create_from_host_ptr`, which means:

- the caller controls the real backing buffer
- OpenVINO receives a logical tensor view over that memory
- `setShape()` can reuse the same allocation for different logical lengths

This is especially important for autoregressive loops and other variable-length workloads where repeated allocations would be wasteful.

## Blob Cache Strategy

Compiled-model blob support is treated as a core primitive.

Why:

- NPU compile time can be much slower than blob import time
- applications often need predictable cold-start behavior
- import/export should be part of the library contract, not custom app code

`compileOrImportModel()` exists to centralize this workflow. It returns both the prepared compiled model and a `cacheHit` flag so callers can distinguish a cold compile from a warm import path.

## Profiling Strategy

OpenVINO exposes profiling enablement through variadic property APIs. On Windows x64, calling those directly from Nim is fragile because MSVC and MinGW have incompatible variadic ABI details.

Resonance solves this through `perf_count_wrapper.c`, which provides:

- `nv_compile_model_with_perf_count`
- `nv_enable_perf_count`

This keeps the Nim side on fixed-arity calls while preserving profiling support for the exported API.

## Error Model

The wrapper does not leak raw status codes into normal application flow.

- low-level calls return `OvStatus`
- wrapper code checks them via `requireStatus()`
- failures are raised as `OpenVinoError`
- `ov_get_last_err_msg()` is appended when OpenVINO provides extra context

This keeps the public surface compact without losing debugging value.

## Non-goals

Resonance does not aim to provide:

- graph conversion tooling
- tokenizer libraries
- model zoo management
- application-specific preprocessing
- domain-specific pipelines such as TTS or ASR

## Library Boundary

What moved well into Resonance:

- OpenVINO bindings
- handle lifecycle management
- profiling support
- blob import/export helpers
- tensor reuse patterns

What should stay outside:

- text normalization
- decoder loops tied to specific models
- audio generation logic
- GUI/runtime UX logic
