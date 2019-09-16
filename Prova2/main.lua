-----------------------------------------------------------------------------------------
-- Level Director
-- main.lua
-- Created on lun set 16 15:44:26 2019
-----------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

require("lib.LD_LoaderX")
physics = require ("physics")
physics.start()

local myLevel = {}
myLevel= LD_Loader:new()
myLevel:loadLevel("livelloProva2") --replace with your level name here


