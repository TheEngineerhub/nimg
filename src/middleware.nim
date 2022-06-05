import prologue
import std/os
import std/strutils
import dotenv

load(os.getCurrentDir(), ".env")

proc auth*(): HandlerAsync =
  result = proc(ctx: Context) {.async.} =
    let path = ctx.request.url.path
    let tokenParam = ctx.getQueryParams("token")
    let publicUpload = os.getEnv("PUBLIC_UPLOAD")

    if (os.getEnv("TOKEN") != tokenParam or isEmptyOrWhitespace(tokenParam)):
      if path.contains("/u") and publicUpload == "true":
        await switch(ctx)
      else:
        await ctx.respond(Http401, "Fuck off")
    else:
      await switch(ctx)
