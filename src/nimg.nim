import prologue
import middleware
import std/os
import dotenv

load(os.getCurrentDir(), ".env")

proc Home*(ctx: Context) {.async.} =
  await ctx.staticFileResponse("./src/public/index.html", "")

proc UploadImg*(ctx: Context) {.async} =
  resp "upload"

when isMainModule:
  var app = newApp()
  app.addRoute("/", Home)
  app.addRoute("/upload", UploadImg, middlewares = @[auth()])
  app.run()
