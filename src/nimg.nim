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
    var ext = filename.split('.')
    var filterExt = filter(mimetypes, proc(x: string): bool = x.contains(ext[1]))
    if len(filterExt) <= 0:
      await ctx.respond(Http400, fmt("Mimetype must be one of following: {mimetypes}"))
    else:
      var destDir = os.getEnv("STORAGE_PATH")
      copyFileToDir(fmt("/tmp/{filename}"), destDir)
      removeFile(fmt("/tmp/{filename}"))
      await ctx.respond(Http200, "Success")
  except:
    await ctx.respond(Http400, "Key must be 'image'")

when isMainModule:
  var app = newApp()
  app.addRoute("/", Home)
  app.addRoute("/upload", UploadImg, HttpPost, middlewares = @[auth()])
  app.run()
