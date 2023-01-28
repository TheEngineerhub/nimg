import prologue
import prologue/middlewares/cors
import filetype
from ./middleware import auth, logger
from ./helpers import isFileExistsAtStore, createUploadDir, getDebugSetting
import std/strutils
import std/sequtils
import std/strformat
import std/os
import dotenv

var NIMG_ENVIRONMENT = os.getEnv("NIMG_ENVIRONMENT", "production")

if NIMG_ENVIRONMENT == "development":
  overload(os.getCurrentDir(), ".env")

proc Home*(ctx: Context) {.async.} =
  await ctx.respond(Http200, "nimg | No brainer image hosting.\n\nVisit: https://github.com/TheEngineerhub/nimg")

proc UploadImg*(ctx: Context) {.async.} =
  var mimetypes: seq[string] = @["jpeg", "jp2", "png", "gif", "webp", "cr2",
      "tiff", "bmp", "jxr", "psd", "ico", "dwg", "pdf"]
  var file: UploadFile

  try:
    file = ctx.getUploadFile("file")
    var filename: string = file.filename

    if isFileExistsAtStore(filename) != "":
      return ctx.respond(Http200, "File already exists")

    file.save("/tmp", filename)
    var tempPath: string = fmt("/tmp/{filename}")
    var ext: string = matchFile(tempPath).mime.subType
    var filterExt = filter(mimetypes, proc(x: string): bool =
      if isEmptyOrWhiteSpace(ext): return false else: x.contains(ext))

    if len(filterExt) <= 0:
      await ctx.respond(Http400, fmt("Mimetype must be one of following: {mimetypes}"))
    else:
      var destDir: string = os.getEnv("NIMG_STORAGE_PATH", os.getHomeDir())
      copyFileToDir(tempPath, destDir)
      await ctx.respond(Http200, fmt("{ctx.request.hostName}/{filename}"))

    if fileExists(tempPath):
      removeFile(tempPath)
  except Exception:
    var e = getCurrentExceptionMsg()
    await ctx.respond(Http400, e)

proc GetImg*(ctx: Context) {.async.} =
  var fileParam: string = ctx.getPathParams("filename")
  var getFile: string = isFileExistsAtStore(fileParam)

  if getFile != "":
    await ctx.staticFileResponse(getFile, "")
  else:
    await ctx.respond(Http404, fmt("File not found: {fileParam}"))

proc DelImg*(ctx: Context) {.async.} =
  var fileParam: string = ctx.getPathParams("filename")
  var getFile: string = isFileExistsAtStore(fileParam)

  if getFile != "":
    removeFile(getFile)
    await ctx.respond(Http200, fmt("Deleted: {fileParam}"))
  else:
    await ctx.respond(Http404, fmt("File not found: {fileParam}"))

proc go404*(ctx: Context) {.async.} =
  await ctx.respond(Http404, "Not found!")

when isMainModule:
  var settings = newSettings(appName = os.getEnv("NIMG_APP_NAME", "nimg"),
                         debug = getDebugSetting(),
                         port = Port(parseInt(os.getEnv("NIMG_PORT", "8080"))))

  createUploadDir()
  echo fmt("nimg is listening at :{settings.port}")
  var app = newApp(settings = settings)
  app.use(CorsMiddleware(allowOrigins = @["*"]))
  app.use(logger())
  app.addRoute("/", Home, HttpGet)
  app.addRoute("/{filename}", GetImg, HttpGet)
  app.addRoute("/d/{filename}", DelImg, HttpGet, middlewares = @[auth()])
  app.addRoute("/u", UploadImg, HttpPost, middlewares = @[auth()])
  app.registerErrorHandler(Http404, go404)
  app.run()
