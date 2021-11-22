function init()
	screen = FindScreen("terminal", true)
end

function tick(dt)
	--DebugPrint(GetPlayerInteractBody())

	if GetPlayerScreen() ~= screen and GetPlayerInteractBody() == 3 and InputPressed("interact") then
		SetPlayerScreen(screen)
	end
	
end