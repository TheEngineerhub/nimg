import prologue
import std/os
import std/strutils
import std/strformat

proc auth*(): HandlerAsync =
  result = proc(ctx: Context) {.async.} =
    let path = ctx.request.url.path
    let tokenParam = ctx.getQueryParams("token")
    let publicUpload = os.getEnv("NIMG_PUBLIC_UPLOAD", "false")

    if (os.getEnv("NIMG_TOKEN") != tokenParam or isEmptyOrWhitespace(tokenParam)):
      if path.contains("/u") and publicUpload == "true":
        await switch(ctx)
      else:
        await ctx.respond(Http401, "Fuck off")
    else:
      await switch(ctx)

# Simple request logger middleware, like morgan.
proc logger*(): HandlerAsync =
  result = proc(ctx: Context) {.async.} =
    let getHostname: string = if isEmptyOrWhitespace(
        ctx.request.hostName): "http://localhost" else: ctx.request.hostName

    let getPort: string = if isEmptyOrWhitespace(ctx.request.port): os.getEnv(
        "NIMG_PORT") else: ctx.request.port

    echo fmt("{getHostname}:{getPort} - \"{ctx.request.reqMethod} {ctx.request.url.path} {ctx.response.httpVersion}\" {ctx.response.code}")
    await switch(ctx)
