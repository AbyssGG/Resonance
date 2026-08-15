import c_api
import errors
import infer_request

type
  CompiledModelObj* = object
    pCompiledModel*: ptr OvCompiledModel
  CompiledModel* = ref CompiledModelObj

proc `=destroy`*(m: var CompiledModelObj) =
  if m.pCompiledModel != nil:
    ov_compiled_model_free(m.pCompiledModel)
    m.pCompiledModel = nil

proc createInferRequest*(m: CompiledModel): InferRequest =
  var pReq: ptr OvInferRequest
  requireStatus(
    ov_compiled_model_create_infer_request(m.pCompiledModel, addr pReq),
    "Create infer request"
  )
  new(result)
  result.pReq = pReq

proc exportModelToFile*(m: CompiledModel, path: string) =
  requireStatus(
    ov_compiled_model_export_model(m.pCompiledModel, path.cstring),
    "Export compiled model",
    path
  )
