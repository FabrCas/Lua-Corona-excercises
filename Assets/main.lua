-----------------------------------------------------------------------------------------
-- Level Director X- Assets Example
-- main.lua
-----------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

require("lib.LD_LoaderX")
physics = require ("physics")
physics.start()

--local vars to holder level and objects
local myLevel = {}
local birds={}

--instiatiate new level object
myLevel= LD_Loader:new()
-- load level
myLevel:loadLevel("level01")
-- init level - this starts any objects set to follow a path (can be omitted if paths not being used)
--myLevel:initLevel()
print(display.actualContentHeight) --640
print(display.contentWidth)  --960
print(display.actualContentWidth) --960
--spawn 10 birds from the bird asset
local i = 0

for i= 1,10 do
	local objProps =
	{
		name 	= "bird"..i,
		x		= math.random(20,400)+display.actualContentWidth, --considerazione: stiamo usando una configurazione landscape per l'app
		y		= math.random(40,300),
		assetName	= "bird",
		xScale = 1.5,
		yScale = 1.5,
	}

	local obj = myLevel:createObject("bg", objProps).view  --parametri: layer name e proprietà oggetti
	-- primo parametro il layer di appartenenza
	-- il metodo :crateObject ritorna il riferimento agli oggetti appena creati
	obj.speed = math.random(1,4)
	obj:setSequence("fly")
	obj:play()
	table.insert(birds,obj)
end

-- update function
function onUpdate(event)
	-- move level/layers
	myLevel:move(-2,0) --muove tutti gli oggetti che hanno sul proprio layer nella sezione parallax la proprietà repeat attiva con relativa velocità (x e y)

	--move birds
	for i= 1,#birds do
		birds[i].x = birds[i].x - (birds[i].speed)
		--check boundaries
		if (birds[i].x < - birds[i].width ) then --il birds ha superato i limiti dello schermo con tutto il corpo, respawnalo
			birds[i].x = math.random(20,400)+display.contentWidth
			birds[i].y = math.random(30,300)
			birds[i].speed = math.random(1,4)
		end
	end

end

Runtime:addEventListener("enterFrame", onUpdate)
