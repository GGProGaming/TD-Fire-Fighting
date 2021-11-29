local boilerplate = "savegame.mod"
local default_layer = "8675309"

-- binds a checkbox to a savegame.mod registry
function checkBox(of)
	UiPush()
	UiFont("regular.ttf", 24)
	UiAlign("center middle")
	if GetBool(boilerplate.."."..of) then
		UiColor(0.3, 1, 0.3, 0.2)
		UiImageBox("ui/common/box-solid-6.png", 200, 40, 6, 6)
		UiColor(1, 1, 1, 1)
		if UiTextButton(of.." enabled", 200, 40) then
			SetBool(boilerplate.."."..of, false)
		end
	else
		UiColor(0.7, 0.7, 0.7, 1)
		if UiTextButton(of.." disabled", 200, 40) then
			SetBool(boilerplate.."."..of, true)
		end
	end
	UiPop()
end

-- binds a button to a singleton string value
-- and automatically reflects state based on that
function radioBox(key, value)
	UiPush()
	UiFont("regular.ttf", 24)
	UiAlign("center middle")
	UiColor(1, 1, 1, 1)
	if GetString(boilerplate.."."..key) == value then
		UiImageBox("ui/common/box-outline-6.png", 200, 40, 6, 6)
	end
	if UiTextButton(value, 200, 40) then
		if value == "reset" then
			ClearKey(boilerplate.."."..key)
		else
			SetString(boilerplate.."."..key, value)
		end
	end
	UiPop()

end

function header(of)

	UiPush()
	UiFont("bold.ttf", 30)
	UiText(of)
	UiPop()
	UiTranslate(400, 400)
end

-- CONSUMER MUST CALL THIS IN INIT METHOD
function init_env()
    -- reset the base layers
	SetString(boilerplate .. ".baselayers", "")
	-- do the initial env check
	if not HasKey(weatherKey) then
		SetString(weatherKey, default_layer)
	end
end

-- Use this to add layers that should be enabled by default. call in INIT method.
function add_base_layer(layer)
	SetString(boilerplate .. ".baselayers", GetString(boilerplate .. ".baselayers") .. " " .. layer)
end

