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
myLevel:initLevel()

local ball = myLevel:getLayerObject("Layer1","ball")
local fpath = myLevel:getLayerObject("Layer1","follow_path_11")  -- follow path object contains the params and a pointer to the actual path to follow 
local path = myLevel:getObject(fpath.followPathProps.path) -- find the actual path that the follow path points to 

ball:followPath(path, fpath.followPathProps)  -- make the ball follow the path using the params set in fpath 

