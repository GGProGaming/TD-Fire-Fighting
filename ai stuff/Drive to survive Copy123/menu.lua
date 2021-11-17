function init()
	carNames = {"Drab 75", "Cayuse 550", "Taskmaster 4WD", "Eurus IV XXF", "Crownzygot XVC-alpha"}
	carSounds = {"small1", "musclecar", "pickup", "sportscar", "racingcar"}
	crownzygotSound = LoadLoop("vehicle/racingcar-drive")
	ignitionSounds = {}
	idleSounds = {}
	turnoffSounds = {}
	for i = 1,#carSounds do
		ignitionSounds[i] = LoadSound("vehicle/" .. carSounds[i] .. "-ignition")
		idleSounds[i] = LoadLoop("vehicle/" .. carSounds[i] .. "-idle")
		turnoffSounds[i] = LoadSound("vehicle/" .. carSounds[i] .. "-turnoff")
	end
	idleIsPlaying = false

	carcams = FindLocations("carcam",true)
	carshapes = FindShapes("car",true)
	cars ={}
	for i = 1, #carshapes do
		cars[tonumber(GetTagValue(carshapes[i],"car"))] = carshapes[i]
		SetShapeEmissiveScale(carshapes[i],0)
	end

	cams = {}
	for i = 1, #carcams do
		cams[tonumber(GetTagValue(carcams[i],"carcam"))] = carcams[i]
	end

	SetPlayerSpawnTransform(GetLocationTransform(cams[1]))

	introFade = 1
	introCarAnim = -1
	introCarSound = 1
	doIntro = FindLocation("nointro",true) == 0
	if doIntro then
		SetValue("introCarAnim",2,"linear", 3)
		SetValue("introCarSound",0,"linear", 3)
	else
		SetValue("introFade",0,"cosine", 1.0)
	end	
	currentFrame = 0
	
	pan = 0
	panFromTransform = nil
	panToTransform = nil
	initPan = true
	fade = 0
	headlights = 1
	outlineIn = 1
	outlineOut = 0
	descriptionText = "start:text"
	cPos = GetLocationTransform(cams[1]).pos
	cRot = GetLocationTransform(cams[1]).rot

	currentCar = 1
	lastCar = 2
	savedBest = 0
	if HasKey("savegame.mod.besttime.car" .. currentCar) then
		savedBest = GetFloat("savegame.mod.besttime.car" .. currentCar)
	end
end

function tick(dt)
	if currentFrame < 5 then
		SetCameraTransform(GetLocationTransform(cams[1]))
		currentFrame = currentFrame + 1
		return
	end
	if InputPressed("space") and doIntro and introCarAnim >= 2 then
		doIntro=false
		SetValue("introFade",0,"cosine", 0.5)
	end

	if introFade <= 0.75 then
		if InputValue("mousewheel") ~= 0 then
			lastCar = currentCar
			currentCar = currentCar + InputValue("mousewheel")
			initPan = true
			PlaySound(turnoffSounds[lastCar])
			idleIsPlaying = false
		elseif InputPressed("left") then
			lastCar = currentCar
			currentCar = currentCar - 1
			initPan = true
			PlaySound(turnoffSounds[lastCar])
			idleIsPlaying = false
		elseif InputPressed("right") then
			lastCar = currentCar
			currentCar = currentCar + 1
			initPan = true
			PlaySound(turnoffSounds[lastCar])
			idleIsPlaying = false
		end
		if currentCar < 1 then
			currentCar = 5
		end
		if currentCar > 5 then
			currentCar = 1
		end
		if introFade <= 0 then
			if InputPressed("space") or InputPressed("lmb") then
				StartLevel("", "MOD/track.xml","car" .. currentCar)
			end
		end
	end

	if initPan then
		if pan > 0 then
			pan = 0
		else
			--GetLocationTransform(cams[lastCar])
		end
		panFromTransform = Transform(cPos, cRot)
		SetValue("fade",0,"cosine",0.25)
		headlights = 0
		SetValue("headlights",1,"cosine",0.125)
		panToTransform = GetLocationTransform(cams[currentCar])
		SetValue("pan",1,"cosine",0.0125)
		initPan = false
	end

	--DebugWatch("pan",pan)

	if pan > 0 then
		cPos = VecLerp(panFromTransform.pos, panToTransform.pos, pan)
		cRot = QuatSlerp(panFromTransform.rot, panToTransform.rot, pan)
		if pan >= 1 and introFade <= 0 then
			PlaySound(ignitionSounds[currentCar])
			pan = 0
		end
		local smoothTransform = Transform(VecLerp(GetCameraTransform().pos,cPos,0.05),QuatSlerp(GetCameraTransform().rot,cRot,0.05))
		SetCameraTransform(smoothTransform)
	else
		local smoothTransform = Transform(VecLerp(GetCameraTransform().pos,GetLocationTransform(cams[currentCar]).pos,0.05),QuatSlerp(GetCameraTransform().rot,GetLocationTransform(cams[currentCar]).rot,0.05))
		SetCameraTransform(smoothTransform)
		if fade == 0 then
			if HasKey("savegame.mod.besttime.car" .. currentCar) then
				savedBest = GetFloat("savegame.mod.besttime.car" .. currentCar)
			else
				savedBest = 0
			end
			SetValue("fade",1,"cosine",0.5)
			descriptionText = GetDescription(cars[currentCar])
		end
		if fade == 1 then
			PlayLoop(idleSounds[currentCar])
			idleIsPlaying = true
		end
	end

	SetShapeEmissiveScale(cars[currentCar], headlights)
	SetShapeEmissiveScale(cars[lastCar], 0)
