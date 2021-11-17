explosiveshapes = {}
explosivebodies = {}
explosivelocations = {}
data = {}

function init()
    SetBool("onsvrg.interactions.explode",true)
    SetBool("onsvrg.explode.refresh",true)
	refresh()
end

function tick(dt)    
    if GetBool("onsvrg.explode.refresh") then
        refresh()
    end
    local explosionoccured = false

    explosionlogic(explosiveshapes, "shape", dt)
    explosionlogic(explosivebodies, "body", dt)
    explosionlogic(explosivelocations, "location", dt)

    -- after an explosion refresh explosives
    if explosionoccured then
        ClearKey("onsvrg.explode")
        SetBool("onsvrg.explode.refresh",true)
    end
end

function explosionlogic(list, type, dt)
    for key,id in pairs(list) do
        checktags(id)        
        checkstatus(id, dt)
        
        if data[id].unlock then unlock(id) end
        
        --explosion logic
        if data[id].active then
            explosionoccured = true
            
            local s = 1
            if GetTagValue(data[id].handle, "explode") ~= "" then
                s = GetTagValue(data[id].handle,"explode")
            end
            local worldTransform = {0,0,0}

            if type == "shape" then 
                worldTransform = GetShapeWorldTransform(data[id].handle)
                RemoveTag(data[id].handle, "explode")
            end
            if type == "body" then 
                worldTransform = GetBodyTransform(data[id].handle)
                RemoveTag(data[id].handle, "explode")
            end
            if type == "location" then 
                worldTransform = GetLocationTransform(data[id].handle)
            end

            Explosion(worldTransform.pos, s)
            data[id].active = false
            data[id].locked = true
        end
    end
end

function refreshlist(list,type)
    for key,id in pairs(list) do
        --local id = list[id]
        local delay = 0
        if HasTag(id, "delay") then
            delay = tonumber(GetTagValue(id,"delay"))
        end

        data[id] = {}
        data[id].handle = id
        data[id].active = false

        if HasTag(id, "active") then
            data[id].active = true
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
end

function refresh()
    explosiveshapes = FindShapes("explode",true)
    explosivebodies = FindBodies("explode",true)
    explosivelocations = FindLocations("explode",true)

    refreshlist(explosiveshapes)
    refreshlist(explosivebodies)
    refreshlist(explosivelocations)
    
    SetBool("onsvrg.explode.refresh",false)
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
        if data[id].delay <= 0 then
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