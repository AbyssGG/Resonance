version       = "0.1.1"
author        = "WANG"
description   = "Resonance: A Nim OpenVINO C API wrapper / binding library with Intel NPU-oriented runtime helpers."
license       = "Apache-2.0"
srcDir        = "src"

requires "nim >= 2.0.0"

task demo, "Build the basic inference example":
  exec "nim c --path:src --out:build/basic_infer examples/basic_infer.nim"

task test, "Run OpenVINO CPU smoke tests":
  exec "nim c -r --path:src --out:build/test_smoke tests/test_smoke.nim"
