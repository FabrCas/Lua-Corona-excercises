-- SOME INITIAL SETTINGS
display.setStatusBar( display.HiddenStatusBar )


local hudGroup = display.newGroup()
local gameGroup = display.newGroup()
local levelGroup = display.newGroup()
local stars = display.newGroup()

-- EXTERNAL MODULES / LIBRARIES

local physics = require ("physics")

local mCeil = math.ceil
local mAtan2 = math.atan2
local mPi = math.pi
local mSqrt = math.sqrt

-- OBJECTS

local background
local ground
local powerShot
local arrow
local panda
local poof
local starGone

local scoreText
local gameOverDisplay

-- VARIABLES

local gameIsActive = false
local waitingForNewRound
local restartTimer

local counter
local timerInfo
local numSeconds = 30
local counterSize = 50

local gameScore = 0
local starWidth = 30
local starHeight = 30


local startNewRound = function()
	if panda then

		local activateRound = function()

			waitingForNewRound = false

			if restartTimer then
				timer.cancel( restartTimer )
			end

			ground:toFront()
			panda.x = 240;
			panda.y = 300;
			panda.rotation = 0
			panda.isVisible = true

			panda:setSequence("set")
			panda:play()


			local pandaLoaded = function()

				gameIsActive = true
				panda.inAir = false
				panda.isHit = false
				panda:toFront()

				panda.bodyType = "static"

			end

			transition.to( panda, { time=1000, y=225, onComplete=pandaLoaded } )
		end

		activateRound()

	end
end

local callNewRound = function()
	local isGameOver = false


	local pandaGone = function()

		panda:setLinearVelocity( 0, 0 )
		panda.bodyType = "static"
		panda.isVisible = false
		panda.rotation = 0


		poof.x = panda.x; poof.y = panda.y
		poof.alpha = 0
		poof.isVisible = true

		local fadePoof = function()
			transition.to( poof, { time=100, alpha=0 } )
		end
		transition.to( poof, { time=50, alpha=1.0, onComplete=fadePoof } )

		restartTimer = timer.performWithDelay( 300, function()
			waitingForNewRound = true;
			end, 1)

	end

	local poofTimer = timer.performWithDelay( 500, pandaGone, 1 )


	if isGameOver == false then
		restartTimer = timer.performWithDelay( 1500, startNewRound, 1 )
	end
end


local setScore = function( scoreNum )
	local newScore = scoreNum

	gameScore = newScore

	if gameScore < 0 then gameScore = 0; end

	scoreText.text = gameScore
	scoreText.xScale = 0.5; scoreText.yScale = 0.5
	scoreText.x = (480 - (scoreText.contentWidth * 0.5)) - 15
	scoreText.y = 20
end

local callGameOver = function()


	gameIsActive = false	--> temporarily disable gameplay touches, enterFrame listener
	physics.pause()

	panda:removeSelf()
	panda = nil
	stars:removeSelf()
	stars = nil


	-- Create all game over objects and insert them into the HUD group

	-- SHADE
	local shade = display.newRect( 0, 0, 480, 320 )
	shade:setFillColor( 0, 0, 0, 0.5)
	shade.x = display.contentCenterX
	shade.y = display.contentCenterY


	-- GAME OVER WINDOW

	gameOverDisplay = display.newImage( "gameOverScreen.png")

	local newScore = gameScore
	setScore( newScore )


	gameOverDisplay.x = 240; gameOverDisplay.y = 160
	gameOverDisplay.alpha = 0


	-- INSERT ALL ITEMS INTO GROUP
	hudGroup:insert( shade )
	hudGroup:insert( gameOverDisplay )

	-- FADE IN ALL GAME OVER ELEMENTS
	transition.to( shade, { time=200 } )
	transition.to( gameOverDisplay, { time=500, alpha=1 } )

	counter.isVisible = false

	-- MAKE SURE SCORE TEXT IS VISIBLE
	scoreText.isVisible = false
	scoreText.text = "Score: " .. gameScore
	scoreText.xScale = 0.5; scoreText.yScale = 0.5
	scoreText.x = 280
	scoreText.y = 160
	scoreText:toFront()
	timer.performWithDelay( 1000, function() scoreText.isVisible = true; end, 1 )

end


