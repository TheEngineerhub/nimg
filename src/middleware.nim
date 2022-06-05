import prologue
import std/os
import std/strutils
import dotenv

load(os.getCurrentDir(), ".env")

proc auth*(): HandlerAsync =
  result = proc(ctx: Context) {.async.} =
      let tokenParam = ctx.getQueryParams("token")
    
      if (os.getEnv("TOKEN") != tokenParam or isEmptyOrWhitespace(tokenParam)):
        await ctx.respond(Http401, "fuck off")

      await switch(ctx)

