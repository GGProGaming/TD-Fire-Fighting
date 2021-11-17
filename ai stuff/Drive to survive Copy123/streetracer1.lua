#include "minimap.lua"


function init()
	carNames = {"Drab 75", "Cayuse 550", "Taskmaster 4WD", "Eurus IV XXF", "Crownzygot XVC-alpha"}
	sndConfirm = LoadSound("MOD/sounds/confirm.ogg")
	sndReject = LoadSound("MOD/sounds/reject.ogg")
	sndWarning = LoadSound("MOD/sounds/warning-beep.ogg")
	sndPickup = LoadSound("MOD/sounds/pickup.ogg")
	sndRocket = LoadLoop("MOD/sounds/rocket.ogg")
	sndFail = LoadSound("MOD/sounds/fail.ogg")
	sndWin = LoadSound("MOD/sounds/win.ogg")
	sndReady = LoadSound("MOD/sounds/ready.ogg")
	sndStart = LoadSound("MOD/sounds/start.ogg")

	inTrigger = 0
	lastFrameInTrigger = 0
	totalPassed = 0
	wakeup = 0
	time = 0
	raceTime = 9999999999999
	startTimer = 0
	startTimerInt = math.floor(startTimer)
	warningColorMod = 1
	gameOver = false
	gameWin = false
	endFade = 0
	endFadePosition = nil
	fixedCamTransform = nil


	power = 0.1		-- Thrust power
	nitro = 0
	nitroInUse = false
	nitroShow = 0
	screenBlur = 0
	
	sceneBody = FindBody("scenebody",true)
	flags = FindBodies("flag",true)

	gateState = {}
	triggers = FindTriggers("gate",false)
	for i=1,#triggers do
		gateState[tonumber(GetTagValue(triggers[i], "gate"))] = 0
	end

	powerups = FindBodies("powerup", true)
	powerUpIndicator = 1
	powerUpIndicatorValues = {0,0,0}
	powerUpIndicatorTimers = {0,0,0}
	powerUpIndicatorYPos = {0,0,0}
	powerUpIndicatorColors = {{0,0,0},{0,0,0},{0,0,0}}
	powerupTimeout = 2

	spacebarTimeout = 0
	isDead = false

	roundCar = tonumber(GetTagValue(GetPlayerVehicle(),"car"))
	startCar = GetPlayerVehicle()

	if roundCar and HasKey("savegame.mod.besttime.car" .. roundCar) then
		firstRoundWithCar = false
		savedBest = GetFloat("savegame.mod.besttime.car" .. roundCar)
	else
		firstRoundWithCar = true
		savedBest = 0
	end
	
	minimap_init()
end
	
	
function tick(dt)
	time = time + dt
	if wakeup < 2 then
		if wakeup == 0 then
			for i=1, #flags do
				SetBodyVelocity(flags[i], Vec(.1,.1,.1))
			end
		end
		wakeup = wakeup + 1
		return
	end

	v = GetPlayerVehicle()

-- ###################################
-- #
-- # Powerups
-- #	
-- ###################################

	
	if not gameOver and not gameWin then
		for i = 1, #powerups do
			if startTimer <= 1 then -- No pickups unless game is started
				if not HasTag(powerups[i],"spent") then
					local pickupHit = false
					if v > 0 then
						QueryRejectBody(sceneBody)
						local powerupPos = VecAdd(GetBodyTransform(powerups[i]).pos,Vec(0,0.8,0)) -- Raise powerup origin from bottom to middle of powerup
						local hit, point, normal, shape = QueryClosestPoint(powerupPos, 2)
						if hit and VecLength(VecSub(powerupPos, point)) < 1.2 then
							local shapesVehicleBody = GetBodyVehicle(GetShapeBody(shape))
							if  shapesVehicleBody == v then
								pickupHit = true
							end
						end
					else
						if VecLength(VecSub(GetPlayerTransform().pos, GetBodyTransform(powerups[i]).pos)) < 1.5 then
							pickupHit = true
						end
					end
					if pickupHit then
						if GetTagValue(powerups[i],"powerup") == "boost" then
							if nitro <= 0  and v > 0 then
								SetValue("nitroShow", 1, "easeout", 0.5)
							end
							nitro = nitro + tonumber(GetTagValue(powerups[i],"value"))
							PlaySound(sndPickup)
							local indicatorColor = {0,1,0}
							addPowerupIndicator("+" .. GetTagValue(powerups[i],"value") ..  " NITRO!",indicatorColor)
						end
						if GetTagValue(powerups[i],"powerup") == "time" then
							raceTime = raceTime + tonumber(GetTagValue(powerups[i],"value"))
							PlaySound(sndPickup)
							local indicatorColor = {0,1,0}
							addPowerupIndicator("+" .. GetTagValue(powerups[i],"value") ..  "s TIME!",indicatorColor)
						end
						SetTag(powerups[i],"spent")
						local vt = GetBodyTransform(powerups[i])
						vt.pos[2] = vt.pos[2] - 25
						SetBodyTransform(powerups[i],vt)
					end
				end
			end
			-- Rotate powerups
			local pt = GetBodyTransform(powerups[i])
			pt.rot = QuatRotateQuat(pt.rot, QuatEuler(0,180 * dt,0))
			SetBodyTransform(powerups[i],pt)
		end
	end


	if nitro > 1000 then
		nitro = 1000
	end

