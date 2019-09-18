-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

local composer = require ( "composer" )

-- load first screen
composer.gotoScene( "loadmainmenu" )
print( "main loaded" )