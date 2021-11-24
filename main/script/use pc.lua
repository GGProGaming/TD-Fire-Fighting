function init()
	screen = FindScreen("terminal", true)
end

function tick(dt)
	if GetPlayerScreen() ~= screen and GetPlayerInteractBody() == GetShapeBody(FindShape("keyboard",true)) and InputPressed("interact") then
		SetPlayerScreen(screen)
	end
	
end