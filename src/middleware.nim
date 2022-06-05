import prologue
import std/os
import std/strutils
import dotenv

load(os.getCurrentDir(), ".env")

proc auth*(): HandlerAsync =
  result = proc(ctx: Context) {.async.} =
    let tokenParam = ctx.getQueryParams("token")
    let publicUpload = os.getEnv("PUBLIC_UPLOAD")

    if (os.getEnv("TOKEN") != tokenParam or isEmptyOrWhitespace(tokenParam)) and
        publicUpload != "true":
      await ctx.respond(Http401, "Fuck off")

    await switch(ctx)
