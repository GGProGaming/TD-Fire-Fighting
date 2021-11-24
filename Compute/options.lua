function init()
	lmbWaterAmount = GetFloat("savegame.mod.lmbWaterAmount")
	if lmbWaterAmount < 0.10 or lmbWaterAmount > 1 then
		lmbWaterAmount = 0.25
		SetFloat("savegame.mod.lmbWaterAmount", 0.25)
	end
    rmbWaterAmount = GetFloat("savegame.mod.rmbWaterAmount")
	if rmbWaterAmount < 0.10 or rmbWaterAmount > 2 then
		rmbWaterAmount = 0.40
		SetFloat("savegame.mod.rmbWaterAmount", 0.40)
	end
    life = GetInt("savegame.mod.life")
	if life < 10 or life > 50 then
		life = 20
		SetInt("savegame.mod.life", 20)
	end
    gravity = GetInt("savegame.mod.gravity")
	if gravity < -25 or gravity > 5 then
		gravity = -13
		SetInt("savegame.mod.gravity", -13)
	end
    smokeparticles = GetInt("savegame.mod.smokeparticles")
    -- SetBool("savegame.mod.smokeparticles", false)
    if smokeparticles ~=(1 or 0) then
        smokeparticles = 0
        SetInt("savegame.mod.smokeparticles", 0)
    end
	inside = {}
	for i = 1,50 do
		inside[i] = {0,0,0,0}
	end
end

function optionsSlider(current, min, max, incri)
    UiPush()
        UiTranslate(0, -8)
        local steps = incri or 1
        local value = (current - min) / (max - min)
        local width = 100
	    UiTranslate(width, 0)
        UiRect(width, 3)
	    UiTranslate(-width, 0)
        UiAlign("center middle")
        local value = UiSlider("ui/common/dot.png", "x", value*width, 0, width)/width
        local value = math.floor((value*(max-min)+min)/steps+0.5)*steps
    UiPop()
    return value
end

local heightspacingY = 125
local resetbuttonspacingX = 425

