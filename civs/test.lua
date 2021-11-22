function init()
	state = ""
	
	savedScore = false
	score = 0
end



function tick()
    state = GetString('level.state')

	if state == "win" and not savedScore then
		--Get the score from registry. These values are set by heist.lua
		score = GetInt("level.clearedprimary") + GetInt("level.clearedsecondary")

		--Save the new score if it's better than the current highscore
		local oldScore = GetInt("savegame.mod.score")
		SetInt("savegame.mod.score", score)
		--Do this only once
		savedScore = true
	end
end
    
