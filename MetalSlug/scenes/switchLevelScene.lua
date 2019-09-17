---------------------------------------------------------------------------------
--
-- switchLevelScene.lua
--
---------------------------------------------------------------------------------
local composer = require( "composer" )
local scene = composer.newScene()

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------


-- Called when the scene's view does not exist:
function scene:create( event )
	local screenGroup = self.view
	
	print( "\n1: create event - switchLevelScene")
end


-- Called immediately after scene has moved onscreen:
function scene:show( event )
	local phase = event.phase
	print( "1: show event - switchLevelScene - ", phase )

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
		
		composer.gotoScene( "scenes.playScene")
		
    end	
	
end


-- Called when scene is about to move offscreen:
function scene:hide( event )
	
	print( "1: hide event - switchLevelScene" )
	
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroy( event )
	print( "((destroying switchLevelScene view))" )
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
