function init()
    RegisterTool('fireaxe','Axe','MOD/vox/fireaxe.vox')
    SetBool("game.tool.fireaxe.enabled", true)
    SetFloat("game.tool.fireaxe.ammo", 101)

    smashTimer = 0
    spinsmash = false
end
function Smash()
    if smashTimer == 0 then smashTimer = 0.1 end
end

function Spin()
    local ct = GetCameraTransform()
    local pt = GetPlayerTransform()

    pt.pos[2] = pt.pos[2] + 1.8
    ct.pos = pt.pos
    ct.rot = QuatRotateQuat(ct.rot, QuatEuler(0, 10, 0))
    SetCameraTransform(ct)

    if smashTimer == 0 then smashTimer = 0.05 end
end

function tick(dt)
    if GetString("game.player.tool") == "fireaxe" and GetPlayerVehicle() == 0 then
        SetPlayerHealth(1)

        if InputPressed("lmb") then
            Smash()
        end

        if InputPressed("rmb") then
            spinsmash = true
            Smash()
        end

        local b = GetToolBody()
        if b ~= 0 then
            local offset = Transform(Vec(0.7, -1.20, 0.0), QuatEuler(5, -5, -20))
            SetToolTransform(offset)
            
            tipPos = TransformToParentPoint(GetBodyTransform(b), Vec(0.05, -0.05, -2.7))

            if smashTimer > 0 then
                if spinsmash then
                    local t = Transform()
                    t.pos = Vec(0.5, -0.6, -0.85+smashTimer*2)
                    t.rot = QuatEuler(0, 60, -90)
                    SetToolTransform(t)
                else
                    local t = Transform()
                    t.pos = Vec(0.5, -0.6, -0.85+smashTimer*2)
                    t.rot = QuatEuler(-smashTimer*400, smashTimer*150, 0)
                    SetToolTransform(t)
                end
            end

            if InputDown("lmb") and smashTimer == 0 then
                local t = Transform()
                t.pos = Vec(0.8, -1.0, -0.20)
                t.rot = QuatEuler(5, 5, -10)
                SetToolTransform(t)
            end
        end

        if smashTimer > 0 then
            smashTimer = smashTimer - dt
            if smashTimer < 0.0000001 then
                PlaySound(swingsound, GetPlayerTransform().pos, 0.6)
                local holeposes = {}
                local hitcount = 0
                for i=1, 16 do
                    local inc = 0.2*i

                    local meleedist = 3.6
                    if i < 6 or i > 10 then meleedist = meleedist * 0.95 end
                    if i < 5 or i > 11 then meleedist = meleedist * 0.95 end
                    if i < 4 or i > 12 then meleedist = meleedist * 0.95 end
                    if i < 3 or i > 13 then meleedist = meleedist * 0.95 end
                    if i < 2 or i > 14 then meleedist = meleedist * 0.95 end
                    local vec = spinsmash and Vec(-0.7+inc, 0, -meleedist) or Vec(0, -0.5+inc, -meleedist)

                    local ct = GetCameraTransform()
                    local fwdpos = TransformToParentPoint(GetCameraTransform(), vec)
                    local direction = VecSub(fwdpos, ct.pos)
                    local distance = VecLength(direction)
                    local direction = VecNormalize(direction)
                    local hit, hitDistance = QueryRaycast(ct.pos, direction, distance)
                    
                    if hit then
                        hitcount = hitcount + 1
                        local vec2 = spinsmash and Vec(-0.7+inc, 0, -hitDistance) or Vec(0, -0.5+inc, -hitDistance)

                        vec2 = VecScale(vec2, 1.03)
                        if i < 6 or i > 10 then vec2 = VecScale(vec2, 0.95) end
                        if i < 4 or i > 12 then vec2 = VecScale(vec2, 0.95) end
                        if i < 2 or i > 14 then vec2 = VecScale(vec2, 0.95) end
                        holeposes[hitcount] = TransformToParentPoint(GetCameraTransform(), vec2)
                    end
                end
                for i=1, #holeposes do
                    MakeHole(holeposes[i], 0.2, 0.2, 0.2)
                end
                smashTimer = 0
                spinsmash = false
            end
        end
    end
end
