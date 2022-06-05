import std/strformat
import std/os

proc isFileExistsAtStore(filename: string): string =
  var storagePath = os.getEnv("STORAGE_PATH")
  var filePath = fmt("{storagePath}/{filename}")

  if fileExists(filePath):
    return filePath
  else:
    return ""

export isFileExistsAtStore
