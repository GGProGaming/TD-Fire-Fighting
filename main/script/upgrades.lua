#include "config.lua"

function init()
	KnownUpgrades = {}	
end

function tick()
	for i=1, #Housings do
		if not KnownUpgrades[i] then
			if GetBool("savegame.mod.housings."..i..".bought") then
				KnownUpgrades[i] = true				
				local body = FindBody("upgrade_"..i,true)				
				local bodyLocation = GetBodyTransform(body)
				local newPosition = GetBodyTransform(FindBody("upgrade_"..i.."_location",true))				
				SetBodyTransform(body,newPosition)			
				SetBodyTransform(FindBody("upgrade_"..i.."_location",true),bodyLocation)			
			end
		else
			if not GetBool("savegame.mod.housings."..i..".bought") then
				KnownUpgrades[i] = false				
				local body = FindBody("upgrade_"..i,true)				
				local bodyLocation = GetBodyTransform(body)
				local newPosition = GetBodyTransform(FindBody("upgrade_"..i.."_location",true))				
				SetBodyTransform(body,newPosition)			
				SetBodyTransform(FindBody("upgrade_"..i.."_location",true),bodyLocation)			
			end
		end
	end		
end