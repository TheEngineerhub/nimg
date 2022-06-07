# Package

version       = "1.0.0"
author        = "Berkcan Uçan"
description   = "No brainer image hosting."
license       = "GPL-3.0-or-later"
srcDir        = "src"
bin           = @["nimg"]


# Dependencies

requires "nim >= 1.6.6"
requires "prologue >= 0.6.0"
requires "dotenv >= 2.0.0"
requires "filetype >= 0.9.0"