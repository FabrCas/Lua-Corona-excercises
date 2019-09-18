---------------------------------------------------------------------------------
--
-- level1.lua
--
---------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

local ui = require("ui")

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local btnAnim

local btnSound = audio.loadSound( "tapsound.wav" )

-- Called when the scene's view does not exist:
function scene:create( event )
	local sceneGroup = self.view
	
	-- completely remove loadlevel1
	composer.removeScene( "loadlevel1" )
	
	print( "\nlevel1: create event" )
end


-- Called immediately after scene has moved onscreen:
function scene:show( event )
	local sceneGroup = self.view
	
	print( "level1: show event" )
	
	local backgroundImage = display.newImageRect( "lvl1Screen.png", 480, 320 )
	backgroundImage.x = 240; backgroundImage.y = 160
	sceneGroup:insert( backgroundImage )
	
	local menuBtn
	
	local onPlayTouch = function( event )
		if event.phase == "release" and menuBtn.isActive then
			
			audio.play( btnSound )
			composer.gotoScene( "levelselect", "fade", 300  )
			
		end
	end
	
	menuBtn = ui.newButton{
		defaultSrc = "menubtn.png",
		defaultX = 200,
		defaultY = 60,
		overSrc = "menubtn.png",
		overX = 205,
		overY = 65,
		onEvent = onPlayTouch,
		id = "PlayButton",
		text = "",
		font = "Helvetica",
		textColor = { 255, 255, 255, 255 },
		size = 16,
		emboss = false
	}
	
	menuBtn.x = 240; menuBtn.y = 440
	sceneGroup:insert( menuBtn )
	
	btnAnim = transition.to( menuBtn, { time=500, y=240, transition=easing.inOutExpo } )

	
end


-- Called when scene is about to move offscreen:
function scene:hide()

	if btnAnim then transition.cancel( btnAnim ); end
	
	print( "level1: hide event" )

end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroy( event )
	
	print( "destroying level1's view" )
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