end

function update(dt)

end

function draw()
	UiMakeInteractive()
	--UiEnableInput()
	if introFade < 1 then
		carInfo()
	end
	if introFade > 0 then
		UiBlur(introFade)
		drawIntro()
	end
end

function carInfo()
	UiPush()
		UiTranslate(UiCenter(), UiHeight() - 80)
		UiAlign("center bottom")
		UiColor(1 ,1 ,1 , fade)

		UiImageBox("MOD/images/sign-01.png", 480, 260, 75, 75)
		
		local desc = {}
		for d in string.gmatch(descriptionText,"([^:]+)") do 
			desc[#desc+1] = d
		end

		UiFont("bold.ttf", 36)
		local h = 36
		UiPush()
			UiColor(38/256, 57/256, 53/256, fade)
			UiTranslate(0,-260 + h + 25)
			UiText(string.upper(desc[1]))
			
			UiColor(1 ,1 ,1 , fade)
			UiFont("regular.ttf", 24)
			--w, h = UiGetTextSize("A " .. desc[2])
			h = 24
			UiTranslate(-200,22)
			UiAlign("left top")
			UiWordWrap(400)
			UiText(desc[2])
			UiTranslate(200,h*4)
		UiPop()
		UiPush()
			local timeInfo = ""
			if savedBest > 0 then
				timeInfo = "BEST TIME: " .. string.format("%.2f", savedBest)
			else
				timeInfo = "NO TIME RECORDED"

			end
			UiFont("bold.ttf", 30)
			--w, h = UiGetTextSize(timeInfo)
			UiTranslate(0, -32)
			UiText(timeInfo)
		UiPop()
		if introFade <= 0 then
			UiPush()
			UiFont("regular.ttf", 24)
				UiTranslate(0, 30)
				UiText("PRESS SPACE TO DRIVE THIS CAR")
			UiPop()	
		end
	UiPop()
end

function drawIntro()
	UiPush()
		local alpha = introFade
		--DebugWatch("introFade",introFade)
		if doIntro then
			if alpha > 1 then
				alpha = 1
			end
			UiColor(1.0, 1.0, 1.0, alpha)
			UiTranslate(0,0)
			--UiColor(0, 0, 0, alpha)
			UiImage("images/intro-background.jpg")
			local w, h = UiGetImageSize("images/crownzygot-top.png")
			local logoHpos = UiWidth() * 0.5
			local logoVpos = 288
			local hpos = -w + (UiWidth()+w) * introCarAnim
			local vpos = (-(UiWidth() * introCarAnim)/6.6)+392
			PlayLoop(crownzygotSound,GetCameraTransform().pos,introCarSound * (1-introCarSound))
			UiPush()
				--DebugWatch("introCarAnim",introCarAnim)
				UiAlign("left","top")
				UiPush()
					winWidth = hpos + w/2
					if winWidth < 0 then
						winWidth = 1
					end
					--UiTranslate(-10,-86)
					UiWindow(winWidth, 1000, true)
					UiPush()
						UiImage("images/tiretracks.png")
					UiPop()
					UiTranslate(logoHpos,logoVpos)
					UiAlign("center","middle")
					UiImage("images/dts-logo.png")
				UiPop()
				UiTranslate(hpos,vpos)
				UiImage("images/crownzygot-top.png")
			UiPop()
		
		
			UiColor(0.0, 0.0, 0.0, introCarAnim)
			if introCarAnim >= 2 then
				UiPush()
					UiTranslate(UiCenter()+100, UiHeight()*0.33)
					UiFont("bold.ttf", 64)
					UiPush()
						UiTranslate(0,250)
						UiRotate(6.0)
						UiAlign("left")
						UiTranslate(-500,0)
						UiText("THERE'S A BOMB IN YOUR CAR! ")
						UiFont("bold.ttf", 36)
						UiWordWrap(1000)
						UiTranslate(0,50)
						local w, h
						local line1 = "COMPLETE A LAP ON THE ROAD BY THE LÖCKELLE GOLF CLUB BEFORE THE TIME RUNS OUT."
						local line2 = "- THERE'S TIME BONUSES AND NITRO PICK UPS"
						local line3 = "- PASS THROUGH THE GATES IN THE CORRECT ORDER"
						local line4 = "- YOU MUST DRIVE THE START CAR THROUGH THE END GATE"

						UiText(line1)
						local w, h = UiGetTextSize(line1)
						UiTranslate(0,h*1.1)

						UiText(line2)
						w, h = UiGetTextSize(line2)
						UiTranslate(0,h*1.1)

						UiText(line3)
						w, h = UiGetTextSize(line3)
						UiTranslate(0,h+1.1)

						UiText(line4)
					UiPop()
				UiPop()
			

				UiTranslate(UiCenter(),UiHeight() - 75)
				UiAlign("center")
				UiFont("bold.ttf", 48)
				UiText("PRESS SPACE TO CONTINUE")
			end
		end
	UiPop()
end
