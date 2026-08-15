version       = "0.1.0"
author        = "WANG"
description   = "Resonance: A Nim OpenVINO C API wrapper / binding library with Intel NPU-oriented runtime helpers."
license       = "Apache-2.0"
srcDir        = "src"

requires "nim >= 2.0.0"

task demo, "Build the basic inference example":
  exec "nim c -r --path:src examples/basic_infer.nim"
