import std/strformat
import std/os

proc isFileExistsAtStore(filename: string): string =
  var storagePath = os.getEnv("NIMG_STORAGE_PATH", os.getHomeDir())
  var filePath = fmt("{storagePath}/{filename}")

  if fileExists(filePath):
    return filePath
  else:
    return ""

proc createUploadDir(): void =
  var storagePath = os.getEnv("NIMG_STORAGE_PATH", os.getHomeDir())

  if dirExists(storagePath) == false:
    echo fmt("Storage directory does not exist, creating at: {storagePath}")
    createDir(storagePath)

proc getDebugSetting(): bool =
  var isDebugEnabled = os.getEnv("NIMG_DEBUG", "true")

  if isDebugEnabled == "true":
    return true
  else:
    false

export isFileExistsAtStore
export createUploadDir
export getDebugSetting
