import std/strformat
import std/os

proc isFileExistsAtStore*(filename: string): string =
  var storagePath = os.getEnv("NIMG_STORAGE_PATH", os.getHomeDir())
  var filePath = fmt("{storagePath}/{filename}")

  if fileExists(filePath):
    return filePath
  else:
    return ""

proc createUploadDir*(): void =
  var storagePath = os.getEnv("NIMG_STORAGE_PATH", os.getHomeDir())

  if dirExists(storagePath) == false:
    echo fmt("Storage directory does not exist, creating at: {storagePath}")
    createDir(storagePath)

proc getDebugSetting*(): bool =
  var isDebugEnabled = os.getEnv("NIMG_ENVIRONMENT", "production")

  if isDebugEnabled == "development":
    return true
  else:
    return false
