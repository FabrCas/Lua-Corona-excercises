-----------------------------------------------------------------------------------------
-- Level Director
-- main.lua
-- Created on Thu Dec 24 15:17:01 2015
-----------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

require("lib.LD_LoaderX")
physics = require ("physics")
physics.start()

local myLevel = {}
local dx = 0
local dy = 0
local btnLeft = nil
local btnRight = nil
local btnUp = nil
local player = nil
local coords = nil
local isActive = false
local camera = nil
local btnPressed = false
local scoreTxt = nil
local score = 0

local SPEED_X = 90
local SPEED_Y = 180
--also try these instead
--local SPEED_X = 150
--local SPEED_Y = 250


--"magTextureFilter" — The default magnification sampling filter applied whenever
--an image is loaded by Corona. Once an image is loaded the first time, the same sampling
 --filter will be applied for any subsequent loads of the same file. This is because
--textures are loaded once per file. Default value is "linear". Alternative value is "nearest".

--"minTextureFilter" — The default minification sampling filter applied whenever an image
 --is loaded by Corona. Once an image is loaded the first time, the same sampling filter
--  will be applied for any subsequent loads of the same file. This is because texture
	--s are loaded once per file. Default value is "linear". Alternative value is "nearest".
display.setDefault( "magTextureFilter", "nearest" )
display.setDefault( "minTextureFilter", "nearest" )

------------------------------------
local function gameLoop()
------------------------------------
	-- display current camera position
	local pos = myLevel:getCameraPos()

	coords.text = string.format("%04d", pos.x) .. ' , ' .. string.format("%04d", pos.y)
	scoreTxt.text = string.format("%d", score)

	-- if no buttons pressed then slow player down to a stop.
	local vx,vy = player:getLinearVelocity()

	if (not btnPressed) then
		if (vx < 0.1) then
			vx = vx * -0.5
		elseif (vx > 0.1) then
			vx = vx * 0.5
		else
			vx = 0
		end
	else
		vx= dx
	end
	player:setLinearVelocity(vx,vy)

end

------------------------------------
local function upPressed(event)
------------------------------------
	if (isActive) then
		btnPressed = true

		local vx,vy = player:getLinearVelocity()
		dx = vx
		dy = -SPEED_Y
		player:setLinearVelocity(vx,dy)
	end
end

------------------------------------
local function btnReleased(event)
------------------------------------
	player:setSequence("up")
	player:play()

	btnPressed = false

end

------------------------------------
local function leftPressed(event)
------------------------------------
	if (isActive) then
		player:setSequence("left")
		player:play()

		btnPressed = true

		dx = -SPEED_X
	end
end

------------------------------------
local function rightPressed(event)
------------------------------------
	if (isActive) then
		player:setSequence("right")
		player:play()

		btnPressed = true

		dx = SPEED_X
	end
end

---------------------------------------------------------------------------------
local function realPlayerCollision(self, event )
---------------------------------------------------------------------------------
	-- see if object we collided with has a class (defined in LD)
	local collisionClass = event.other.class

	if (string.len(collisionClass) > 0 ) then
		print ('collision ' .. event.phase .. ' with object class',collisionClass,event.other.name)
	end

	if ( event.phase == "began" ) then
		-- if we collided with a star then remove it
		if (collisionClass == 'Star') then
			myLevel:removeLayerObject("FG",event.other.name)
			-- add to score ...
			score = score + 100
		end
	end
end

---------------------------------------------------------------------------------
local function onCollision(self, event )
---------------------------------------------------------------------------------
	-- to avoid collision issues in corona we delay a frame then call the real collision function
	timer.performWithDelay(1, function() return realPlayerCollision( self, event) end )
end

---------------------------------------------------------------------------------
local function onScrollFinished2()
---------------------------------------------------------------------------------
	-- set collision handler
	player.collision = onCollision
	player:addEventListener('collision', player )

	-- set bounds for scrolling
	myLevel.level:setCameraBounds(
		(display.contentCenterX  ),
		-(display.contentCenterY * 2),
		(myLevel.level.canvasWidth - display.contentCenterX ),
		(myLevel.level.canvasHeight - display.contentCenterY )
	)

	-- enabled camera/object tracking
	myLevel:trackEnabled(true)

	isActive=true

	-- call move each frame
	Runtime:addEventListener( "enterFrame", gameLoop )

end

---------------------------------------------------------------------------------
local function onScrollFinished()
---------------------------------------------------------------------------------
	--end of level reached, now slide back to start of level indicated by contents of camera_2 object (0,0)
	camera = myLevel:getLayerObject("Markers","marker_1")
	timer.performWithDelay(400, function () return myLevel:slideCameraToPosition(camera.x, camera.y, 2500, easing.inOutQuad, onScrollFinished2) end )
end

-- load level
myLevel= LD_Loader:new()
myLevel:loadLevel("Level01") --replace with your level name here

-- Get local player object from level
player = myLevel:getLayerObject("Player","player").view

-- store player pos
player.tx = player.x
player.ty = player.y

-- get camera pos and slide to it (end of level)
camera = myLevel:getLayerObject("Markers","marker_2")
myLevel:slideCameraToPosition(camera.x, camera.y, 2500, easing.inOutQuad, onScrollFinished)

-- we want scrolling to track player in both directions
myLevel:setCameraFocus(player)

-- local copy of text obj to show coords and score
coords = myLevel:getLayerObject("Controls","coords").view
scoreTxt = myLevel:getLayerObject("Controls","score").view

-- Get local button objects and setup events
btnLeft = myLevel:getLayerObject("Controls","btnLeft")
btnRight = myLevel:getLayerObject("Controls","btnRight")
btnUp = myLevel:getLayerObject("Controls","btnUp")

btnLeft.onPress = leftPressed
btnRight.onPress = rightPressed
btnUp.onPress = upPressed

btnLeft.onRelease = btnReleased
btnRight.onRelease = btnReleased

btnLeft.onCancel = btnReleased
btnRight.onCancel = btnReleased
btnUp.onCancel = btnReleased
