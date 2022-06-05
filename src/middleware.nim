import prologue
import std/os
import std/strutils

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
