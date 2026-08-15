## Low-level OpenVINO C API bindings for Nim.

{.compile: "perf_count_wrapper.c".}

type
  OvStatus* = enum
    OK = 0
    GENERAL_ERROR = -1
    NOT_IMPLEMENTED = -2
    NETWORK_NOT_LOADED = -3
    PARAMETER_MISMATCH = -4
    NOT_FOUND = -5
    OUT_OF_BOUNDS = -6
    UNEXPECTED = -7
    REQUEST_BUSY = -8
    RESULT_NOT_READY = -9
    ALLOCATED = -10
    INFER_NOT_STARTED = -11
    NETWORK_NOT_READ = -12
    INFER_CANCELLED = -13

  OvElementType* = enum
    DYNAMIC = 0
    BOOLEAN = 1
    BF16 = 2
    F16 = 3
    F32 = 4
    F64 = 5
    I4 = 6
    I8 = 7
    I16 = 8
    I32 = 9
    I64 = 10
    U1 = 11
    U4 = 12
    U8 = 13
    U16 = 14
    U32 = 15
    U64 = 16

  OvAvailableDevices* = object
    devices*: cstringArray
    size*: csize_t

  OvShape* = object
    rank*: int64
    dims*: ptr int64

  OvCore* = object
  OvModel* = object
  OvCompiledModel* = object
  OvInferRequest* = object
  OvTensor* = object

  OvProfilingStatus* = enum
    PROFILING_NOT_RUN = 0
    PROFILING_OPTIMIZED_OUT = 1
    PROFILING_EXECUTED = 2

  OvProfilingInfo* = object
    status*: int32
    realTime*: int64
    cpuTime*: int64
    nodeName*: cstring
    execType*: cstring
    nodeType*: cstring

  OvProfilingInfoList* = object
    profilingInfos*: ptr UncheckedArray[OvProfilingInfo]
    size*: csize_t

const dllName* = "openvino_c.dll"
const OvPropertyKeyEnableProfiling* = "PERF_COUNT"

proc ov_core_create*(core: ptr ptr OvCore): OvStatus {.cdecl, dynlib: dllName, importc: "ov_core_create".}
proc ov_core_free*(core: ptr OvCore) {.cdecl, dynlib: dllName, importc: "ov_core_free".}
proc ov_core_get_available_devices*(core: ptr OvCore, devices: ptr OvAvailableDevices): OvStatus {.cdecl, dynlib: dllName, importc: "ov_core_get_available_devices".}
proc ov_available_devices_free*(devices: ptr OvAvailableDevices) {.cdecl, dynlib: dllName, importc: "ov_available_devices_free".}

proc ov_core_read_model*(
  core: ptr OvCore,
  model_path: cstring,
  bin_path: cstring,
  model: ptr ptr OvModel
): OvStatus {.cdecl, dynlib: dllName, importc: "ov_core_read_model".}

proc ov_core_compile_model*(
  core: ptr OvCore,
  model: ptr OvModel,
  device_name: cstring,
  property_args_size: csize_t,
  compiled_model: ptr ptr OvCompiledModel
): OvStatus {.cdecl, dynlib: dllName, importc: "ov_core_compile_model".}

proc ov_compiled_model_create_infer_request*(
  compiled_model: ptr OvCompiledModel,
  infer_request: ptr ptr OvInferRequest
): OvStatus {.cdecl, dynlib: dllName, importc: "ov_compiled_model_create_infer_request".}

proc ov_compiled_model_export_model*(
  compiled_model: ptr OvCompiledModel,
  export_model_path: cstring
): OvStatus {.cdecl, dynlib: dllName, importc: "ov_compiled_model_export_model".}

proc ov_core_import_model*(
  core: ptr OvCore,
  content: pointer,
  content_size: csize_t,
  device_name: cstring,
  compiled_model: ptr ptr OvCompiledModel
): OvStatus {.cdecl, dynlib: dllName, importc: "ov_core_import_model".}

proc ov_infer_request_set_input_tensor_by_index*(
  infer_request: ptr OvInferRequest,
  idx: csize_t,
  tensor: ptr OvTensor
): OvStatus {.cdecl, dynlib: dllName, importc: "ov_infer_request_set_input_tensor_by_index".}

proc ov_infer_request_get_output_tensor_by_index*(
  infer_request: ptr OvInferRequest,
  idx: csize_t,
  tensor: ptr ptr OvTensor
): OvStatus {.cdecl, dynlib: dllName, importc: "ov_infer_request_get_output_tensor_by_index".}

proc ov_infer_request_infer*(infer_request: ptr OvInferRequest): OvStatus {.cdecl, dynlib: dllName, importc: "ov_infer_request_infer".}
proc ov_infer_request_get_profiling_info*(infer_request: ptr OvInferRequest, profiling_infos: ptr OvProfilingInfoList): OvStatus {.cdecl, dynlib: dllName, importc: "ov_infer_request_get_profiling_info".}
proc ov_profiling_info_list_free*(profiling_infos: ptr OvProfilingInfoList) {.cdecl, dynlib: dllName, importc: "ov_profiling_info_list_free".}

proc ov_get_last_err_msg*(): cstring {.cdecl, dynlib: dllName, importc: "ov_get_last_err_msg".}

proc nv_compile_model_with_perf_count*(
  core: ptr OvCore,
  model: ptr OvModel,
  device_name: cstring,
  compiled_model: ptr ptr OvCompiledModel
): OvStatus {.cdecl, importc: "nv_compile_model_with_perf_count".}

proc nv_enable_perf_count*(compiled_model: ptr OvCompiledModel): OvStatus {.cdecl, importc: "nv_enable_perf_count".}

proc ov_tensor_create_from_host_ptr*(
  typ: OvElementType,
  shape: OvShape,
  host_ptr: pointer,
  tensor: ptr ptr OvTensor
): OvStatus {.cdecl, dynlib: dllName, importc: "ov_tensor_create_from_host_ptr".}

proc ov_tensor_data*(tensor: ptr OvTensor, data: ptr pointer): OvStatus {.cdecl, dynlib: dllName, importc: "ov_tensor_data".}
proc ov_tensor_get_shape*(tensor: ptr OvTensor, shape: ptr OvShape): OvStatus {.cdecl, dynlib: dllName, importc: "ov_tensor_get_shape".}
proc ov_tensor_set_shape*(tensor: ptr OvTensor, shape: ptr OvShape): OvStatus {.cdecl, dynlib: dllName, importc: "ov_tensor_set_shape".}
proc ov_shape_free*(shape: ptr OvShape): OvStatus {.cdecl, dynlib: dllName, importc: "ov_shape_free".}

proc ov_model_free*(model: ptr OvModel) {.cdecl, dynlib: dllName, importc: "ov_model_free".}
proc ov_compiled_model_free*(compiled_model: ptr OvCompiledModel) {.cdecl, dynlib: dllName, importc: "ov_compiled_model_free".}
proc ov_infer_request_free*(infer_request: ptr OvInferRequest) {.cdecl, dynlib: dllName, importc: "ov_infer_request_free".}
proc ov_tensor_free*(tensor: ptr OvTensor) {.cdecl, dynlib: dllName, importc: "ov_tensor_free".}
