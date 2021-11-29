local boilerplate = "savegame.mod"
local handleKey = boilerplate .. ".handle"
local weatherKey = boilerplate .. ".weather"

-- a system for persisting layer info from the savegame.mod registry
-- it is a recursive call to restart the level with an alternative set of layers,
-- collected with the registry being the primary source of truth, rather than however the XML is interpreted.

-- here we setup our base case. lookup whether the "handle" layer has been activated
-- the needReload acts as an block under update()

function disableWeapons()
	for id,tool in pairs(ListKeys("game.tool")) do
		SetBool("game.tool."..tool..".enabled", false)
	end
end

function init()
	levelStart = false
	
	if not GetBool(handleKey) then
		disableWeapons()
		needReload = true
	end
	ClearKey(handleKey)

end

-- restart the level and block further calls
function checkLevel()
	if levelStart then return end

	layers = "handle "
	layers = layers .. GetString(weatherKey)
	layers = layers .. GetString(boilerplate .. ".baselayers", "")
	levelStart = true
	StartLevel(GetString("game.levelid"), "MOD/main.xml", layers)
end

-- constantly check whether the level needs reloaded
function update()
	if needReload then
		checkLevel()
	end
end

function draw()
	if needReload then
		UiTranslate(0,0)
		UiColor(0, 0, 0)
		UiRect(UiWidth(), UiHeight())
	end
end