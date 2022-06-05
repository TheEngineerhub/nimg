import prologue
import middleware
import std/strutils
import std/sequtils
import std/strformat
import std/os
import dotenv

load(os.getCurrentDir(), ".env")

proc Home*(ctx: Context) {.async.} =
  await ctx.staticFileResponse("./src/public/index.html", "")

proc UploadImg*(ctx: Context) {.async.} =
  var mimetypes: seq[string] = @["png", "jpg", "jpeg", "gif", "svg"]
  var file: UploadFile

  try:
    file = ctx.getUploadFile("image")
    var filename: string = file.filename
    file.save("/tmp", filename)
    var tempPath = fmt("/tmp/{filename}")
    var ext = filename.split('.')
    var filterExt = filter(mimetypes, proc(x: string): bool = x.contains(ext[1]))
    if len(filterExt) <= 0:
      await ctx.respond(Http400, fmt("Mimetype must be one of following: {mimetypes}"))
    else:
      var destDir = os.getEnv("STORAGE_PATH")
      copyFileToDir(tempPath, destDir)
      await ctx.respond(Http200, "Success")

    if fileExists(tempPath):
      removeFile(tempPath)
  except Exception:
    var e = getCurrentExceptionMsg()
    await ctx.respond(Http400, e)

proc GetImg*(ctx: Context) {.async.} =
  var storagePath = os.getEnv("STORAGE_PATH")
  var fileParam = ctx.getPathParams("filename")
  var filePath = fmt("{storagePath}/{fileParam}")

  if fileExists(filePath):
    await ctx.staticFileResponse(filePath, "")
  else:
    await ctx.respond(Http404, fmt("Image not found: {fileParam}"))

when isMainModule:
  var app = newApp()
  app.addRoute("/", Home, HttpGet)
  app.addRoute("/upload", UploadImg, HttpPost, middlewares = @[auth()])
  app.addRoute("/{filename}", GetImg, HttpGet)
  app.run()
