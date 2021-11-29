function init()
    climbTimer = 0
    startTrigger = FindTrigger("starttimer", true)
    endTrigger = FindTrigger("endtimer", true)
    beepSound = LoadSound("MOD/sound/beep.ogg")
    startTimer = false
    formatTime = 0
    usedSave = false

    highScore = GetFloat("savegame.mod.obstaclecourse.highscore")
end

function tick(dt)
    local vehicle = GetPlayerVehicle()
    if vehicle > 0 then
        if IsVehicleInTrigger(startTrigger, vehicle) then
            if not startTimer then
                PlaySound(beepSound)
                startTimer = true
            elseif climbTimer > 1 then
                PlaySound(beepSound)
                startTimer = true
                climbTimer = 0
            end
        end

        if IsVehicleInTrigger(endTrigger, vehicle) and startTimer then
            startTimer = false
            PlaySound(beepSound)
            if highScore == 0 or highScore > climbTimer then
                highScore = climbTimer
                SetBool("savegame.mod.obstaclecourse.usedsave", usedSave)
                SetFloat("savegame.mod.obstaclecourse.highscore", highScore)
            end
        end
    end

    if startTimer then
        climbTimer = climbTimer + dt
    end
end

function draw()
    UiPush()
        UiTranslate(20, UiHeight()-20)
        UiAlign("left")
    
        UiFont("regular.ttf", 30)
        if GetBool("savegame.mod.obstaclecourse.usedsave") then
            UiText("High score: "..SecondsToClock(highScore).."s - Used Save")
        else
            UiText("High score: "..SecondsToClock(highScore).."s")
        end

        UiTranslate(0, -50)
        if usedSave then
            UiText("Time: "..SecondsToClock(climbTimer).."s - Used Save")
        else
            UiText("Time: "..SecondsToClock(climbTimer).."s")
        end
    UiPop()
end

function SecondsToClock(seconds)
    local seconds = tonumber(seconds)

    if seconds <= 0 then
        return "00:00";
    else
        hours = string.format("%02.f", math.floor(seconds/3600));
        mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
        secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));
        return mins..":"..secs
    end
end

function handleCommand(cmd)
    if cmd == "quickload" then
        usedSave = true
	end
end