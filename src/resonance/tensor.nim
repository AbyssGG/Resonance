import c_api
import errors

type
  TensorObj* = object
    pTensor*: ptr OvTensor
  Tensor* = ref TensorObj

proc `=destroy`*(t: var TensorObj) =
  if t.pTensor != nil:
    ov_tensor_free(t.pTensor)
    t.pTensor = nil

proc makeShape(dims: seq[int64]): OvShape =
  result.rank = dims.len.int64
  result.dims = if dims.len > 0: unsafeAddr dims[0] else: nil

proc newTensor*(typ: OvElementType, dims: seq[int64], data: pointer): Tensor =
  var mutableDims = dims
  var shape = makeShape(mutableDims)
  var pTensor: ptr OvTensor
  requireStatus(
    ov_tensor_create_from_host_ptr(typ, shape, data, addr pTensor),
    "Create tensor from host pointer"
  )
  new(result)
  result.pTensor = pTensor

proc getData*[T](t: Tensor, _: typedesc[T]): ptr UncheckedArray[T] =
  var p: pointer
  requireStatus(ov_tensor_data(t.pTensor, addr p), "Get tensor data")
  result = cast[ptr UncheckedArray[T]](p)

proc setShape*(t: Tensor, dims: seq[int64]) =
  var mutableDims = dims
  var shape = makeShape(mutableDims)
  requireStatus(ov_tensor_set_shape(t.pTensor, addr shape), "Set tensor shape")

proc getShape*(t: Tensor): seq[int64] =
  var shape: OvShape
  requireStatus(ov_tensor_get_shape(t.pTensor, addr shape), "Get tensor shape")
  try:
    result = newSeq[int64](int(shape.rank))
    if shape.dims != nil:
      let dims = cast[ptr UncheckedArray[int64]](shape.dims)
      for i in 0 ..< int(shape.rank):
        result[i] = dims[i]
  finally:
    discard ov_shape_free(addr shape)

proc getSize*(t: Tensor): int =
  let dims = t.getShape()
  result = 1
  for dim in dims:
    result *= int(dim)
