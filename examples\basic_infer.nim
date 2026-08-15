import std/os
import std/strutils

import resonance

proc main() =
  if paramCount() < 2:
    echo "Usage: basic_infer <model.xml> <device> [blob-cache-path]"
    quit(1)

  let modelPath = paramStr(1)
  let deviceName = paramStr(2)
  let blobCachePath = if paramCount() >= 3: paramStr(3) else: ""

  let core = newCore()
  echo "Available devices: ", core.getAvailableDevices().join(", ")

  let prepared = core.compileOrImportModel(
    modelPath = modelPath,
    deviceName = deviceName,
    blobCachePath = blobCachePath,
    enableProfiling = true
  )

  echo "Prepared model on ", deviceName
  echo "Blob cache hit: ", prepared.cacheHit

main()
