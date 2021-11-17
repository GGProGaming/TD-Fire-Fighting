joints = {}
target = {}
dir = {}

function init()
    eps = 1
    SetBool("onsvrg.interactions.oscillate",true)
    SetBool("onsvrg.oscillate.refresh",true)
	refresh()
end

function update(dt)
    if GetBool("onsvrg.oscillate.refresh") then
        refresh()
    end
    for i = 1, #joints do
        --first check for unlock interaction
        if GetBool("onsvrg.oscillate."..joints[i]..".unlock") then unlock(joints[i]) end

        if not GetBool("onsvrg.oscillate."..joints[i]..".locked") then  
            --if not locked check for other interactions
            if GetBool("onsvrg.oscillate."..joints[i]..".activate") then 
                SetFloat("onsvrg.oscillate."..id..".delay", GetFloat("onsvrg.oscillate."..id..".delay") - dt)
                activate(joints[i]) 
            end
            if GetBool("onsvrg.oscillate."..joints[i]..".deactivate") then 
                SetFloat("onsvrg.oscillate."..id..".delay", GetFloat("onsvrg.oscillate."..id..".delay") - dt)
                deactivate(joints[i]) 
            end
            if GetBool("onsvrg.oscillate."..joints[i]..".toggle") then 
                SetFloat("onsvrg.oscillate."..id..".delay", GetFloat("onsvrg.oscillate."..id..".delay") - dt)
                toggle(joints[i]) 
            end
            if GetBool("onsvrg.oscillate."..joints[i]..".lock") then lock(joints[i]) end
        end	

        if GetBool("onsvrg.oscillate."..joints[i]..".active") then 
            local joint = joints[i]
            local min, max = GetJointLimits(joint)
            local current = GetJointMovement(joint)
        
            if current < min + eps and dir[i] == 1 then
                dir[i] = 0
                target[i] = max
            elseif current > max - eps and dir[i] == 0 then
                dir[i] = 1
                target[i] = min		
            end	

            speed = 1
            if GetTagValue(joint, "oscillate") ~= "" then
                speed = math.abs(GetTagValue(joint,"oscillate"))
            end
        
            SetJointMotorTarget(joint, target[i], speed)
        end
    end
end

function refresh()
    joints = FindJoints("oscillate", true)
    
    for i = 1, #joints do
        --init active, default true
        SetBool("onsvrg.oscillate."..joints[i]..".active",true)
        if HasTag(joints[i], "active") then
            SetBool("onsvrg.oscillate."..joints[i]..".active",GetTagValue(joints[i],"active"))
		end

        --init locked, default locked
        SetBool("onsvrg.oscillate."..joints[i]..".locked",false)
        if HasTag(joints[i], "locked") then
            SetBool("onsvrg.oscillate."..joints[i]..".locked",GetTagValue(joints[i],"locked"))
		end

        local delay = 0
        if HasTag(explosiveshapes[i], "delay") then
            delay = GetTagValue(explosiveshapes[i],"delay")
        end
        SetFloat("onsvrg.oscillate."..explosiveshapes[i]..".delay",delay)
        SetFloat("onsvrg.oscillate."..explosiveshapes[i]..".delaymax",delay)

        SetBool("onsvrg.oscillate."..joints[i]..".activate",false)	
        SetBool("onsvrg.oscillate."..joints[i]..".deactivate",false)	
        SetBool("onsvrg.oscillate."..joints[i]..".toggle",false)	
        SetBool("onsvrg.oscillate."..joints[i]..".lock",false)	
        SetBool("onsvrg.oscillate."..joints[i]..".unlock",false)	

        dir[i] = 0
        target[i] = max
        if tonumber(s) < 0 then
            dir[i] = 1
            target[i] = min
        end
    end
    SetBool("onsvrg.oscillate.refresh",false)	
end

function activate(id)
    --DebugPrint("activate id: "..id)
    if not GetBool("onsvrg.oscillate."..id..".locked") then
        local delay = GetFloat("onsvrg.oscillate."..id..".delay",0)
        if delay <= 0 then
            SetBool("onsvrg.oscillate."..id..".active",true)
        end
    end
    if GetBool("onsvrg.oscillate."..id..".active") then
        SetFloat("onsvrg.oscillate."..id..".delay", GetFloat("onsvrg.oscillate."..id..".delaymax"))
        SetBool("onsvrg.oscillate."..id..".activate",false)   
    end
end

function deactivate(id)
    --DebugPrint("deactivate id: "..id)
    if not GetBool("onsvrg.oscillate."..id..".locked") then
        local delay = GetFloat("onsvrg.oscillate."..id..".delay",0)
        if delay <= 0 then
            SetBool("onsvrg.oscillate."..id..".active",false)
        end
    end
    if not GetBool("onsvrg.oscillate."..id..".active") then
        SetFloat("onsvrg.oscillate."..id..".delay", GetFloat("onsvrg.oscillate."..id..".delaymax"))
        SetBool("onsvrg.oscillate."..id..".deactivate",false)   
    end
end

function toggle(id)
    --DebugPrint("toggle id: "..id)
    if not GetBool("onsvrg.oscillate."..id..".locked") then
        local delay = GetFloat("onsvrg.oscillate."..id..".delay",0)
        if delay <= 0 then
        SetBool("onsvrg.oscillate."..id..".active",not GetBool("onsvrg.oscillate."..id..".active"))
        end
    end
    if GetBool("onsvrg.oscillate."..id..".active") then
        SetFloat("onsvrg.oscillate."..id..".delay", GetFloat("onsvrg.oscillate."..id..".delaymax"))
        SetBool("onsvrg.oscillate."..id..".deactivate",false)   
    end
end

function lock(id)
    --DebugPrint("lock id: "..id)
    SetBool("onsvrg.oscillate."..id..".locked",true)	
    SetBool("onsvrg.oscillate."..id..".lock",false)	
end

function unlock(id)
    --DebugPrint("unlock id: "..id)
    SetBool("onsvrg.oscillate."..id..".locked",false)	
    SetBool("onsvrg.oscillate."..id..".unlock",false)	
end
