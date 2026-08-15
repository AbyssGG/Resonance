import std/strformat

import c_api

type
  OpenVinoError* = object of CatchableError

proc lastErrorDetail*(): string =
  let msg = ov_get_last_err_msg()
  if msg == nil:
    return ""
  result = $msg

proc raiseOpenVinoError*(action: string, status: OvStatus, detail: string = "") {.noreturn.} =
  var message = &"{action} failed with status {ord(status)} ({status})"
  if detail.len > 0:
    message.add(": " & detail)
  let last = lastErrorDetail()
  if last.len > 0 and last != detail:
    message.add(" | OpenVINO: " & last)
  raise newException(OpenVinoError, message)

proc requireStatus*(status: OvStatus, action: string, detail: string = "") =
  if status != OK:
    raiseOpenVinoError(action, status, detail)
