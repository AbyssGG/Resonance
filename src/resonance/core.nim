import std/os

import c_api
import compiled_model
import errors
import infer_request
import model
import tensor

export c_api.OvElementType
export c_api.OvStatus
export c_api.OvProfilingStatus
export c_api.OvProfilingInfo
export c_api.nv_compile_model_with_perf_count
export c_api.nv_enable_perf_count
export compiled_model.CompiledModel
export errors.OpenVinoError
export infer_request.InferRequest
export infer_request.ProfilingInfo
export model.Model
export tensor.Tensor

type
  CoreObj* = object
    pCore*: ptr OvCore
  Core* = ref CoreObj

proc `=destroy`*(core: var CoreObj) =
  if core.pCore != nil:
    ov_core_free(core.pCore)
    core.pCore = nil

proc newCore*(): Core =
  var pCore: ptr OvCore
  requireStatus(ov_core_create(addr pCore), "Create OpenVINO core")
  new(result)
  result.pCore = pCore

proc getAvailableDevices*(core: Core): seq[string] =
  var devices: OvAvailableDevices
  requireStatus(ov_core_get_available_devices(core.pCore, addr devices), "Get available devices")
  try:
    result = newSeq[string](int(devices.size))
    for i in 0 ..< int(devices.size):
      result[i] = $devices.devices[i]
  finally:
    ov_available_devices_free(addr devices)

proc readModel*(core: Core, modelPath: string, binPath: string = ""): Model =
  var pModel: ptr OvModel
  let actualBinPath = if binPath.len > 0: binPath.cstring else: nil
  requireStatus(
    ov_core_read_model(core.pCore, modelPath.cstring, actualBinPath, addr pModel),
    "Read model",
    modelPath
  )
  new(result)
  result.pModel = pModel

proc compileModel*(core: Core, model: Model, deviceName: string): CompiledModel =
  var pCompiledModel: ptr OvCompiledModel
  requireStatus(
    ov_core_compile_model(core.pCore, model.pModel, deviceName.cstring, 0, addr pCompiledModel),
    "Compile model",
    deviceName
  )
  new(result)
  result.pCompiledModel = pCompiledModel

proc compileModelWithProfiling*(
  core: Core,
  model: Model,
  deviceName: string
): CompiledModel =
  var pCompiledModel: ptr OvCompiledModel
  requireStatus(
    nv_compile_model_with_perf_count(
      core.pCore,
      model.pModel,
      deviceName.cstring,
      addr pCompiledModel
    ),
    "Compile model with profiling",
    deviceName
  )
  new(result)
  result.pCompiledModel = pCompiledModel

proc importModel*(core: Core, path: string, deviceName: string): CompiledModel =
  let blob = readFile(path)
  var pCompiledModel: ptr OvCompiledModel
  requireStatus(
    ov_core_import_model(
      core.pCore,
      if blob.len > 0: unsafeAddr blob[0] else: nil,
      blob.len.csize_t,
      deviceName.cstring,
      addr pCompiledModel
    ),
    "Import compiled model blob",
    path
  )
  new(result)
  result.pCompiledModel = pCompiledModel

proc compileOrImportModel*(
  core: Core,
  modelPath: string,
  deviceName: string,
  blobCachePath: string = "",
  enableProfiling: bool = false
): tuple[compiledModel: CompiledModel, cacheHit: bool] =
  if blobCachePath.len > 0 and fileExists(blobCachePath):
    result.compiledModel = core.importModel(blobCachePath, deviceName)
    if enableProfiling:
      requireStatus(
        nv_enable_perf_count(result.compiledModel.pCompiledModel),
        "Re-enable PERF_COUNT after blob import",
        blobCachePath
      )
    result.cacheHit = true
    return

  let model = core.readModel(modelPath)
  result.compiledModel =
    if enableProfiling:
      core.compileModelWithProfiling(model, deviceName)
    else:
      core.compileModel(model, deviceName)

  if blobCachePath.len > 0:
    let parentDir = splitFile(blobCachePath).dir
    if parentDir.len > 0:
      createDir(parentDir)
    result.compiledModel.exportModelToFile(blobCachePath)
