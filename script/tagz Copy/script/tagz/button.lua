buttons = {}
targetbodies = {}
targetshapes = {}
targetjoints = {}
targetlocations = {}
targetlights = {}
targettriggers = {}
targetscreens = {}
targetvehicles = {}

function init()
    SetBool("onsvrg.button.refresh",true)
	refresh()

    --activatesound = LoadSound("activatesound")
    --deactivatesound = LoadSound("deactivatesound")
    --togglesound = LoadSound("togglesound")
    --locksound = LoadSound("locksound")
    --unlocksound = LoadSound("unlocksound")
end

function tick(dt)
    if GetBool("onsvrg.button.refresh") then
        refresh()
    end
	for i = 1, #buttons do
        if GetPlayerInteractShape() == buttons[i] then
			if InputPressed("interact") then
                local buttontransform = GetShapeLocalTransform(buttons[i])
                local t = "activate"
                local targettag = ""
                --
                local level = GetTagValue(buttons[i], "level")
                if level ~= "" then
                    StartLevel(level, "MOD/"..level..".xml")
                end
                --
                
                if GetTagValue(buttons[i], "target") ~= "" then
                    targettag = GetTagValue(buttons[i],"target")                  
                end

                if GetTagValue(buttons[i], "button") ~= "" then
                    t = GetTagValue(buttons[i],"button")
                end
                if t == "activate" then
                    --PlaySound(activatesound)                    
                    --SetShapeEmissiveScale(buttons[i],0)
                    activate(targettag)
                    --buttontransform.pos[2] = buttontransform.pos[2] - 0.1
			        --SetShapeLocalTransform(buttons[i], buttontransform)
                end
                if t == "deactivate" then
                    --PlaySound(deactivatesound)                    
                    --SetShapeEmissiveScale(buttons[i],1)
                    deactivate(targettag)
                    --buttontransform.pos[2] = buttontransform.pos[2] + 0.1
			        --SetShapeLocalTransform(buttons[i], buttontransform)
                end
                if t == "toggle" then
                    --PlaySound(togglesound)                    
                    toggle(targettag)
                end
                if t == "lock" then
                    --PlaySound(locksound)
                    lock(targettag)
                end
                if t == "unlock" then
                    --PlaySound(unlocksound)
                    unlock(targettag)
                end
            end
        end
	end
end

function refresh()
    buttons = FindShapes("button",true)
    for i = 1, #buttons do
        local t = "activate"
        if GetTagValue(buttons[i], "button") ~= "" then
            t = GetTagValue(buttons[i],"button")
        end
        type = t

        local desc = GetDescription(buttons[i])

        if desc == "" then
            SetTag(buttons[i], "interact", type .. " button")
		else
			SetTag(buttons[i], "interact", desc)
        end
    end
    SetBool("onsvrg.button.refresh",false)
end

function activate(tag)
    --DebugPrint("button activate")
    setstatus(tag,"activate")
end

function deactivate(tag)
    --DebugPrint("button deactivate")
    setstatus(tag,"deactivate")
end

function toggle(tag)
    --DebugPrint("button toggle tag: "..tag)
    setstatus(tag,"toggle")
end

function lock(tag)
    --DebugPrint("button lock")
    setstatus(tag,"lock")
end

function unlock(tag)
    --DebugPrint("button unlock")
    setstatus(tag,"unlock")
end

function setstatus(tag,status)
    targetjoints = FindJoints(tag, true)
    for i = 1, #targetjoints do
        local interactions = ListKeys("onsvrg.interactions")
        for j=1, #interactions do
            SetTag(targetjoints[i], status)
        end
    end

    targetbodies = FindBodies(tag, true)
    for i = 1, #targetbodies do
        local interactions = ListKeys("onsvrg.interactions")
        for j=1, #interactions do            
            SetTag(targetbodies[i], status)
        end
    end

    targetshapes = FindShapes(tag, true)
    for i = 1, #targetshapes do
        local interactions = ListKeys("onsvrg.interactions")
        for j=1, #interactions do
            SetTag(targetshapes[i], status)
        end
    end

    targetlocations = FindLocations(tag, true)
    for i = 1, #targetlocations do
        local interactions = ListKeys("onsvrg.interactions")
        for j=1, #interactions do            
            SetTag(targetlocations[i], status)
        end
    end

    targetlights = FindLights(tag, true)
    for i = 1, #targetlights do
        local interactions = ListKeys("onsvrg.interactions")
        for j=1, #interactions do            
            SetTag(targetlights[i], status)
        end
    end

    targettriggers = FindTriggers(tag, true)
    for i = 1, #targettriggers do
        local interactions = ListKeys("onsvrg.interactions")
        for j=1, #interactions do
            SetTag(targettriggers[i], status)
        end
    end

    targetscreens = FindScreens(tag, true)
    for i = 1, #targetscreens do
        local interactions = ListKeys("onsvrg.interactions")
        for j=1, #interactions do
            SetTag(targetscreens[i], status)
        end
    end

    targetvehicles = FindVehicles(tag, true)
    for i = 1, #targetvehicles do
        local interactions = ListKeys("onsvrg.interactions")
        for j=1, #interactions do
            SetTag(targetvehicles[i], status)
        end
    end
end