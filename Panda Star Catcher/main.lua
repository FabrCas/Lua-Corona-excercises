display.setStatusBar (display.HiddenStatusBar)

local hudGroup = display.newGroup()
local gameGroup = display.newGroup()
local levelGroup = display.newGroup()
local stars= display.newGroup()

local physics= require ("physics")

local mCeil = math.ceil
local mAtan2= math.atan2
local mPi= math.pi
local mSqrt= math.sqrt

--game object
local background
local ground
local powerShot
local arrow
local panda
local poof
local startGone
local scoreText
local gameOverDisplay

--variables

local gameIsActive= false
local waitingForNewRound
local restartTimer
local counter
local timerInfo
local numSeconds= 30 --time the round strats at
local counterSize = 50
local gameScore = 0
local startWidth = 30
local startHeight= 30

local startNewRound= function ()
  if panda then
    local activateRound= function()
      waitingForNewRound= false
      
      if restartTimer then
        timer.cancel(restartTimer)
      end
      
      ground:toFront()
      panda.x= 240
      panda.y= 300
      panda.rotation= 0
      panda.isVisible= true
      
      local pandaLoaded= function()
        gameIsActive= true
        panda.inAir= false
        panda.isHit= false
        panda:toFront()
        panda.bodyType= "static"
      end
      
      transition.to(panda, {time=1000, y=225, onComplete=pandaLoaded})
    end
    activateRound()
  end
end


local callNewRound= function()
  local isGameOver= false
  local pandaGone= function()
    panda:setLinearVelocity(0,0)
    panda.bodyType= "static"
    panda.isVisible= false
    panda.rotation= 0
    
    poof.x= panda.x
    poof.y= panda.y
    poof.alpha= 0
    poof.isVisible=true
    
    local fadePoof= function()
      transition.to (poof, {time= 100, alpha=0})
    end
    transition.to (poof,{time=50, alpha= 1.0, onComplete=fadePoof})
    restartTimer= timer.performWithDelay(300, function() waitingForNewRound =true; end, 1)
  end
  local poofTimer = timer.performWithDelay(500, pandaGone, 1) 
  
  if isGameOver== false then
    restartTimer = timer.performWithDelay(1500, startNewRound, 1)
  end
end

local setScore = function (scoreNum) 
  local newScor= scoreNum
  if gameScore < 0 then gameScore = 0
  end
  scoreText.text= gameScore
  scoreText.xScale= 0.5; scoreText.yScale= 0.5
  scoreText.x= (480- (scoreText.contentWidth *0.5) -15)
  scoreText.y= 20
end

local callGameOver= function()
  gameIsActive= false
  physics.pause()
  panda:removeSelf()
  panda= nil
  start:removeSelf()
  stars= nil
  
  local shade = display.newRect (0,0,480,320)
  shade:setFillColor(0,0,0,0.5)
  shade.x= display.contentCenterX
  shade.y= display.contentCenterY
  
  gameOverDisplay= display.newImage("gameOverScreen.png")
  gameOverDisplay.x= 240
  gameOverDisplay.y= 150
  gameOverDisplay.alpha=0
  
  hudGroup:insert (shade) 
  hudGroup:insert (gameOverDisplay)
  
  transition.to( shade, {time=200})
  transition.to(gameOverDisplay, {time=500, alpha=1})
  
  local newScore= gameScore
  setScore (newScore) 
  counter.isVisible=false
  
  scoreText.isVisible= false
  scoreText.text= "Score: ".. gameScore
  scoreText.xScale= 0.5; scoreText.yScale=0.5
  scoreText.x = 280
  scoreText.y = 160
  scoreText:toFront()
  timer.performWithDelay(1000, function() scoreText.isVisible= true; end, 1)
end

local drawBackGround= function()
  background= display.newImage("background.png")
  background.x= 240
  background.y= 160
  gameGroup:insert(background)
  ground= display.newImage("ground.png")
  ground.x=240
  ground.y=300
  
  local groundshape= {-240, -18, 240, -18, 240, 18, -240, 18}
  physics.addBody (ground, "static", {density=1.0, bounce= 0, frinction= 0.5, shape=groundShape})
  gameGroup:insert (group)
end


      
    
    