local drawBackground = function()

	background = display.newImage( "background.png")
	background.x = 240; background.y = 160

	gameGroup:insert( background )

	ground = display.newImage( "ground.png" )
	ground.x = 240; ground.y = 300

	local groundShape = { -240,-18, 240,-18, 240,18, -240,18 }
	physics.addBody( ground, "static", { density=1.0, bounce=0, friction=0.5, shape=groundShape } )

	gameGroup:insert( ground )

end

local hud = function()

	local helpText = display.newImage("help.png")
	helpText.x = 240; helpText.y = 160
	helpText.isVisible = true
	hudGroup:insert( helpText )

	timer.performWithDelay( 10000, function() helpText.isVisible = false; end, 1 )

	transition.to( helpText, { delay=9000, time=1000, x=-320, transition=easing.inOutExpo })

	-- COUNTER
	counter = display.newText( "Time: " .. tostring( numSeconds ), 0, 0, "Helvetica-Bold", counterSize )
	counter:setFillColor( 1, 1, 1 )
	counter.xScale = 0.5; counter.yScale = 0.5
	counter.x = 60; counter.y = 15
	counter.alpha = 0

	transition.to( counter, { delay=9000, time=1000, alpha=1, transition=easing.inOutExpo })

	hudGroup:insert( counter )


	-- SCORE DISPLAY
	scoreText = display.newText( "0", 470, 22, "Helvetica-Bold", 52 )
	scoreText:setFillColor( 1, 1, 1 )	--> white
	scoreText.text = gameScore
	scoreText.xScale = 0.5; scoreText.yScale = 0.5
	scoreText.x = (480 - (scoreText.contentWidth * 0.5)) - 15
	scoreText.y = 15
	scoreText.alpha = 0

	transition.to( scoreText, { delay=9000, time=1000, alpha=1, transition=easing.inOutExpo })

	hudGroup:insert( scoreText )

end


local myTimer = function()
   numSeconds = numSeconds - 1
      counter.text = "Time: " .. tostring( numSeconds )
      print(numSeconds)

      if numSeconds < 1 or stars.numChildren <= 0 then
      	timer.cancel(timerInfo)
      	panda:pause()
      	restartTimer = timer.performWithDelay( 300, function() callGameOver(); end, 1 )
      end

   end

local startTimer = function()
       print("Start Timer")
       timerInfo = timer.performWithDelay( 1000, myTimer, 0 )
end

local createPowerShot = function()
	powerShot = display.newImage( "glow.png")
	powerShot.xScale = 1.0; powerShot.yScale = 1.0
	powerShot.isVisible = false

	gameGroup:insert( powerShot )
end

local createPanda = function()

	local onPandaCollision = function( self, event )
		if event.phase == "began" then

			if panda.isHit == false then

				panda.isHit = true

				if event.other.myName == "star" then
					callNewRound( true, "yes" )
				else
					callNewRound( true, "no" )
				end

				if event.other.myName == "wall" then
					callNewRound( true, "yes" )
				else
					callNewRound( true, "no" )
				end


			elseif panda.isHit then
				return true
			end
		end
	end

	-- first, create the transparent arrow that shows up
	arrow = display.newImage( "arrow.png" )
	arrow.x = 240; arrow.y = 225
	arrow.isVisible = false

	gameGroup:insert( arrow )

	local sheetData = { width=128, height=128, numFrames=5, sheetContentWidth=384, sheetContentHeight=256 }
	local sheet = graphics.newImageSheet( "pandaSprite.png", sheetData )

	local sequenceData =
	{
		{ name="set", start=1, count=2, time=200 },
		{ name="crouch", start=3, count= 1, time=1 },
		{ name="air", start=4, count=2, time=100 }
	}


	panda = display.newSprite( sheet, sequenceData )

	panda:setSequence("set")
	panda:play()

	panda.x = 240; panda.y = 225
	panda.isVisible = false

	panda.isReady = false	--> Not "flingable" until touched.
	panda.inAir = false
	panda.isHit = false
	panda.isBullet = true
	panda.trailNum = 0

	panda.radius = 12
	physics.addBody( panda, "static", { density=1.0, bounce=0.4, friction=0.15, radius=panda.radius } )
	panda.rotation = 0

	-- Set up collisions
	panda.collision = onPandaCollision
	panda:addEventListener( "collision", panda )

	-- Create Poof Objects
	poof = display.newImage( "poof.png")
	poof.alpha = 1.0
	poof.isVisible = false

	gameGroup:insert( panda )
	gameGroup:insert( poof )
end

