import std/[os, unittest]
import resonance

suite "OpenVINO CPU smoke tests":
  test "compile, infer and import a profiling-enabled model":
    let cacheDir = getTempDir() / ("resonance-smoke-" & $getCurrentProcessId())
    createDir(cacheDir)
    defer: removeDir(cacheDir)
    let modelPath = currentSourcePath().parentDir / "fixtures" / "relu.xml"
    let cachePath = cacheDir / "relu.blob"
    let core = newCore()
    check "CPU" in core.getAvailableDevices()
    for expectedHit in [false, true]:
      let prepared = core.compileOrImportModel(modelPath, "CPU", cachePath, true)
      check prepared.cacheHit == expectedHit
      let req = prepared.compiledModel.createInferRequest()
      var input = [-2'f32, 0'f32, 1'f32, 3'f32]
      let tensor = newTensor(F32, @[1'i64, 4], addr input[0])
      check tensor.getShape() == @[1'i64, 4]
      check tensor.getSize() == 4
      req.setInputTensor(0, tensor)
      req.infer()
      let output = req.getOutputTensor(0)
      check output.getShape() == @[1'i64, 4]
      let data = output.getData(float32)
      check @[data[0], data[1], data[2], data[3]] == @[0'f32, 0'f32, 1'f32, 3'f32]
      check req.getProfilingInfo().len > 0

  test "unsigned byte tensors use the OpenVINO element type":
    var values = [1'u8, 2, 3, 4]
    let tensor = newTensor(U8, @[4'i64], addr values[0])
    check tensor.getShape() == @[4'i64]
    check tensor.getData(uint8)[2] == 3
