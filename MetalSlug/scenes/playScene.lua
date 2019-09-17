---------------------------------------------------------------------------------
--
-- scene2.lua
--
---------------------------------------------------------------------------------
local composer = require( "composer" )
local scene = composer.newScene()
require("lib.LD_LoaderX")
physics = require ("physics")

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------


-- Called when the scene's view does not exist:
function scene:create( event )
	print( "\n1: create event - playScene")
	local screenGroup = self.view
	self.runtime =0
	self.myLevel = {}
	self.stages = {}
	self.scrollPause =false
	self.state = 0
	self.speedX =1.5

	physics.start()

	self.myLevel= LD_Loader:new(self.view) -- instantiate the LD_Loader class
	self.myLevel:loadLevel("level" .. string.format("%02d", composer.level)) -- load a level/scene

	self.stages = self.myLevel:layerObjectsWithClass("markers","stage")

	--init properties as not all may be used per stage/marker
	for k, v in pairs (self.stages) do   --coppia chiave valore
		v.property["isActive"] = v.property["isActive"] or "false"
		v.property["scrollPause"] = v.property["scrollPause"] or "false"
	end

end

-- Called immediately after scene has moved onscreen:
function scene:show( event )
	local phase = event.phase
	print( "1: show event - playScene - ", phase )

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
		local prevScene = composer.getSceneName( "previous" )
		-- remove previous scene's view
		if (prevScene) then
			composer.removeScene( prevScene )
		end
    elseif ( phase == "did" ) then
        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.

		local stages = self.stages

		---------------------------------
		function getDeltaTime()
		---------------------------------
		   local temp = system.getTimer()  --Get current game time in ms
		   local dt = (temp-self.runtime) / (1000/display.fps)  --60fps or 30fps as base
		   self.runtime = temp  --Store game time
		   return dt
		end

		----------------------------------------------------------------------------
		-- Check for paths that have been reached and need to trigger something else
		----------------------------------------------------------------------------
		function onPathReached(path)
			-- check if follow path has completed i.e. come to a stop, currentpath =0

			-----------------------------
			if (composer.level == 1) then
			-----------------------------
				-- level 1 - stage 1 - chopper finished first path
				if (path.object.name == "chopper_1" and path.object.currentPath == 0) then
					if (self.state ==1) then
						-- now make chopper fly along path 2
						local obj = self.myLevel:getLayerObject("enemy","chopper_1")
						local fpath = self.myLevel:getLayerObject("enemy","chopper_path_2")
						local path = self.myLevel:getLayerObject("enemy",fpath.followPathProps.path) -- find the actual path that the follow path points to
						obj:followPath(path, fpath.followPathProps)  -- make the chopper follow the path using the params set in fpath
						self.state=2
					elseif (self.state ==2) then
						--chopper finished its maneover, set it back on path1 to leave screen
						local obj = self.myLevel:getLayerObject("enemy","chopper_1")
						local fpath = self.myLevel:getLayerObject("enemy","chopper_path_1")
						fpath.followPathProps.direction = 1
						local path = self.myLevel:getLayerObject("enemy",fpath.followPathProps.path) -- find the actual path that the follow path points to
						obj:followPath(path, fpath.followPathProps)  -- make the chopper follow the path using the params set in fpath
						self.state=3
					elseif (self.state == 3) then
						--chopper should have moved off screen, so remove it
						self.myLevel:removeLayerObject("enemy","chopper_1")
						self.myLevel:removeLayerObject("enemy","chopper_1_blades")
						self.scrollPause = false
						self.state=0
					end
				end
			---------------------------------
			elseif (composer.level == 2) then
			---------------------------------
				-- level 2 logic
			end
		end

		--------------------------------
		function onMarkerReached(marker)
		--------------------------------
			if (composer.level == 1) then
				local obj = self.myLevel:getLayerObject("enemy","chopper_1")
				obj.view:play() -- start animation
				local fpath = self.myLevel:getLayerObject("enemy","chopper_path_1")
				local path = self.myLevel:getLayerObject("enemy",fpath.followPathProps.path) -- find the actual path that the follow path points to
				obj:followPath(path, fpath.followPathProps)  -- make the chopper follow the path using the params set in fpath
			elseif (composer.level == 2) then
				-- level 2 logic
			end
		end

		-- update function
		---------------------------------
		function onUpdate(event)
		---------------------------------
			local pos = self.myLevel:getCameraPos()
			local dt = getDeltaTime()
			local k,v

			-- check for any markers that have been reached
			for k, v in pairs (self.stages) do
				if (v.property["isActive"] == "true" and pos.x >= v.x) then
					v.property["isActive"] = "false"

					print ("marker ", v.name, " reached")

					if (v.property["scrollPause"]) == 'true' then
						self.scrollPause=true
						self.state=1
						onMarkerReached(v)
					end
				end
			end
			-- move level/layers
			if (not self.scrollPause) and pos.x < 10360 then
				self.myLevel:move(self.speedX * dt,0)
			end
		end

		function init()
			self.myLevel:initLevel() -- only needed if you have objects that follow paths

			getDeltaTime()

			Runtime:addEventListener("enterFrame", onUpdate)
			Runtime:addEventListener("LD_PathEnded", onPathReached)
		end

		--slight pause before starting
		timer.performWithDelay( 500, init )

    end

end


-- Called when scene is about to move offscreen:
function scene:hide( event )

	print( "1: hide event" )

end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroy( event )
	physics.stop()
	runtime:removeEventListener("enterFrame")
	self.myLevel:removeLevel()
	self.myLevel = nil
	print( "((destroying playScene view))" )
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