local onStarCollision = function( self, event )
	if event.phase == "began" and self.isHit == false then

		self.isHit = true
		print( "star collected!")
		self.isVisible = false
		--self.isBodyActive = false

		stars.numChildren = stars.numChildren - 1

		if stars.numChildren < 0 then
			stars.numChildren = 0
		end
    --rimuovi stella
		self.parent:remove( self )
		self = nil

		local newScore = gameScore + 500
		setScore( newScore )
	end
end

local onScreenTouch = function( event )
	if gameIsActive then
		if event.phase == "began" and panda.inAir == false then

			panda.y = 225
			panda.isReady = true
			powerShot.isVisible = true
			powerShot.alpha = 0.75
			powerShot.x = panda.x; powerShot.y = panda.y
			powerShot.xScale = 0.1; powerShot.yScale = 0.1

			arrow.isVisible = true

			panda:setSequence("crouch")
			panda:play()


		elseif event.phase == "ended" and panda.isReady then

			local fling = function()

				powerShot.isVisible = false
				arrow.isVisible = false

				local x = event.x
				local y = event.y
				local xForce = (panda.x-x) * 4
				local yForce = (panda.y-y) * 4

				panda:setSequence("air")
				panda:play()

				panda.bodyType = "dynamic"
				panda:applyForce( xForce, yForce, panda.x, panda.y )
				panda.isReady = false
				panda.inAir = true

			end

			transition.to( powerShot, { time=175, xScale=0.1, yScale=0.1, onComplete=fling } )

		end

		if powerShot.isVisible == true then

			local xOffset = panda.x
			local yOffset = panda.y

			-- Formula math.sqrt( ((event.y - yOffset) ^ 2) + ((event.x - xOffset) ^ 2) )
			local distanceBetween = mCeil(mSqrt( ((event.y - yOffset) ^ 2) + ((event.x - xOffset) ^ 2) ))

      --ingrandisci/ diminuisci il bagliore di tiro
			powerShot.xScale = -distanceBetween * 0.02
			powerShot.yScale = -distanceBetween * 0.02

      -- event, punto dove clicchi
			local angleBetween = mCeil(mAtan2( (event.y - yOffset), (event.x - xOffset) ) * 180 / mPi) + 90

			panda.rotation = angleBetween + 180
			arrow.rotation = panda.rotation
		end

	end
end

local reorderLayers = function()

	gameGroup:insert( levelGroup )
	ground:toFront()
	panda:toFront()
	poof:toFront()
	hudGroup:toFront()

end


local createStars = function()

	local numOfRows = 4
	local numOfColumns = 12
	local starPlacement = {x = (display.contentWidth * 0.5) - (starWidth * numOfColumns ) / 2  + 10, y = 50}

	for row = 0, numOfRows - 1 do
		for column = 0, numOfColumns - 1 do

			-- Create a star
			local star = display.newImage("star.png")
			star.name = "star"
			star.isHit = false
			star.x = starPlacement.x + (column * starWidth)
			star.y = starPlacement.y + (row * starHeight)
			physics.addBody(star, "static", {density = 1, friction = 0, bounce = 0, isSensor = true})
			stars.insert(stars, star)

			star.collision = onStarCollision
			star:addEventListener( "collision", star )

			local function starAnimation()
				local starRotation = function()
					transition.to( star, { time=10000, rotation = 1080, onComplete=starAnimation })
				end

				transition.to( star, { time=10000, rotation = -1080, onComplete=starRotation })
			end

			starAnimation()

		end
	end

	local leftWall  = display.newRect (0, 0, 0, display.contentHeight)
	leftWall.name = "wall"

    local rightWall = display.newRect (display.contentWidth, 0, 0, display.contentHeight)
    rightWall.name = "wall"

    physics.addBody (leftWall, "static", {bounce = 0.0, friction = 10})
    physics.addBody (rightWall, "static", {bounce = 0.0, friction = 10})


	reorderLayers()
end

local gameInit = function()

	-- PHYSICS
	physics.start( true )
	physics.setGravity( 0, 9.8 )

	drawBackground()
	createPowerShot()
	createPanda()
	createStars()
	hud()

	Runtime:addEventListener( "touch", onScreenTouch )


	-- STARTS THE LEVEL
	local roundTimer = timer.performWithDelay( 10000, function() startNewRound(); end, 1 )
	local gameTimer = timer.performWithDelay( 10000, function() startTimer(); end, 1 )
end

--physics.setDrawMode( "normal" )
--physics.setDrawMode( "hybrid" )
--physics.setDrawMode( "debug" )

gameInit()
