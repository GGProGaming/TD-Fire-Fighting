triggers = {}
targetbodies = {}
targetshapes = {}
targetjoints = {}
targetlocations = {}
targetlights = {}
targettriggers = {}
targetscreens = {}
targetvehicles = {}

function init()
    SetBool("onsvrg.trigger.refresh",true)
	refresh()

    --activatesound = LoadSound("activatesound")
    --deactivatesound = LoadSound("deactivatesound")
    --togglesound = LoadSound("togglesound")
    --locksound = LoadSound("locksound")
    --unlocksound = LoadSound("unlocksound")
end

function tick(dt)
    if GetBool("onsvrg.trigger.refresh") then
        refresh()
    end
    local pos = GetPlayerTransform().pos
    
	for i = 1, #triggers do
        if IsPointInTrigger(triggers[i], pos) then
            local t = "activate"
            local targettag = ""

            local level = GetTagValue(triggers[i], "level")
            if level ~= "" then
                StartLevel(level, "MOD/"..level..".xml")
            end


            if GetTagValue(triggers[i], "target") ~= "" then
                targettag = GetTagValue(triggers[i],"target")                  
            end

            if GetTagValue(triggers[i], "trigger") ~= "" then
                t = GetTagValue(triggers[i],"trigger")
            end
            if t == "activate" then
                --PlaySound(activatesound)
                activate(targettag)
            end
            if t == "deactivate" then
                --PlaySound(deactivatesound)
                deactivate(targettag)
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

function refresh()
    triggers = FindTriggers("trigger",true)
    SetBool("onsvrg.trigger.refresh",false)
end

function activate(tag)
    --DebugPrint("trigger activate")
    setstatus(tag,"activate")
end

function deactivate(tag)
    --DebugPrint("trigger deactivate")
    setstatus(tag,"deactivate")
end

function toggle(tag)
    --DebugPrint("trigger toggle tag: "..tag)
    setstatus(tag,"toggle")
end

function lock(tag)
    --DebugPrint("trigger lock")
    setstatus(tag,"lock")
end

function unlock(tag)
    --DebugPrint("trigger unlock")
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