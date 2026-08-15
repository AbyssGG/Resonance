# Library Boundaries

## Goal

Resonance is a standalone infrastructure library for Nim applications that integrate with the OpenVINO C API.

The goal of this document is to define a clean engineering boundary between:

- reusable inference infrastructure
- higher-level domain logic built on top of that infrastructure

## What Belongs in Resonance

Resonance should contain the low-level and reusable runtime layer:

- `src/resonance/c_api.nim`
- `src/resonance/core.nim`
- `src/resonance/model.nim`
- `src/resonance/compiled_model.nim`
- `src/resonance/infer_request.nim`
- `src/resonance/tensor.nim`
- `src/resonance/errors.nim`
- `src/resonance/perf_count_wrapper.c`

These modules define the package namespace, the ownership model, and the OpenVINO-facing API surface.

## Namespace Mapping

The package layout is intentionally simple and library-oriented:

| Package Surface | Responsibility |
| --- | --- |
| `src/resonance/c_api.nim` | Raw FFI bindings and OpenVINO handle types |
| `src/resonance/core.nim` | Core runtime, device discovery, model compilation, blob import |
| `src/resonance/model.nim` | Loaded model handle wrapper |
| `src/resonance/compiled_model.nim` | Compiled model wrapper and blob export |
| `src/resonance/infer_request.nim` | Input binding, inference execution, profiling collection |
| `src/resonance/tensor.nim` | Host-backed tensor creation and buffer reuse |
| `src/resonance/errors.nim` | Status-to-exception conversion |
| `src/resonance/perf_count_wrapper.c` | Windows x64 variadic ABI compatibility shim |

## What Should Stay Outside

The following categories should remain outside the library:

- tokenizer implementations
- text normalization
- audio generation logic
- model-specific decoder loops
- post-processing tied to one model family
- benchmark, CLI, and GUI entry points
- resource path policy and application preflight rules

## Boundary Rules

Resonance follows these rules:

1. Keep only capabilities that directly interact with OpenVINO Runtime primitives.
2. Preserve `.blob` cache support and profiling hooks required for Intel NPU workflows.
3. Avoid product policy, resource management, and application UX logic.
4. Prefer small reusable primitives over framework-style abstractions.
5. Keep the public surface stable and predictable for downstream Nim projects.

## Recommended Integration Model

Higher-level repositories should treat Resonance as infrastructure:

- vendor it directly or include it as a submodule
- publish it independently and install it through Nimble when appropriate
- keep domain objects, model policy, and application orchestration in the application repository

## Why This Boundary Matters

- it keeps the wrapper easy to review and maintain
- it prevents model-specific logic from leaking into the core library
- it gives Windows ABI compatibility work a stable home
- it makes the package reusable across TTS, ASR, LLM, and vision projects