function draw()
	UiTranslate(UiCenter(), 200)
	UiAlign("center middle")

    ----Title---------------------------------------------------------------
    UiTextOutline(0, 0, 0, 2)
	UiFont("bold.ttf", 46)
	UiColor(0,0.1,1)
	UiText("Water settings")
	UiFont("bold.ttf", 44)
	UiColor(0,0.5,1)
	UiText("Water settings")
	UiFont("bold.ttf", 42)
	UiColor(0,1,1)
	UiText("Water settings")
	UiFont("bold.ttf", 40)
	UiColor(1,1,1)
	UiText("Water settings")
	UiFont("regular.ttf", 26)
    UiTextOutline(0, 0, 0, 0)
    ------------------------------------------------------------------------
	UiTranslate(0, 100)
    ----lmbWaterAmount settings---------------------------------------------
    UiPush()
        UiAlign("center middle")
        UiTranslate(0, 20)
        UiColor(0,0.1,1)
        UiImageBox("MOD/images/ImageBox400-100.png", 349, 109)
        UiColor(0,0.5,1)
        UiImageBox("MOD/images/ImageBox400-100.png", 346, 106)
        UiColor(0,1,1)
        UiImageBox("MOD/images/ImageBox400-100.png", 343, 103)
        UiColor(1,1,1)
        UiImageBox("MOD/images/ImageBox400-100.png", 340, 100)
    UiPop()
	UiPush()
		UiText("Radius of water beam: "..lmbWaterAmount.."cm")
        UiTranslate(60, 40)
        UiAlign("center middle")
        UiText("Default is 0.25 cm")
		UiTranslate(-200, 10)
		UiAlign("right")
		UiColor(0.5, 0.8, 1)
		lmbWaterAmount = optionsSlider(lmbWaterAmount, 0.10, 1.00, 0.05)
		SetFloat("savegame.mod.lmbWaterAmount", lmbWaterAmount)
        UiButtonImageBox("ui/common/box-outline-6.png", 6, 6)
        UiTranslate(resetbuttonspacingX, -25)
        UiColor(1,0,0)
	    if UiTextButton("Reset", 80, 40) then
            UiSound("MOD/snd/click.ogg")
            lmbWaterAmount = 0.25
            SetFloat("savegame.mod.lmbWaterAmount", 0.25)
	    end
        UiColor(1,1,1)
	UiPop()
    ------------------------------------------------------------------------
    UiTranslate(0, heightspacingY)
    ----rmbWaterAmount settings---------------------------------------------
    UiPush()
        UiAlign("center middle")
        UiTranslate(0, 20)
        UiColor(0,0.1,1)
        UiImageBox("MOD/images/ImageBox400-100.png", 349, 109)
        UiColor(0,0.5,1)
        UiImageBox("MOD/images/ImageBox400-100.png", 346, 106)
        UiColor(0,1,1)
        UiImageBox("MOD/images/ImageBox400-100.png", 343, 103)
        UiColor(1,1,1)
        UiImageBox("MOD/images/ImageBox400-100.png", 340, 100)
    UiPop()
    UiPush()
		UiText("Radius of water beam: "..rmbWaterAmount.."cm")
        UiTranslate(60, 40)
        UiAlign("center middle")
        UiText("Default is 0.4 cm")
		UiTranslate(-200, 10)
		UiAlign("right")
		UiColor(0.5, 0.8, 1)
		rmbWaterAmount = optionsSlider(rmbWaterAmount, 0.10, 2.00, 0.05)
        SetFloat("savegame.mod.rmbWaterAmount", rmbWaterAmount)
        UiButtonImageBox("ui/common/box-outline-6.png", 6, 6)
        UiTranslate(resetbuttonspacingX, -25)
        UiColor(1,0,0)
	    if UiTextButton("Reset", 80, 40) then
            UiSound("MOD/snd/click.ogg")
            rmbWaterAmount = 0.40
            SetFloat("savegame.mod.rmbWaterAmount", 0.40)
	    end
        UiColor(1,1,1)
	UiPop()
    ------------------------------------------------------------------------
    UiTranslate(0, heightspacingY)
    ----Life duration settings----------------------------------------------
    UiPush()
        UiAlign("center middle")
        UiTranslate(0, 20)
        UiColor(0,0.1,1)
        UiImageBox("MOD/images/ImageBox400-100.png", 349, 109)
        UiColor(0,0.5,1)
        UiImageBox("MOD/images/ImageBox400-100.png", 346, 106)
        UiColor(0,1,1)
        UiImageBox("MOD/images/ImageBox400-100.png", 343, 103)
        UiColor(1,1,1)
        UiImageBox("MOD/images/ImageBox400-100.png", 340, 100)
    UiPop()
    UiPush()
		UiText("Duration of stay from water: "..life.."sec")
        UiTranslate(60, 40)
        UiAlign("center middle")
        UiText("Default is 20 sec")
		UiTranslate(-200, 10)
		UiAlign("right")
		UiColor(0.5, 0.8, 1)
		life = optionsSlider(life, 10, 50, 5)
		SetInt("savegame.mod.life", life)
        UiButtonImageBox("ui/common/box-outline-6.png", 6, 6)
        UiTranslate(resetbuttonspacingX, -25)
        UiColor(1,0,0)
	    if UiTextButton("Reset", 80, 40) then
            UiSound("MOD/snd/click.ogg")
            life = 20
            SetInt("savegame.mod.life", 20)
	    end
        UiColor(1,1,1)
	UiPop()
    ------------------------------------------------------------------------
    UiTranslate(0, heightspacingY)
    ----gravity strength settings----------------------------------------------
    UiPush()
        UiAlign("center middle")
        UiTranslate(0, 20)
        UiColor(0,0.1,1)
        UiImageBox("MOD/images/ImageBox400-100.png", 349, 109)
        UiColor(0,0.5,1)
        UiImageBox("MOD/images/ImageBox400-100.png", 346, 106)
        UiColor(0,1,1)
        UiImageBox("MOD/images/ImageBox400-100.png", 343, 103)
        UiColor(1,1,1)
        UiImageBox("MOD/images/ImageBox400-100.png", 340, 100)
    UiPop()
    UiPush()
		UiText("Amount gravity strengt: "..gravity.."")
        UiTranslate(60, 40)
        UiAlign("center middle")
        UiText("Default is -13")
		UiTranslate(-200, 10)
		UiAlign("right")
		UiColor(0.5, 0.8, 1)
		gravity = optionsSlider(gravity, -25, 5, 1)
		SetInt("savegame.mod.gravity", gravity)
        UiButtonImageBox("ui/common/box-outline-6.png", 6, 6)
        UiTranslate(resetbuttonspacingX, -25)
        UiColor(1,0,0)
	    if UiTextButton("Reset", 80, 40) then
            UiSound("MOD/snd/click.ogg")
            gravity = -13
            SetInt("savegame.mod.gravity", -13)
	    end
        UiColor(1,1,1)
	UiPop()
    ------------------------------------------------------------------------
    UiTranslate(0, heightspacingY)
    ----smokeparticles settings------------------------------------------------------
    UiPush()
        UiAlign("center middle")
        UiTranslate(0, 20)
        UiColor(0,0.1,1)
        UiImageBox("MOD/images/ImageBox400-100.png", 349, 109)
        UiColor(0,0.5,1)
        UiImageBox("MOD/images/ImageBox400-100.png", 346, 106)
        UiColor(0,1,1)
        UiImageBox("MOD/images/ImageBox400-100.png", 343, 103)
        UiColor(1,1,1)
        UiImageBox("MOD/images/ImageBox400-100.png", 340, 100)
    UiPop()
    UiPush()
        UiText("do you want smokeparticles?")
        UiTranslate(60, 40)
        UiAlign("center middle")
        UiText("Default is no")
        UiTranslate(-130, 0)
        UiColor(0.5, 0.8, 1)
        if smokeparticles == 1 then
            if UiTextButton("Yes", 20, 20) then
                smokeparticles = 0
                SetInt("savegame.mod.smokeparticles", smokeparticles)
            end
        else
            if UiTextButton("No", 20, 20) then
                smokeparticles = 1
                SetInt("savegame.mod.smokeparticles", smokeparticles)
            end
        end
        UiButtonImageBox("ui/common/box-outline-6.png", 6, 6)
        UiTranslate(resetbuttonspacingX - 110, -25)
        UiColor(1,0,0)
	    if UiTextButton("Reset", 80, 40) then
            UiSound("MOD/snd/click.ogg")
            smokeparticles = false
            SetBool("savegame.mod.smokeparticles", smokeparticles)
	    end
        UiColor(1,1,1)
    UiPop()
    ------------------------------------------------------------------------
    UiAlign('bottom middle')
    UiTranslate(-25, 100)
	----Close Button--------------------------------------------------------
    UiButtonImageBox("ui/common/box-outline-6.png", 6, 6)
	UiTranslate(0, 100)
    UiColor(1,0,0)
	if UiTextButton("Close", 80, 40) then
        UiSound("MOD/snd/cancel.ogg")
		Menu()
	end
    UiColor(1,1,1)
end