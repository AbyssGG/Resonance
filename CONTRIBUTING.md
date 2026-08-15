# Contributing

Thank you for your interest in contributing to `Resonance`.

## Scope

`Resonance` is a Nim wrapper / binding library around the OpenVINO C API. Contributions should stay aligned with that scope.

Good contribution areas include:

- OpenVINO C API coverage
- safer handle ownership and memory management
- Intel NPU-oriented runtime helpers
- profiling and compiled-model cache support
- examples, tests, and documentation

Out of scope for this repository:

- model-specific TTS pipelines
- application GUI work
- project-specific voice synthesis business logic

## Development Principles

- Keep the public API small and explicit
- Prefer predictable ABI boundaries over clever abstractions
- Avoid introducing Python runtime dependencies
- Preserve offline-first and native-runtime assumptions
- Treat Intel NPU support as a first-class target

## Before Opening a Pull Request

Please make sure your change:

- fits the repository scope
- keeps documentation in English by default
- updates docs when public APIs change
- avoids breaking existing examples
- stays compatible with Nim 2.x

## Pull Request Notes

When submitting a PR, please include:

- what problem is being solved
- why the change belongs in the wrapper layer
- how you validated the change
- any OpenVINO / device-specific constraints

## Discussion First for Larger Changes

For larger API additions, architectural changes, or behavior changes, open an issue first so the design direction can be aligned before implementation work starts.
