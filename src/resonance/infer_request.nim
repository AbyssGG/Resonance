import c_api
import errors
import tensor

type
  InferRequestObj* = object
    pReq*: ptr OvInferRequest
  InferRequest* = ref InferRequestObj

  ProfilingInfo* = object
    status*: int
    realTimeUs*: int64
    cpuTimeUs*: int64
    nodeName*: string
    execType*: string
    nodeType*: string

proc `=destroy`*(req: var InferRequestObj) =
  if req.pReq != nil:
    ov_infer_request_free(req.pReq)
    req.pReq = nil

proc setInputTensor*(req: InferRequest, idx: int, t: Tensor) =
  requireStatus(
    ov_infer_request_set_input_tensor_by_index(req.pReq, idx.csize_t, t.pTensor),
    "Set input tensor",
    "index=" & $idx
  )

proc getOutputTensor*(req: InferRequest, idx: int): Tensor =
  var pTensor: ptr OvTensor
  requireStatus(
    ov_infer_request_get_output_tensor_by_index(req.pReq, idx.csize_t, addr pTensor),
    "Get output tensor",
    "index=" & $idx
  )
  new(result)
  result.pTensor = pTensor

proc infer*(req: InferRequest) =
  requireStatus(ov_infer_request_infer(req.pReq), "Run inference")

proc getProfilingInfo*(req: InferRequest): seq[ProfilingInfo] =
  var infoList: OvProfilingInfoList
  requireStatus(
    ov_infer_request_get_profiling_info(req.pReq, addr infoList),
    "Get profiling info"
  )
  try:
    result = newSeq[ProfilingInfo](int(infoList.size))
    for i in 0 ..< int(infoList.size):
      let p = addr infoList.profilingInfos[i]
      result[i] = ProfilingInfo(
        status: int(p.status),
        realTimeUs: p.realTime,
        cpuTimeUs: p.cpuTime,
        nodeName: if p.nodeName != nil: $p.nodeName else: "",
        execType: if p.execType != nil: $p.execType else: "",
        nodeType: if p.nodeType != nil: $p.nodeType else: ""
      )
  finally:
    if infoList.size > 0:
      ov_profiling_info_list_free(addr infoList)
