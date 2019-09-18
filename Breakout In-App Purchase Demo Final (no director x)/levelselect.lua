---------------------------------------------------------------------------------
--
-- levelselect.lua
--
---------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

local ui = require("ui")
local movieclip = require( "movieclip" )
local store = require("store")

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local menuTimer

-- AUDIO
local tapSound = audio.loadSound( "tapsound.wav" )

--***************************************************

-- saveValue() --> used for saving high score, etc.

--***************************************************
local saveValue = function( strFilename, strValue )
	-- will save specified value to specified file
	local theFile = strFilename
	local theValue = strValue
	
	local path = system.pathForFile( theFile, system.DocumentsDirectory )
	
	-- io.open opens a file at path. returns nil if no file found
	local file = io.open( path, "w+" )
	if file then
	   -- write game score to the text file
	   file:write( theValue )
	   io.close( file )
	end
end

--***************************************************

-- loadValue() --> load saved value from file (returns loaded value as string)

--***************************************************
local loadValue = function( strFilename )
	-- will load specified file, or create new file if it doesn't exist
	
	local theFile = strFilename
	
	local path = system.pathForFile( theFile, system.DocumentsDirectory )
	
	-- io.open opens a file at path. returns nil if no file found
	local file = io.open( path, "r" )
	if file then
	   -- read all contents of file into a string
	   local contents = file:read( "*a" )
	   io.close( file )
	   return contents
	else
	   -- create file b/c it doesn't exist yet
	   file = io.open( path, "w" )
	   file:write( "0" )
	   io.close( file )
	   return "0"
	end
end

-- DATA SAVING
local level2Unlocked = 1
local level2Filename = "level2.data"
local loadedLevel2Unlocked = loadValue( level2Filename )


-- Called when the scene's view does not exist:
function scene:create( event )
	local sceneGroup = self.view
	
	-- completely remove mainmenu, level1, and level2
	composer.removeScene( "mainmenu" )
	composer.removeScene( "level1" )
	composer.removeScene( "level2" )
	
	print( "\nlevelselect: create event" )
end


