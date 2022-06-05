import std/strformat
import std/os

proc isFileExistsAtStore(filename: string): string =
  var storagePath = os.getEnv("NIMG_STORAGE_PATH", os.getHomeDir())
  var filePath = fmt("{storagePath}/{filename}")

  if fileExists(filePath):
    return filePath
  else:
    return ""

export isFileExistsAtStore