-- ###################################
-- #
-- # Nitro
-- # More or less copied from Dennis Vehicle Booster mod
-- #	
-- ###################################
	
	if not gameOver and not gameWin then		
		if v > 0 and GetFloat("game.vehicle.health") > 0 then
			if nitro > 0 and nitroShow == 0 then
					SetValue("nitroShow", 1, "easeout", 0.5)
				end
			--Compute tail point and back direction on vehicle in world space
			local t = GetVehicleTransform(v)
			local p = TransformToParentPoint(t, Vec(0, 0.5, 3))
			local d = TransformToParentVec(t, Vec(0, 0, 1))
			if InputDown("rmb") and nitro > 0 then
				--Push the vehicle forwards
				local b = GetVehicleBody(v)	
				local v = GetBodyVelocity(b)
				v = VecAdd(v, VecScale(d, -power))
				SetBodyVelocity(b, v)

				--Engaged particle effects
				local pvel = VecScale(v, 0.7)
				SpawnParticle("fire", p, VecAdd(pvel, VecScale(d, 2)), 1.0, 0.5)
				SpawnParticle("smoke", p, VecAdd(pvel, VecScale(d, 5)), 1, 3.0)
				SpawnParticle("darksmoke", p, VecAdd(pvel, VecScale(d, 10)), 1.5, 1.0)
				
				--Play sound
				PlayLoop(sndRocket, t.pos)

				-- Decrease nitro
				nitro = nitro - 1
				if nitro <= 0 then
					SetValue("nitroShow", 0, "easein", 0.5)
				end
				if not nitroInUse then
					SetValue("screenBlur", 0.5, "cosine", 3)
				end
				nitroInUse = true
			else
				if nitro > 0 then
					--Idle particle effect
					SpawnParticle("fire", p, VecScale(d, 1), 0.3, 0.1)
					SpawnParticle("smoke", p, VecScale(d, 2), 0.5, 1.0)
				end
				if nitroInUse then
					SetValue("screenBlur", 0, "cosine", 1,5)
				end
				nitroInUse = false		
			end
		else
			if nitroShow == 1 then
				SetValue("nitroShow", 0, "easein", 0.5)
			end
			if nitroInUse then
				SetValue("screenBlur", 0, "cosine", 1,5)
			end
			nitroInUse = false
		end
	else
		if nitroShow == 1 then
			SetValue("nitroShow", 0, "easein", 0.5)
		end
	end