-- Called immediately after scene has moved onscreen:
function scene:show( event )
	local sceneGroup = self.view
	
	print( "levelselect: show event" )
	
	local listOfProducts = 
	{
	    -- These Product IDs must already be set up in your store
	    -- Note, this simple test only has room for about 4 items, please adjust accordingly
	    -- The iTunes store will not validate bad Product IDs 
	    -- Replace with a valid Product ID from iTunes Connect
		"com.companyname.appname.NonConsumable", -- Non Consumable In-App Purchase
	} 
	
	----------------------------------
    -- In-App area
    ----------------------------------
    local validProducts = {} 
    local invalidProducts = {}
    
    local unpackValidProducts = function()
        print ("Loading product list")
        if not validProducts then
            native.showAlert( "In-App features not available", "initStore() failed", { "OK" } )        
        else
        	print( "Found " .. #validProducts .. " valid items ")
            for i=1, #invalidProducts do
            	-- Debug:  display the product info 
                native.showAlert( "Item " .. invalidProducts[i] .. " is invalid.",{ "OK" } )
                print("Item " .. invalidProducts[i] .. " is invalid.")
            end
 
        end
    end
    
    local loadProductsCallback = function( event )
	    -- Debug info for testing
        print("loadProductsCallback()")
        print("event, event.name", event, event.name)
        print(event.products)
        print("#event.products", #event.products)
        
	    validProducts = event.products
	    invalidProducts = event.invalidProducts    
	    unpackValidProducts ()
    end

    local transactionCallback = function( event )
	    if event.transaction.state == "purchased" then 
	        print("Transaction successful!")
			saveValue( level2Filename, tostring(level2Unlocked) )
	    elseif event.transcation.state == "restored" then 
			print("productIdentifier", event.transaction.productIdentifier)
			print("receipt", event.transaction.receipt)
			print("transactionIdentifier", event.transaction.transactionIdentifier)
			print("date", event.transaction.date)
			print("originalReceipt", event.transaction.originalReceipt)
	    elseif event.transaction.state == "cancelled" then
      	    print("Transaction cancelled by user.")
	    elseif event.transaction.state == "failed" then        
	        print("Transaction failed, type: ", event.transaction.errorType, event.transaction.errorString)
	        local alert = native.showAlert("Failed ", infoString,{ "OK" })
	    else
	        print("Unknown event")
			local alert = native.showAlert("Unknown ", infoString,{ "OK" })
   	    end
		-- Tell the store we are done with the transaction.
		-- If you are providing downloadable content, do not call this until
	    -- the download has completed.
		store.finishTransaction( event.transaction )    
    end

    local setupMyStore = function(event)
    	store.loadProducts( listOfProducts, loadProductsCallback )
    	print ("After store.loadProducts(), waiting for callback")
    end

	-- BACKGROUND IMAGE
	local backgroundImage = display.newImageRect( "levelSelectScreen.png", 480, 320 )
	backgroundImage.x = 240; backgroundImage.y = 160
	sceneGroup:insert( backgroundImage )
			
	-- LEVEL 1
	local level1Btn = movieclip.newAnim({"level1btn.png"}, 200, 60)
	level1Btn.x = 240; level1Btn.y = 100
	sceneGroup:insert( level1Btn )
	
	local function level1touch( event )
	  if event.phase == "ended" then
    		audio.play( tapSound )
   			composer.gotoScene( "loadlevel1", "fade", 300  )
	  end 
	end
	level1Btn:addEventListener( "touch", level1touch )
	level1Btn:stopAtFrame(1)
	
	-- LEVEL 2
	local level2Btn = movieclip.newAnim({"levelLocked.png","level2btn.png"}, 200, 60)
	level2Btn.x = 240; level2Btn.y = 180
	sceneGroup:insert( level2Btn )
	

	local onBuyLevel2Touch = function( event )
	  	if event.phase == "ended" and level2Unlocked ~= tonumber(loadedLevel2Unlocked) then
			audio.play( tapSound )	
			composer.gotoScene( "mainmenu", "fade", 300  )
				
		    local buyLevel2 = function ( product ) 
		  	    print ("Congrats! Purchasing " ..product)

		  	    -- Purchase the item
                if store.canMakePurchases then 
                  	store.purchase( {validProducts[1]} ) 
			    else  
             		native.showAlert("Store purchases are not available, please try again later",  { "OK" } ) 
      				end 
      			end 
            -- Enter your product ID here
            buyLevel2("com.companyname.appname.NonConsumable")  
													
		elseif event.phase == "ended" and level2Unlocked == tonumber(loadedLevel2Unlocked) then
			audio.play( tapSound )
		    composer.gotoScene( "loadlevel2", "fade", 300  )
	  	end
	end
	level2Btn:addEventListener( "touch", onBuyLevel2Touch )
	
	if level2Unlocked == tonumber(loadedLevel2Unlocked) then
	  level2Btn:stopAtFrame(2)
	end
		
	store.init( "apple", transactionCallback) 
  	timer.performWithDelay (500, setupMyStore)		
	
	-- CLOSE BUTTON			
	local closeBtn
	
	local onCloseTouch = function( event )
		if event.phase == "release" then
			
			audio.play( tapSound )
			composer.gotoScene( "loadmainmenu", "fade", 300  )
		
		end
	end
	
	closeBtn = ui.newButton{
		defaultSrc = "closebtn.png",
		defaultX = 100,
		defaultY = 30,
		overSrc = "closebtn.png",
		overX = 105,
		overY = 35,
		onEvent = onCloseTouch,
		id = "CloseButton",
		text = "",
		font = "Helvetica",
		textColor = { 255, 255, 255, 255 },
		size = 16,
		emboss = false
	}
	
	closeBtn.x = 80; closeBtn.y = 280
	closeBtn.isVisible = false
	sceneGroup:insert( closeBtn )
	
	menuTimer = timer.performWithDelay( 200, function() closeBtn.isVisible = true; end, 1 )
		
end


-- Called when scene is about to move offscreen:
function scene:hide()

	if menuTimer then timer.cancel( menuTimer ); end
	
	print( "levelselect: hide event" )

end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroy( event )
	
	print( "destroying levelselect's view" )
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