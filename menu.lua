function init()

	carcams = FindLocations("carcam",true)
	carshapes = FindShapes("car",true)
	lights1 = FindShape("light1",true)
	fpslight = FindShape("fps",true)
	lights2 = FindShape("light2",true)
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
	fps = false
	fpsex = false
	fpsv1 = false
	fpsv2 = false
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
	lastCar = 4
end
function tick(dt)
	if currentFrame < 5 then
		SetCameraTransform(GetLocationTransform(cams[1]))
		currentFrame = currentFrame + 1
		return
	end
	if doIntro  then
		doIntro=false
		SetValue("introFade",0,"cosine", 0.5)
	end

	if introFade <= 0.75 then
		if InputValue("mousewheel") ~= 0 then
			lastCar = currentCar
			currentCar = currentCar + InputValue("mousewheel")
			initPan = true
		elseif InputPressed("left") then
			lastCar = currentCar
			currentCar = currentCar - 1
			initPan = true
		elseif InputPressed("right") then
			lastCar = currentCar
			currentCar = currentCar + 1
			initPan = true
		end
		if currentCar < 1 then
			currentCar = 4
		end
		if currentCar > 4 then
			currentCar = 1
		end
		if introFade <= 0 then
			if currentCar == 4 and GetBool("savegame.mod.fps") then
			if currentCar == 4 and InputPressed("space") or InputPressed("lmb") then
			SetBool("savegame.mod.fps", false)
			end
			else
			if currentCar == 4 and InputPressed("space") or InputPressed("lmb") then
			SetBool("savegame.mod.fps", true)
			end
	end

			if currentCar == 3 and GetBool("savegame.mod.v1") then
			if currentCar == 3 and InputPressed("space") or InputPressed("lmb") then
			SetBool("savegame.mod.v1", false)
			end
			else
			if currentCar == 3 and InputPressed("space") or InputPressed("lmb") then
			SetBool("savegame.mod.v1", true)
			end
	end

			if currentCar == 2 and GetBool("savegame.mod.v2") then
			if currentCar == 2 and InputPressed("space") or InputPressed("lmb") then
			SetBool("savegame.mod.v2", false)
			end
			else
			if currentCar == 2 and InputPressed("space") or InputPressed("lmb") then
			SetBool("savegame.mod.v2", true)
			end
	end
			if currentCar ~= 4 and currentCar ~= 3 and currentCar ~= 2 and InputPressed("space") or InputPressed("lmb") then
				if GetBool("savegame.mod.v1") and GetBool("savegame.mod.v2") and GetBool("savegame.mod.fps") then
					StartLevel("", "MOD/mainmapfps.xml","v2 car", "v1 car" .. currentCar) 
			else
				if GetBool("savegame.mod.v1") and GetBool("savegame.mod.fps") then
					StartLevel("", "MOD/mainmapfps.xml","v1 car" .. currentCar)
			else
				if GetBool("savegame.mod.v2") and GetBool("savegame.mod.fps") then
					StartLevel("", "MOD/mainmapfps.xml","v2 car" .. currentCar)
			else
				if GetBool("savegame.mod.fps") then
					StartLevel("", "MOD/mainmapfps.xml","car" .. currentCar)
			else
				if GetBool("savegame.mod.v1") and GetBool("savegame.mod.v2") then
					StartLevel("", "MOD/mainmap.xml","v2 car", "v1 car" .. currentCar)
			else
				if GetBool("savegame.mod.v1") then
					StartLevel("", "MOD/mainmap.xml","v1 car" .. currentCar)
			else
				if GetBool("savegame.mod.v2") then
					StartLevel("", "MOD/mainmap.xml","v2 car" .. currentCar)
			else
				StartLevel("", "MOD/mainmap.xml","car" .. currentCar)





			end
		end
	end
end
end
end
end
end
end
end
	


			if GetBool("savegame.mod.v2") then
					SetShapeEmissiveScale(lights2,1)
			else
					SetShapeEmissiveScale(lights2,0)
		end
			if GetBool("savegame.mod.v1") then
					SetShapeEmissiveScale(lights1,1)
			else
					SetShapeEmissiveScale(lights1,0)
		end
			if GetBool("savegame.mod.fps") then
					SetShapeEmissiveScale(fpslight,1)
			else
					SetShapeEmissiveScale(fpslight,0)
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
			pan = 0
		end
		local smoothTransform = Transform(VecLerp(GetCameraTransform().pos,cPos,0.05),QuatSlerp(GetCameraTransform().rot,cRot,0.05))
		SetCameraTransform(smoothTransform)
	else
		local smoothTransform = Transform(VecLerp(GetCameraTransform().pos,GetLocationTransform(cams[currentCar]).pos,0.05),QuatSlerp(GetCameraTransform().rot,GetLocationTransform(cams[currentCar]).rot,0.05))
		SetCameraTransform(smoothTransform)
		if fade == 0 then

			SetValue("fade",1,"cosine",0.5)
			descriptionText = GetDescription(cars[currentCar])
		end
		if fade == 1 then
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

		UiFont("bold.ttf", 45)
		local h = 36
		UiPush()
			UiColor(200/256, 200/256, 200/256, fade)
			UiTranslate(0,-260 + h + 20)
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
		if introFade <= 0 then
			UiPush()
			UiFont("regular.ttf", 24)
				UiTranslate(0, 30)
				UiText("PRESS SPACE TO START THE STAGE")
			UiPop()	
		end
	UiPop()
end

function drawIntro()

end
