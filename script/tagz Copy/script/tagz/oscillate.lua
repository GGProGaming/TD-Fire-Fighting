data = {}

function init()    
    SetBool("onsvrg.interactions.oscillate",true)
    SetBool("onsvrg.oscillate.refresh",true)
	refresh()
end

function tick(dt)
    if GetBool("onsvrg.oscillate.refresh") then
        refresh()
    end
    
	for id,value in pairs(data) do
        eps = .2
        checktags(id)
        checkstatus(id, dt)

        

        local min, max = GetJointLimits(id)
        local current = GetJointMovement(id)

        if data[id].active then
            data[id].time = data[id].time + dt

			min = min + .001
			max = max - .001

            local timeItShouldTake = (max-min)/data[id].speed
            local length = (max-min)
            --s = v*t
            --t = s/v
            --DebugPrint((math.sin(data[id].time / (max-min)*.1)))
			--data[id].target = min + (max-min) * (math.sin(data[id].time) * (max-min) / data[id].speed)
            
            --DebugWatch(id,id.." id, timeItShouldTake: "..timeItShouldTake.." length: "..length.." speed: "..data[id].speed.."    target: "..min.." { "..data[id].target.." } "..max)

			--local target = (math.sin(math.pi * 2 * (GetTime()+offset)/period) * 0.5 + 0.5) * (ma-mi) + mi

            data[id].target = ((math.sin(data[id].time / timeItShouldTake)*0.5)+0.5) * (max-min) + min
            SetJointMotorTarget(data[id].handle , data[id].target , data[id].speed, 1000)
        else
            SetJointMotorTarget(data[id].handle , current , data[id].speed, 1000)
        end
    end
end

function refresh()
    ids = FindJoints("oscillate",true)
    for i = 1, #ids do
        local id = ids[i]
        local delay = 0
        if HasTag(id, "delay") then
            delay = tonumber(GetTagValue(id,"delay"))
        end

        data[id] = {}
        data[id].handle = id
        data[id].active = true
        
        if GetTagValue(data[id].handle,"oscillate") ~= "" then
            data[id].speed = tonumber(GetTagValue(data[id].handle,"rotate"))
        end

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
        data[id].time = 0	

        local min, max = GetJointLimits(id)
        data[id].speed = 1
        if GetTagValue(id, "oscillate") ~= "" then
            data[id].speed = tonumber(math.abs(GetTagValue(id,"oscillate")))

            if GetJointType(id) == "hinge" then
                data[id].speed = data[id].speed * math.pi * 2
            end
        end
        data[id].dir = 0

        data[id].target = max
        if data[id].speed < 0 then
            data[id].dir = 1
            data[id].target = min
        end
    end
    SetBool("onsvrg.oscillate.refresh",false)
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




