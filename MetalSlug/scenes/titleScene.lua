---------------------------------------------------------------------------------
--
-- scene1.lua
--
---------------------------------------------------------------------------------
local composer = require( "composer" )
local scene = composer.newScene()
require("lib.LD_LoaderX")
physics = require ("physics")
physics.start()

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local btn = nil
local myLevel = {}

-- Called when the scene's view does not exist:
function scene:create( event )
	print( "\n1: create event - titleScene")
	
	local screenGroup = self.view
	
	myLevel= LD_Loader:new(screenGroup) -- instantiate the LD_Loader class
	myLevel:loadLevel("title") -- load a level/scene 
	
	-- Touch event listener for button
	function onButtonClick( event )
		composer.gotoScene( "scenes.switchLevelScene" )
		return true
	end
	
	btn = myLevel:getLayerObject( "layer1","btnPlay" ) -- get a reference to the button object
	btn.onRelease = onButtonClick
	
end


-- Called immediately after scene has moved onscreen:
function scene:show( event )
	local phase = event.phase

	print( "1: show event - titleScene ", phase )

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
    elseif ( phase == "did" ) then
        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.
		local prevScene = composer.getSceneName( "previous" )	
		-- remove previous scene's view
		if (prevScene) then
			composer.removeScene( prevScene )
		end
    end	
	
end


-- Called when scene is about to move offscreen:
function scene:hide( event )
	
	print( "1: hide event - titleScene" )
	
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroy( event )
	print( "((destroying titleScene view))" )
	myLevel:removeLevel()
	myLevel = nil
end

---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

scene:addEventListener( "create", scene ) 
scene:addEventListener( "show", scene ) 
scene:addEventListener( "hide", scene ) 
scene:addEventListener( "destroy", scene ) 
---------------------------------------------------------------------------------

return scene
