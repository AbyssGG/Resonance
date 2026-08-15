# Migration From NimVoice

## What Was Moved

This extraction moves the low-level OpenVINO wrapper layer out of `NimVoice`, primarily from the following files:

- `src/openvino/c_api.nim`
- `src/openvino/core.nim`
- `src/openvino/model.nim`
- `src/openvino/compiled_model.nim`
- `src/openvino/infer_request.nim`
- `src/openvino/tensor.nim`
- `src/openvino/perf_count_wrapper.c`

## What Was Intentionally Left Behind

The following pieces still belong to the voice application layer and should not be moved directly into `Resonance`:

- `tts.nim`
- `text.nim`
- `audio.nim`
- benchmark / CLI / GUI
- model resource path management
- text normalization and multilingual tokenization

## Extraction Rules

The extraction follows these rules:

1. Keep only capabilities that directly interact with the OpenVINO Runtime
2. Do not carry SpeechT5 / HiFi-GAN / Piper or other model-specific logic into the library
3. Do not mix project-level business configuration, path conventions, or resource preflight logic into the library layer
4. Preserve `.blob` cache support and profiling hooks required for Intel NPU workflows

## Suggested Next Step

The higher-level application repository can then:

- include `Resonance` as a git submodule or vendored directory
- publish it independently and install it through Nimble
- implement `TtsSession`, resource preflight checks, and text preprocessing at the application layer