-- ###################################
-- #
-- # Racing gates
-- #	
-- ###################################

	inTrigger = 0
	if not gameOver and not gameWin then
		--if v > 0 then
			for i=1,#triggers do
				if IsVehicleInTrigger(triggers[i], v) or IsVehicleInTrigger(triggers[i], startCar) then
					if gateState[i] == 0 then
						if i == #triggers and totalPassed == 0 then
							--We just passed the finish gate, but now as the start line.
						else
							if i == 0 then
								gateState[i] = 0
								SetTag(triggers[i],"uipos","green")
								totalPassed = totalPassed + 1
								raceTime = raceTime + 15
								local indicatorColor = {0,1,0}
								addPowerupIndicator("CHECKPOINT!" ..  " +15s TIME!",indicatorColor)
								if totalPassed < #triggers then
									PlaySound(sndConfirm)
								end
							elseif i > 0 and gateState[i-0] == 0 then
								if i == #triggers and (not IsVehicleInTrigger(triggers[i], startCar) and v ~= startCar) then
									if lastFrameInTrigger == 0 then
										PlaySound(sndReject)
										local indicatorColor = {1,0,0}
										addPowerupIndicator("YOU MUST FINISH WITH THE START CAR!",indicatorColor)
									end
								else
									gateState[i] = 0
									SetTag(triggers[i],"uipos","green")
									totalPassed = totalPassed + 1
									if i < #triggers then
										raceTime = raceTime + 15
									end
									if totalPassed < #triggers then
										local indicatorColor = {0,1,0}
										addPowerupIndicator("CHECKPOINT!" ..  " +15s TIME!",indicatorColor)
										PlaySound(sndConfirm)
									end
								end
								
							else
								if lastFrameInTrigger == 0 then
									PlaySound(sndReject)
									local indicatorColor = {1,0,0}
									addPowerupIndicator("WRONG CHECKPOINT!",indicatorColor)
								end
							end
						end
					end
					inTrigger = inTrigger + 1
				end
			end
		--end
	end

