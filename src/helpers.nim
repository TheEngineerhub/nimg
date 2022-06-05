import std/strformat
import std/os

proc isFileExistsAtStore(filename: string): bool =
  var storagePath = os.getEnv("STORAGE_PATH")
  var filePath = fmt("{storagePath}/{filename}")

  if fileExists(filePath):
    return true
  else:
    return false

export isFileExistsAtStore
