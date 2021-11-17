data = {}
lights = {}

function init()
    SetBool("onsvrg.interactions.light",true)
    SetBool("onsvrg.light.refresh",true)
	refresh()
end

function tick(dt)
    if GetBool("onsvrg.light.refresh") then
        refresh()
    end
    for id,value in pairs(data) do
        checktags(id)
        checkstatus(id, dt)

        local light = id
        local shape = GetLightShape(light)
        if data[id].active then
            if shape ~= 0 then 
                SetShapeEmissiveScale(shape,1)
            end
            SetLightEnabled(light, true)
        else
            if shape ~= 0 then 
                SetShapeEmissiveScale(shape,0)
            end
            SetLightEnabled(light, false)
        end
    end
end

function refresh()
    ids = FindLights("light",true)
    for i = 1, #ids do
        local id = ids[i]
        local delay = 0
        if HasTag(id, "delay") then
            delay = tonumber(GetTagValue(id,"delay"))
        end

        data[id] = {}
        data[id].handle = id
        data[id].active = true
        data[id].speed = 1

        if HasTag(id, "off") then
            data[id].active = false
		end

        data[id].locked = false
        
        if HasTag(id, "locked") then
            data[id].locked = true
		end
        
        data[id].delay = delay
        data[id].delaymax = delay
        data[id].activate = false
        data[id].deactivate = false
        data[id].toggle = false
        data[id].lock = false
        data[id].unlock = false	
    end
    SetBool("onsvrg.light.refresh",false)
end

function checktags(id)
    if HasTag(data[id].handle, "activate") then
        data[id].activate = true
        RemoveTag(data[id].handle,"activate")
    end
    if HasTag(data[id].handle, "deactivate") then
        data[id].deactivate = true
        RemoveTag(data[id].handle,"deactivate")
    end
    if HasTag(data[id].handle, "toggle") then
        data[id].toggle = true
        RemoveTag(data[id].handle,"toggle")
    end
    if HasTag(data[id].handle, "lock") then
        data[id].lock = true
        RemoveTag(data[id].handle,"lock")
    end
    if HasTag(data[id].handle, "unlock") then
        data[id].unlock = true
        RemoveTag(data[id].handle,"unlock")
    end
end

function checkstatus(id, dt)
    --first check for unlock interaction
    if data[id].unlock then unlock(data[id]) end

    if not data[id].locked then  
        --if not locked check for other interactions
        if data[id].activate then 
            data[id].delay = data[id].delay - dt
            activate(id) 
        end
        if data[id].deactivate then 
            data[id].delay = data[id].delay - dt
            deactivate(id) 
        end
        if data[id].toggle then
            toggle(id) 
        end
        if data[id].lock then lock(id) end
    end	
end

function activate(id)
    --DebugPrint("activate id: "..id)
    if not data[id].locked then
        if data[id].delay <= 0 then
            data[id].active = true
        end
    end
    if data[id].active then
        data[id].delay = data[id].delaymax
        data[id].activate = false 
    end
end

function deactivate(id)
    --DebugPrint("deactivate id: "..id)
    if not data[id].locked then
        local delay = data[id].delay
        if delay <= 0 then
            data[id].active = false
        end
    end
    if not data[id].active then
        data[id].delay = data[id].delaymax
        data[id].deactivate = false
    end
end

function toggle(id)
    if not data[id].locked then
        data[id].active = not data[id].active
    end
    data[id].toggle = false
end

function lock(id)
    --DebugPrint("lock id: "..id)
    data[id].locked = true
    data[id].lock = false
end

function unlock(id)
    --DebugPrint("unlock id: "..id)
    data[id].locked = false
    data[id].unlock = false	
end
