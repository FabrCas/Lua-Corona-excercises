---------------------------------------------------------------------------------
--
-- loadlevel2.lua
--
---------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local myTimer
local loadingImage

-- Called when the scene's view does not exist:
function scene:create( event )
	local sceneGroup = self.view
	
	-- completely remove mainmenu
	composer.removeScene( "levelselect" )
	
	print( "\nloadlevel2: create event" )
end


-- Called immediately after scene has moved onscreen:
function scene:show( event )
	local sceneGroup = self.view
	
	print( "loadlevel2: show event" )
	
	local loadScreen = function()
		loadingImage = display.newImageRect( "loading.png", 480, 320 )
		loadingImage.x = 240; loadingImage.y = 160
		sceneGroup:insert( loadingImage )
		
		local goToMenu = function()
			composer.gotoScene( "level2", "fade", 300  )
		end
		
		myTimer = timer.performWithDelay( 1000, goToMenu, 1 )
	end
	
	loadScreen()
	
end


-- Called when scene is about to move offscreen:
function scene:hide()

	if myTimer then timer.cancel( myTimer ); end
	
	print( "loadlevel2: hide event" )

end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroy( event )
	
	print( "destroying loadlevel2's view" )
end

---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- "create" event is dispatched if scene's view does not exist
scene:addEventListener( "create", scene )

-- "show" event is dispatched whenever scene transition has finished
scene:addEventListener( "show", scene )

-- "hide" event is dispatched before next scene's transition begins
scene:addEventListener( "hide", scene )

-- "destroy" event is dispatched before view is unloaded, which can be
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene