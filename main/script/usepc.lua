function init()
	screen = FindScreen("terminal", true)
end

function tick(dt)
	if GetPlayerInteractBody() == GetShapeBody(FindShape("keyboard",true)) and InputPressed("interact") and GetPlayerScreen() ~= screen then
		SetPlayerScreen(screen)
	end
end