-- ###################################
-- #
-- # Game WIN
-- #	
-- ###################################

	if (totalPassed == #triggers and not gameWin) then
		gameWin = true
		fixedCamTransform = GetCameraTransform()
		if v > 0 then
			endFadePosition = TransformToParentPoint(GetVehicleTransform(v), Vec(20, 30, 25))
		else
			endFadePosition = TransformToParentPoint(GetPlayerTransform(), Vec(20, 30, 25))
		end
		SetValue("endFade",1,"cosine",3)
		fixedCamTransform = GetCameraTransform()
		spacebarTimeout = GetTime()
		StopMusic()
		PlaySound(sndWin)
	end

	lastFrameInTrigger = inTrigger
	minimap_tick(dt)

-- ###################################
-- #
-- # Game FAIL
-- #	
-- ###################################

	if (raceTime <= 0 or GetPlayerHealth() <= 0)and not gameOver then
		gameOver = true
		if GetPlayerHealth() <= 0 and not (gameOver or gameWin) then
			isDead = true
		end
		fixedCamTransform = GetCameraTransform()
		if v > 0 then
			endFadePosition = TransformToParentPoint(GetVehicleTransform(v), Vec(20, 0, 25))
			endFadePosition[2] = GetVehicleTransform(v).pos[2] + 30
		else
			endFadePosition = TransformToParentPoint(GetPlayerTransform(), Vec(20, 0, 25))
			endFadePosition[2] = GetPlayerTransform().pos[2] + 30
		end
		SetValue("endFade",1,"cosine",3)
		spacebarTimeout = GetTime()
		StopMusic()
		PlaySound(sndFail)
		Explosion(GetPlayerPos(), 2)
	end

	local endPos, endRot

	if gameOver or gameWin then
		if v > 0 then
			endPos = VecLerp(fixedCamTransform.pos,endFadePosition,endFade)
			endRot = QuatSlerp(fixedCamTransform.rot,QuatLookAt(endPos, GetVehicleTransform(v).pos),endFade)
		else
			endPos = VecLerp(fixedCamTransform.pos,endFadePosition,endFade)
			endRot = QuatSlerp(fixedCamTransform.rot,QuatLookAt(endPos, GetPlayerTransform().pos),endFade)
		end
		SetCameraTransform(Transform(endPos,endRot))
	end

	if not gameOver and not gameWin and startTimer <= 1 then
		raceTime = raceTime - dt
	end

	if startTimer > 0 then
		startTimer = startTimer - dt
	end

	for i = 1, #powerUpIndicatorValues do
		if powerUpIndicatorTimers[i] >= 0 then
			powerUpIndicatorTimers[i] = powerUpIndicatorTimers[i] - dt
		end
	end

end

function addPowerupIndicator(s,c)
	powerUpIndicatorValues[powerUpIndicator] = s
	powerUpIndicatorTimers[powerUpIndicator] = powerupTimeout
	powerUpIndicatorYPos[powerUpIndicator] = (UiHeight()/2)
	powerUpIndicatorColors[powerUpIndicator][1] = c[1]
	powerUpIndicatorColors[powerUpIndicator][2] = c[2]
	powerUpIndicatorColors[powerUpIndicator][3] = c[3]
	powerUpIndicator = powerUpIndicator + 1
	if powerUpIndicator > #powerUpIndicatorValues then
		powerUpIndicator = 1
	end
end


function update(dt)
	if startTimer > 0 and math.floor(startTimer) < startTimerInt then
			startTimerInt = math.floor(startTimer)
			if math.floor(startTimer) > 0 then
				PlaySound(sndReady)
			else
				PlaySound(sndStart)
				PlayMusic("MOD/sounds/drive_to_survive.ogg")
			end
		end
	if raceTime <= 5 and not (gameOver or gameWin) then
		if raceTime + dt*1.5 >= math.ceil(raceTime) then
			warningColorMod = 1
			SetValue("warningColorMod", 0, "linear", 0.5)
			PlaySound(sndWarning)
		end
	else
		warningColorMod = 1
	end

	minimap_update()
end


function draw(dt)
	if startTimer > 0 then
		drawStart()

		-- Don't let the player drive unitl the 1 second left mark of the intro (When it says "DRIVE!")
		if startTimer > 1 then
			UiMakeInteractive()
		end
	else

	end
	if not gameOver and not gameWin then
		UiPush()
			UiFont("bold.ttf", 64)
			UiTranslate(UiCenter(), 60)
			UiAlign("center")
			UiTextShadow(0,0,0,0.5,1)
			local v = string.format("%02d", raceTime)
			if raceTime > 0 then
				v = v .. string.sub(string.format("%.2f", raceTime - v),2)
			else
				v = v .. string.sub(string.format("%.2f", raceTime - v),3)
			end
			if not gameOver then
				if not gameWin then
					UiColor(1,warningColorMod,warningColorMod)
					UiText(v)
				else
					UiColor(0,1,0)
					UiText(v)
					UiTranslate(0, 60)
					UiText("Nice driving!")
				end
			else
				UiColor(1,0,0)
				UiText("Game Over")
			end
			
		UiPop()
		
		UiBlur(screenBlur)
		
		UiPush()
			UiTranslate(0, UiHeight() - 220 * nitroShow)
			UiImage("MOD/images/nitro_tank.png")
			UiAlign("center middle")
			UiTranslate(107, 60)
			UiPush()
				UiTranslate(5, 5)
				UiRotate(-270 * (nitro/1000))
				UiImage("MOD/images/meter_hand_shadow.png")
			UiPop()
			UiRotate(-270 * (nitro/1000))
			UiImage("MOD/images/meter_hand.png")
		UiPop()
		minimap_draw()
	end
	drawPowerupIndicators(dt)
	if gameOver then
		UiMakeInteractive()
		drawGameOver()
	elseif gameWin then
		UiMakeInteractive()
		drawGameWin()
	end
end

function drawStart()
	UiPush()
		UiTranslate(UiWidth()/2, UiHeight()/2)
		UiAlign("center middle")
		UiScale(startTimer % 1 * 10)
		UiFont("bold.ttf", 128)
		local alpha = startTimer % 1
		UiColor(1,0,0, alpha)
		UiTextShadow(0,0,0,alpha/2,2)
		if math.floor(startTimer) > 0 then
			UiText(math.floor(startTimer))
		else
			UiText("DRIVE!")
		end
	UiPop()
end

function drawPowerupIndicators(dt)
	for i = 1, #powerUpIndicatorValues do
		if powerUpIndicatorTimers[i] >= 0 then
			local previousIndex = i - 1
			local nextIndex = i + 1
			if previousIndex < 1 then
				previousIndex = #powerUpIndicatorValues
			end
			if nextIndex > #powerUpIndicatorValues then
				nextIndex = 1
			end
			UiPush()
				UiAlign("center bottom")
				UiFont("bold.ttf", 48)
				powerUpIndicatorYPos[i] = powerUpIndicatorYPos[i] - 150 * dt
				UiTranslate(UiWidth()/2, powerUpIndicatorYPos[i])
				local alpha = (powerUpIndicatorTimers[i])
				if alpha > 1 then
					alpha = 1
				end
				UiColor(powerUpIndicatorColors[i][1],powerUpIndicatorColors[i][2],powerUpIndicatorColors[i][3], alpha)
				UiTextShadow(0,0,0,alpha/2,2)
				UiText(powerUpIndicatorValues[i])
			UiPop()
		end
	end
end

function drawGameOver()
	local winTitle = ""
	local winMessage = ""
	if isDead then
		winTitle = "Oh no!"
		winMessage = "Sorry, but not dying is a prerequisite for surviving."
	else
		if not firstRoundWithCar then
			winTitle = "Catastrophic failure!"
			winMessage = "I'm sorry to say, but this round goes to the crazy lunatic who planted the bomb."
		else
			winTitle = "Nice attempt, but no cigar..."
			winMessage = "The first time with a new car can always be a bit difficult. You should give it another try!"
		end
	end
	UiPush()
		UiTranslate(UiCenter(), UiHeight()-320)
		UiAlign("center")
		UiColor(1, 1, 1)
		
		UiImageBox("MOD/images/sign-02.png", 480, 260, 50, 50)
		UiFont("bold.ttf", 24)
		UiPush()
			local w, h = UiGetTextSize(winTitle)

			UiTranslate(0,30 + h)
			UiText(winTitle)
		
			UiFont("regular.ttf", 24)
			w, h = UiGetTextSize(winMessage)
			UiTranslate(0, h)
			UiWordWrap(400)
			UiText(winMessage)
		UiPop()
		if GetTime() > spacebarTimeout + 2 then
			UiPush()
				UiFont("regular.ttf", 24)
				UiTranslate(0, 260 - 40)
				UiText("[R] TO RETRY - [SPACE] TO SELECT CAR")
			UiPop()
			if InputPressed("space") then
				StartLevel("", "MOD/main.xml","nointro")
			end
			if InputPressed("r") then
				StartLevel("", "MOD/track.xml","car" .. roundCar)
			end
		end
	UiPop()
end

function drawGameWin()
	local winTitle = ""
	local winMessage = ""
	if roundCar ~= nil then
		if not firstRoundWithCar then
			if raceTime > savedBest then
				winTitle = "Great work! A new record!"
				winMessage = "You beat the old record with the " .. carNames[roundCar] .. " by " .. (string.format("%.2f", raceTime - savedBest)) .. " seconds!"
				SetFloat("savegame.mod.besttime.car" .. roundCar,raceTime)
			else
				winTitle = "Nice driving!"
				winMessage = "Unfortunately someone drove even better. Try shaving off " .. (string.format("%.2f", savedBest - raceTime)) .. " seconds to beat the high score for the " .. carNames[roundCar]
			end
		else
			winTitle = "Nice done!"
			winMessage = "You set the first record with the " .. carNames[roundCar]
			SetFloat("savegame.mod.besttime.car" .. roundCar,raceTime)

		end
	else
		winTitle = "Testing?"
		winMessage = "Seems like you didn't start in a car..."
	end
	UiPush()
		UiTranslate(UiCenter(), UiHeight()/2)
		UiAlign("center middle")
		UiFont("bold.ttf", 48)
		UiScale(endFade*6)
		UiColor(1, 1, 1)
		UiTextShadow(0,0,0,0.5,2)
		UiText(string.format("%.2f", raceTime))
	UiPop()
	UiPush()
		UiTranslate(UiCenter(), UiHeight()-320)
		UiAlign("center")
		UiColor(1, 1, 1)
		
		UiImageBox("MOD/images/sign-02.png", 480, 260, 50, 50)
		UiFont("bold.ttf", 24)
		UiPush()
			local w, h = UiGetTextSize(winTitle)

			UiTranslate(0,30 + h)
			UiText(winTitle)
		
			UiFont("regular.ttf", 24)
			w, h = UiGetTextSize(winMessage)
			UiTranslate(0, h)
			UiWordWrap(400)
			UiText(winMessage)
		UiPop()
		if GetTime() > spacebarTimeout + 2 then
			UiPush()
				UiFont("regular.ttf", 24)
				UiTranslate(0, 260 - 40)
				UiText("[R] TO RETRY - [SPACE] TO SELECT CAR")
			UiPop()
			if InputPressed("space") then
				StartLevel("", "MOD/main.xml","nointro")
			end
			if InputPressed("r") then
				StartLevel("", "MOD/track.xml","car" .. roundCar)
			end
		end
	UiPop()
end
