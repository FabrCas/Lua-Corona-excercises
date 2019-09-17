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
	local screenGroup = self.view
	
	myLevel= LD_Loader:new(self.view)
	myLevel:loadLevel("car_demo")
	myLevel:initLevel()
	-- Touch event listener for button
	function onButtonClick( event )
		print ("touch")
		if event.phase == "began" then
			
			composer.gotoScene( "scene2", "zoomOutInFade", 300  )
			
			return true
		end
	end
	
	-- btn = myLevel:getLayerObject( "layer1","btnNext" )
	-- btn.onPress = onButtonClick
	
	print( "\n1: create event")
end


-- Called immediately after scene has moved onscreen:
function scene:show( event )
	local phase = event.phase

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
	
	print( "1: show event - ", phase )
	
	
end


-- Called when scene is about to move offscreen:
function scene:hide( event )
	
	print( "1: hide event" )
	
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroy( event )
	myLevel:removeLevel()
	myLevel = nil
	print( "((destroying scene 1's view))" )
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
