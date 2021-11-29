
function init()
	loop = LoadLoop("MOD/snd/tycoonV3.ogg")
	
	bgM = FindTrigger("bgm", true)
end

function tick(dt)
	if IsPointInTrigger(bgM, GetPlayerTransform().pos) == false then
		PlayLoop(loop, GetPlayerTransform().pos, 0.2)
	end
end