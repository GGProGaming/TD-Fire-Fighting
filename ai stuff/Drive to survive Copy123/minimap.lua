---------------------------------------------------------------------------
-- Racing minimap
---------------------------------------------------------------------------

function minimap_init()
	-- Visibility of map
	visible = 0
	triggerMarkers = FindTriggers("uipos",true)
	bodyMarkers = FindBodies("uipos",true)
	pt = GetPlayerTransform()
end
	
	
function minimap_tick(dt)
	local v = GetPlayerVehicle()
	if v ~= 0 then
		--Show map if in vehicle
		if visible == 0 then
			--Animate visibible to 1 over 0.5 seconds
			SetValue("visible", 1, "easeout", 0.5)
		end
	else
		--Hide map if not in vehicle
		if visible == 1 then
			--Animate visibible to 0 over 0.5 seconds
			SetValue("visible", 0, "easein", 0.5)
		end
	end
end


function minimap_update()
	pt = GetPlayerTransform()
end


function minimap_draw()
	--Only draw map if visible
	local margin = 25
	if visible > 0 then
		UiPush()
			UiTranslate(500/2 - 500 + 500 * visible + margin,250/2 + margin)
			UiAlign("center middle")
			UiImage("MOD/images/map.png")
			UiPush()
				UiTranslate(pt.pos[1] * 1.25, pt.pos[3] * 1.25)
				local d = TransformToParentVec(GetPlayerTransform(),Vec(0,0,-1))
				d = VecNormalize(d)
				d = math.atan2(d[1],d[3])*180/math.pi
				UiRotate(d)
				UiImage("MOD/images/player.png")
			UiPop()
			-- Removed powerups and stuff from the minimap as it became too clutered, but code is here if needed.
			--[[for i = 1, #bodyMarkers do
				if not HasTag(bodyMarkers[i],"spent") then
					if GetTagValue(bodyMarkers[i], "uipos") == "green" then
						local tt = GetBodyTransform(bodyMarkers[i])
						UiPush()
							UiTranslate(tt.pos[1] * 1.25, tt.pos[3] * 1.25)
							UiImage("MOD/images/line_green.png")
						UiPop()
					end
					if GetTagValue(bodyMarkers[i], "uipos") == "red" then
						local tt = GetBodyTransform(bodyMarkers[i])
						UiPush()
							UiTranslate(tt.pos[1] * 1.25, tt.pos[3] * 1.25)
							UiImage("MOD/images/line_red.png")
						UiPop()
					end
					if GetTagValue(bodyMarkers[i], "uipos") == "star_gold" then
						local tt = GetBodyTransform(bodyMarkers[i])
						UiPush()
							UiTranslate(tt.pos[1] * 1.25, tt.pos[3] * 1.25)
							UiImage("MOD/images/star_gold.png")
						UiPop()
					end
					if GetTagValue(bodyMarkers[i], "uipos") == "time_5" then
						local tt = GetBodyTransform(bodyMarkers[i])
						UiPush()
							UiTranslate(tt.pos[1] * 1.25, tt.pos[3] * 1.25)
							UiImage("MOD/images/t5.png")
						UiPop()
					end
					if GetTagValue(bodyMarkers[i], "uipos") == "time_10" then
						local tt = GetBodyTransform(bodyMarkers[i])
						UiPush()
							UiTranslate(tt.pos[1] * 1.25, tt.pos[3] * 1.25)
							UiImage("MOD/images/t10.png")
						UiPop()
					end
					if GetTagValue(bodyMarkers[i], "uipos") == "time_25" then
						local tt = GetBodyTransform(bodyMarkers[i])
						UiPush()
							UiTranslate(tt.pos[1] * 1.25, tt.pos[3] * 1.25)
							UiImage("MOD/images/t25.png")
						UiPop()
					end
				end
			end--]]
			for i = 1, #triggerMarkers do
				if HasTag(triggerMarkers[i],"uipos") then
					if GetTagValue(triggerMarkers[i], "uipos") == "green" then
						local tt = GetTriggerTransform(triggerMarkers[i])
						UiPush()
							UiTranslate(tt.pos[1] * 1.25, tt.pos[3] * 1.25)

							local d = TransformToParentVec(GetTriggerTransform(triggerMarkers[i]),Vec(0,0,-1))
							d = VecNormalize(d)
							d = math.atan2(d[1],d[3])*180/math.pi
							UiRotate(d)
							UiImage("MOD/images/line_green.png")
						UiPop()
					end
					if GetTagValue(triggerMarkers[i], "uipos") == "red" then
						local tt = GetTriggerTransform(triggerMarkers[i])
						UiPush()
							UiTranslate(tt.pos[1] * 1.25, tt.pos[3] * 1.25)

							local d = TransformToParentVec(GetTriggerTransform(triggerMarkers[i]),Vec(0,0,-1))
							d = VecNormalize(d)
							d = math.atan2(d[1],d[3])*180/math.pi
							UiRotate(d)
							UiImage("MOD/images/line_red.png")
						UiPop()
					end
				end
			end
		UiPop()
	end
end

