-----------------------------------------------------------------------------------------
-- Level Director - Basic vector example
-- main.lua
-----------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

require("lib.LD_LoaderX")
physics = require ("physics")
physics.start()

local myLevel = {}
myLevel= LD_Loader:new()
myLevel:loadLevel("Level01")

