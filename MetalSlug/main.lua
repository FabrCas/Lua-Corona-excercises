-----------------------------------------------------------------------------------------
-- Level Director - Composer example
-- main.lua
-----------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

local composer = require ("composer")

--set global level variable
composer.level = 1

-- load first screen
composer.gotoScene( "scenes.titleScene" )


