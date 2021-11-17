

detectRange = 5--2.5--3


VEHICLE_ACTIVE = true

vehicle = 

			{

			}

maxSpeed = 2

goalOrigPos = Vec(0,0,0) 
goalPos = 	goalOrigPos
SPOTMARKED = false

gCost = 1

testHeight = 5
drivePower = 3


detectPoints = {
	[1] = Vec(0,0,-detectRange),
	[2] = Vec(detectRange,0,-detectRange),
	[3] = Vec(-detectRange,0,-detectRange),
	[4] = Vec(-detectRange,0,0),
	[5] = Vec(detectRange,0,0),
	[6] = Vec(0,0,detectRange),

}

weights = {

	[1] = 0.85,
	[2] = 0.85,
	[3] = 0.85,
	[4] = 0.5,
	[5] = 0.5,
	[6] = 0.25,

}


ai = {

	commands = {
	[1] = Vec(0,0,-detectRange*4),
	[2] = Vec(detectRange*1.5,0,-detectRange*2.5),
	[3] = Vec(-detectRange*1.5,0,-detectRange*2.5),
	[4] = Vec(-detectRange,0,0),
	[5] = Vec(detectRange,0,0),
	[6] = Vec(0,0,detectRange),

	},

	weights = {

	[1] = 0.860,
	[2] = 0.85,
	[3] = 0.85,
	[4] = 0.8,
	[5] = 0.8,
	[6] = 0.7,

			} ,

	directions = {
		forward = Vec(0,0,1),

		back = Vec(0,0,-1),

		left = Vec(1,0,0),

		right = Vec(-1,0,0),
	},

	numScans = 7,
	scanThreshold = 0.5,

	--altChecks = Vec(0.25,0.4,-0.6),
	altChecks = {
				[1] = -2,
				[2] =0.2,
				[3] = 0.4
			},
	altWeight ={
			[1] = 1,
			[2] =1,
			[3] = -1,
			[4] = -1,
	},


	validSurfaceColours ={ 
			[1] = {
				r = 0.20,
				g = 0.20,
				b = 0.20,
				range = 0.05
			},
			[2] = {
				r = 0.34,
				g = 0.34,
				b = 0.34,
				range = 0.05
			},
			[3] = {
				r = 0.6,
				g = 0.6,
				b = 0.6,
				range = 0.05
			},
		}
}
targetMoves = {
	list        = {},
	target      = Vec(0,0,0),
	targetIndex = 1
}


scan = 0
scanCount = 5


hitColour = Vec(1,0,0)
detectColour = Vec(1,1,0)
clearColour = Vec(0,1,0)


RACESTARTED = false
locCheckpoint = 1
currentcheckpoint = nil
checkpoints = true
checkpoint = true


RESETMAX = 10
resetTimer = RESETMAX 

function init()

	for i=1,10 do 
		targetMoves.list[i] = Vec(0,0,0)

	end

	for i = 1,#ai.commands*1 do 
		detectPoints[i] = deepcopy(ai.commands[(i%#ai.commands)+1])
		if(i> #ai.commands) then
			detectPoints[i] = VecScale(detectPoints[i],0.5)
			detectPoints[i][2] = ai.altChecks[2]


		else 
			detectPoints[i][2] = ai.altChecks[1]
		end
		weights[i] = ai.weights[(i%#ai.commands)+1]--*ai.altWeight[math.floor(i/#ai.commands)+1]

	end

	vehicle.id = FindVehicle("cfg")
	local value = GetTagValue(vehicle.id, "cfg")
	if(value == "ai") then

		-- local status,retVal = pcall(initVehicle)
		-- if status then 
		-- 	DebugPrint("no errors")
		-- else
		-- 	DebugPrint(retVal)
		-- end

	end
				

	checkpoints = FindTriggers("checkpoint",true)

	for key,value in ipairs(checkpoints) do
		if(tonumber(GetTagValue(value, "checkpoint"))==locCheckpoint) then 
			currentcheckpoint = value
		end
	end
end


function tick(dt)

		hit, point, normal, shape = QueryClosestPoint(GetCameraTransform().pos, 10)
	if hit then
	--local hitPoint = VecAdd(pos, VecScale(dir, dist))
		local mat,r,g,b = GetShapeMaterialAtPosition(shape, point)
		DebugWatch("Raycast hit voxel made out of ", mat.." | r:"..r.."g:"..g.."b:"..b)
	end


	markLoc()

end

function markLoc()
	
	if InputPressed("g") and not RACESTARTED then

		RACESTARTED = true
		DebugPrint("race Started")
		goalOrigPos = GetTriggerTransform(currentcheckpoint).pos

		goalPos = VecAdd(goalOrigPos,Vec(math.random(-5,5),0,math.random(-5,5)))

		-- local camera = GetCameraTransform()
		-- local aimpos = TransformToParentPoint(camera, Vec(0, 0, -300))
		-- local hit, dist,normal = QueryRaycast(camera.pos,  VecNormalize(VecSub(aimpos, camera.pos)), 200,0)
		-- if hit then
			
		-- 	goalPos = TransformToParentPoint(camera, Vec(0, 0, -dist))

		-- end 	

		-- DebugPrint("hitspot"..VecStr(goalPos).." | "..dist.." | "..VecLength(
		-- 							VecSub(GetVehicleTransform(vehicle.id).pos,goalPos)))
	end

	-- if(VecLength(goalPos)~= 0) then 
	-- 	DebugWatch("goalpos",VecLength(goalPos))
	-- 	SpawnParticle("fire", goalPos, Vec(0,5,0), 0.5, 1)
	-- end
	if(RACESTARTED) then 
		if(IsVehicleInTrigger(currentcheckpoint,vehicle.id)) then
			locCheckpoint = (locCheckpoint%#checkpoints)+1
			for key,value in ipairs(checkpoints) do 
				
				if(tonumber(GetTagValue(value, "checkpoint"))==locCheckpoint) then 
					currentcheckpoint = value
					goalOrigPos = GetTriggerTransform(currentcheckpoint).pos

					goalPos = VecAdd(goalOrigPos,Vec(math.random(-10,10),0,math.random(-10,10)))
				end
			end

		end
		-- DebugWatch("checkpoint: ",raceCheckpoint)
		-- DebugWatch("goalpos",VecLength(goalPos))
		SpawnParticle("fire", goalPos, Vec(0,5,0), 0.5, 1)
	end

	if(VEHICLE_ACTIVE and (GetVehicleHealth(vehicle.id)<0.1 or  IsPointInWater(GetVehicleTransform(vehicle.id).pos))) then
		VEHICLE_ACTIVE = false

	end


end

function update(dt)

	if(VEHICLE_ACTIVE) then 
		targetCost = vehicleDetection5()
		-- DebugWatch("targetCost:",VecStr(targetCost.target ))

		targetCost.target = MAV(targetCost.target)

		-- DebugWatch("targetCost 2 :",VecStr(targetCost.target ))
		controlVehicle(targetCost)
	end

	-- 	if(VEHICLE_ACTIVE) then 
	-- 	targetCost = vehicleDetection3()
	-- 	-- DebugWatch("targetCost:",VecStr(targetCost.target ))

	-- 	targetCost.target = MAV(targetCost.target)

	-- 	DebugWatch("targetCost 2 :",VecStr(targetCost.target ))
	-- 	controlVehicle(targetCost)
	-- end

	 if(RACESTARTED and VEHICLE_ACTIVE and VecLength(GetBodyVelocity(GetVehicleBody(vehicle.id)))<1) then
	 	resetTimer = resetTimer -dt
	 	if(resetTimer <=0 )then
	 		local lastCheckpoint = locCheckpoint-1
			if(lastCheckpoint<=0) then
				lastCheckpoint = 1
			end
				
			for key,value in ipairs(checkpoints) do 
				
				if(tonumber(GetTagValue(value, "checkpoint"))== lastCheckpoint) then 
					local resetTrigger = GetTriggerTransform(value)
					resetTrigger.pos = VecAdd(resetTrigger.pos,Vec(math.random(-15,15),0,math.random(-15,15)))   
					SetBodyTransform(GetVehicleBody(vehicle.id),resetTrigger)
					resetTimer = RESETMAX
				end
			end
	 		

	 	end
	 elseif RACESTARTED and VEHICLE_ACTIVE and   resetTimer<RESETMAX then
	 	resetTimer = RESETMAX
	 end

	-- DebugWatch("Vehicle ",vehicle.id)
	

	-- DebugWatch("velocity:", VecLength(GetBodyVelocity(GetVehicleBody(vehicle.id))))
end






function vehicleDetection6( )
	local vehicleBody = GetVehicleBody(vehicle.id)
	local vehicleTransform = GetVehicleTransform(vehicle.id)
	local min,max = GetBodyBounds(vehicleBody)
	vehicleTransform.pos = TransformToParentPoint(vehicleTransform,Vec(0,testHeight,0))
	local vehicleTransformOrig = TransformCopy(vehicleTransform) 
	local fwd = 	TransformToParentPoint(vehicleTransform,Vec(0,0,-detectRange*1.5))
	local fwdL = 	TransformToParentPoint(vehicleTransform,Vec(detectRange,0,-detectRange))
	local fwdR = 	TransformToParentPoint(vehicleTransform,Vec(-detectRange,0,-detectRange))
	local boundsSize = VecSub(max, min)
	-- DebugWatch("min",VecStr(min))

	-- DebugWatch("max",VecStr(max))
	-- DebugWatch("boundsize",boundsSize)
	costs = { }
	bestCost = {key = 0, val = 1000, target = Vec(0,0,0)}

	if(VecLength(goalPos)> 0.5 and VecLength(
									VecSub(GetVehicleTransform(vehicle.id).pos,goalPos))>1) then	
		for key,detect in ipairs(detectPoints) do 

			vehicleTransform = GetVehicleTransform(vehicle.id)
			vehicleTransform.pos = TransformToParentPoint(vehicleTransform,Vec(0,testHeight*.25,0))
			if(detect[3] <0) then
				vehicleTransform.pos = TransformToParentPoint(
		    								vehicleTransform,Vec(0,0,-boundsSize[3]*.50))
			elseif(detect[3] >0) then
				vehicleTransform.pos = TransformToParentPoint(
		    								vehicleTransform,Vec(0,0,boundsSize[3]*.50))
			end
			if(detect[1] <0) then
				vehicleTransform.pos = TransformToParentPoint(
		    								vehicleTransform,Vec(-boundsSize[1]*.25),0,0)
			elseif(detect[1] >0) then
				vehicleTransform.pos = TransformToParentPoint(
		    								vehicleTransform,Vec(boundsSize[1]*.25),0,0)
			end
			-- QueryRejectVehicle(vehicle.id)
		    local fwdPos = 
		    						TransformToParentPoint(
		    								vehicleTransform,detect)
		    local direction = VecNormalize(VecSub(fwdPos,vehicleTransform.pos))
		    QueryRejectVehicle(vehicle.id)
		    QueryRequire("physical static large")

		    -- DebugWatch("direction",direction)
		    -- DebugWatch("length", VecLength(direction)*2)
		    local hit,dist,normal, shape = QueryRaycast(vehicleTransform.pos, direction, VecLength(detect))
		    

		    local 	lineColour = detectColour
		    local  costModifider = 5

		    if(hit) then
				local hitPoint = VecAdd(vehicleTransform.pos, VecScale(direction, dist))
				local mat,r,g,b  = GetShapeMaterialAtPosition(shape, hitPoint)
				if(mat =="masonry") then
					local validSurfaceColours = ai.validSurfaceColours[1]
					local validRange = validSurfaceColours.range
					if(inRange(validSurfaceColours.r-validRange,validSurfaceColours.r+validRange,r)
					 and inRange(validSurfaceColours.g-validRange,validSurfaceColours.g+validRange,g) 
					 and inRange(validSurfaceColours.b-validRange,validSurfaceColours.b+validRange,b)) then 
						hit = false
						lineColour = clearColour
						costModifider = 1
					end
				else
					if(detect[3]<0 and detect[1]~=0) then 
					detect[1]=-detect[1]
					costModifider = 0.1
					hit = true
					end
					lineColour = hitColour
					-- DebugPrint("Raycast hit voxel made out of " .. mat)
				end
		    end		   

			
		    costs[key] = costFunc2(TransformToParentPoint(
		    								vehicleTransform,detect),hit,dist,shape,key)
		    costs[key] = costs[key] * costModifider

		    -- DebugWatch("costs: "..key,costs[key])
	        if costs[key] < bestCost.val  then
		    	bestCost.key = key
		    	bestCost.val = costs[key] 
		    	bestCost.target = detect
		    end
		    
		    -- DebugLine(vehicleTransform.pos, fwdPos, lineColour[1], lineColour[2], lineColour[3])


		end
	end
	return bestCost

	-- DebugLine(vehicleTransform.pos, fwd, 1, 0, 0)
	-- DebugLine(vehicleTransform.pos, fwdL, 1, 0, 0)
	-- DebugLine(vehicleTransform.pos, fwdR, 1, 0, 0)

end

function scanPos(vehicleTransform,detect,boundsSize)

	QueryRejectVehicle(vehicle.id)
    local fwdPos = 
    						TransformToParentPoint(
    								vehicleTransform,detect)
    local direction = VecSub(fwdPos,vehicleTransform.pos)
    hit,dist,normal, shape = QueryRaycast(vehicleTransform.pos, direction, VecLength(direction)*.5,boundsSize[1]*.1)
    
    if(hit) then
		local hitPoint = VecAdd(vehicleTransform.pos, VecScale(direction, dist))
		local mat = GetShapeMaterialAtPosition(shape, hitPoint)
		DebugPrint("Raycast hit voxel made out of " .. mat)
    end

	-- for i = 1,ai.numScans do 


	-- end
	return hit,dist,normal, shape

end



function costFunc2(testPos,hit,dist,shape,key)



	local cost = 10000 
	if(not hit) then 
		cost = VecLength(VecSub(testPos,goalPos))*(1-weights[key])
	end
	return cost
end



function vehicleDetection5( )

	local vehicleBody = GetVehicleBody(vehicle.id)
	local vehicleTransform = GetVehicleTransform(vehicle.id)
	local min,max = GetBodyBounds(vehicleBody)
	vehicleTransform.pos = TransformToParentPoint(vehicleTransform,Vec(0,testHeight,0))
	local vehicleTransformOrig = TransformCopy(vehicleTransform) 
	local fwd = 	TransformToParentPoint(vehicleTransform,Vec(0,0,-detectRange*1.5))
	local fwdL = 	TransformToParentPoint(vehicleTransform,Vec(detectRange,0,-detectRange))
	local fwdR = 	TransformToParentPoint(vehicleTransform,Vec(-detectRange,0,-detectRange))
	local boundsSize = VecSub(max, min)
	DebugWatch("min",VecStr(min))

	DebugWatch("max",VecStr(max))
	DebugWatch("boundsize",boundsSize)
	costs = { }
	bestCost = {key = 0, val = 1000, target = Vec(0,0,0)}

	if(VecLength(goalPos)> 0.5 and VecLength(
									VecSub(GetVehicleTransform(vehicle.id).pos,goalPos))>1) then	
		for key,detect in ipairs(detectPoints) do 


			--detect = VecScale(detect ,1+(clamp(0,100,math.log(VecLength(GetBodyVelocity(GetVehicleBody(vehicle.id))))))*.5)

			vehicleTransform = GetVehicleTransform(vehicle.id)
			vehicleTransform.pos = TransformToParentPoint(vehicleTransform,Vec(0,testHeight*.25,0))
			if(detect[3] <0) then
				vehicleTransform.pos = TransformToParentPoint(
		    								vehicleTransform,Vec(0,0,-boundsSize[3]*.50))
			elseif(detect[3] >0) then
				vehicleTransform.pos = TransformToParentPoint(
		    								vehicleTransform,Vec(0,0,boundsSize[3]*.50))
			end
			if(detect[1] <0) then
				vehicleTransform.pos = TransformToParentPoint(
		    								vehicleTransform,Vec(-boundsSize[1]*.25),0,0)
			elseif(detect[1] >0) then
				vehicleTransform.pos = TransformToParentPoint(
		    								vehicleTransform,Vec(boundsSize[1]*.25),0,0)
			end
			-- QueryRejectVehicle(vehicle.id)
		    local fwdPos = 
		    						TransformToParentPoint(
		    								vehicleTransform,detect)
		    local direction = VecNormalize(VecSub(fwdPos,vehicleTransform.pos))
		    QueryRejectVehicle(vehicle.id)
		    QueryRequire("physical static large")

		    -- DebugWatch("direction",direction)
		    -- DebugWatch("length", VecLength(direction)*2)
		    local hit,dist,normal, shape = QueryRaycast(vehicleTransform.pos, direction, VecLength(detect))
		    

		    local 	lineColour = detectColour
		    local  costModifider = 5

		    if(hit) then
				local hitPoint = VecAdd(vehicleTransform.pos, VecScale(direction, dist))
				local mat,r,g,b  = GetShapeMaterialAtPosition(shape, hitPoint)
				if(mat =="masonry") then
					for colKey, validSurfaceColours in ipairs(ai.validSurfaceColours) do 
						
						local validRange = validSurfaceColours.range
						DebugPrint((validSurfaceColours.r-validRange.." | "..validSurfaceColours.r+validRange.." | "..r))
						if(inRange(validSurfaceColours.r-validRange,validSurfaceColours.r+validRange,r)
						 and inRange(validSurfaceColours.g-validRange,validSurfaceColours.g+validRange,g) 
						 and inRange(validSurfaceColours.b-validRange,validSurfaceColours.b+validRange,b)) then 
							hit = false
							lineColour = clearColour
							costModifider = 1
						end
					end
				else

					-- DebugPrint("Raycast hit voxel made out of " .. mat)
				end
		    end		   
			
		    costs[key] = costFunc2(TransformToParentPoint(
		    								vehicleTransform,detect),hit,dist,shape,key)
		    costs[key] = costs[key] * costModifider

		    -- DebugWatch("costs: "..key,costs[key].." | "..VecStr(detect))
		    if(hit )then
		    	lineColour = hitColour
		    else
			    if costs[key] < bestCost.val  then
			    	bestCost.key = key
			    	bestCost.val = costs[key] 
			    	bestCost.target = detect
			    end
		    end
		    -- DebugLine(vehicleTransform.pos, fwdPos, lineColour[1], lineColour[2], lineColour[3])


		end
	end
	return bestCost

	-- DebugLine(vehicleTransform.pos, fwd, 1, 0, 0)
	-- DebugLine(vehicleTransform.pos, fwdL, 1, 0, 0)
	-- DebugLine(vehicleTransform.pos, fwdR, 1, 0, 0)

end


---QueryAabbShapes
function vehicleDetection4( )

	local vehicleBody = GetVehicleBody(vehicle.id)
	local vehicleTransform = GetVehicleTransform(vehicle.id)
	local min,max = GetBodyBounds(vehicleBody)
	vehicleTransform.pos = TransformToParentPoint(vehicleTransform,Vec(0,testHeight,0))
	local vehicleTransformOrig = TransformCopy(vehicleTransform) 
	local fwd = 	TransformToParentPoint(vehicleTransform,Vec(0,0,-detectRange*1.5))
	local fwdL = 	TransformToParentPoint(vehicleTransform,Vec(detectRange,0,-detectRange))
	local fwdR = 	TransformToParentPoint(vehicleTransform,Vec(-detectRange,0,-detectRange))
	local boundsSize = VecSub(max, min)
	-- DebugWatch("min",VecStr(min))

	-- DebugWatch("max",VecStr(max))
	-- DebugWatch("boundsize",boundsSize)
	costs = { }
	bestCost = {key = 0, val = 1000, target = Vec(0,0,0)}

	if(VecLength(goalPos)> 0.5 and VecLength(
									VecSub(GetVehicleTransform(vehicle.id).pos,goalPos))>1) then	
		for key,detect in ipairs(detectPoints) do 

			vehicleTransform = GetVehicleTransform(vehicle.id)
			vehicleTransform.pos = TransformToParentPoint(vehicleTransform,Vec(0,testHeight,0))
			local vehiclePos = vehicleTransform.pos
			if(detect[3] <0) then
				vehicleTransform.pos = TransformToParentPoint(
		    								vehicleTransform,Vec(0,0,-boundsSize[3]*.4))
			elseif(detect[3] >0) then
				vehicleTransform.pos = TransformToParentPoint(
		    								vehicleTransform,Vec(0,0,boundsSize[3]*.4))
			end
			if(detect[1] <0) then
				vehicleTransform.pos = TransformToParentPoint(
		    								vehicleTransform,Vec(-boundsSize[1]*.25),0,0)
			elseif(detect[1] >0) then
				vehicleTransform.pos = TransformToParentPoint(
		    								vehicleTransform,Vec(boundsSize[1]*.25),0,0)
			end
			QueryRejectVehicle(vehicle.id)
		    local fwdPos = 
		    						TransformToParentPoint(
		    								vehicleTransform,detect)
		    local direction = VecSub(fwdPos,vehicleTransform.pos)
		    hit, dist = QueryRaycast(vehicleTransform.pos, direction, VecLength(direction)*.5)--,boundsSize[1]*.7)
		    local lineColour = clearColour

		    costs[key] = costFunc(TransformToParentPoint(
		    								vehicleTransform,detect),hit,key)
		    DebugWatch("costs: "..key,costs[key])
		    if(hit and dist<detectRange)then
		    	lineColour = hitColour
		    else
		    	QueryRejectVehicle(vehicle.id)
		    	-- local list1 = QueryAabbShapes(VecAdd(fwdPos,
		    	-- 					Vec(-detectRange*.5,-testHeight*.25,-detectRange*.5)),
		    	-- 					VecAdd(fwdPos,
		    	-- 					Vec(detectRange*.5,testHeight,detectRange*.5)))
		    	-- local list2 = QueryAabbShapes(VecAdd(fwdPos,
		    	-- 					Vec(-detectRange*.5,-testHeight*1.5,-detectRange*.5)),
		    	-- 					VecAdd(fwdPos,
		    	-- 					Vec(detectRange*.5,0,detectRange*.5)))
		    	-- local list1 = QueryAabbShapes(TransformToParentPoint(
		    	-- 							vehicleTransform,VecAdd(detect,
		    	-- 					Vec(-detectRange*.5,-testHeight*.5,-detectRange*.5))),
		    	-- 					TransformToParentPoint(
		    	-- 							vehicleTransform,VecAdd(detect,
		    	-- 					Vec(detectRange*.5,testHeight,detectRange*.5))))
		    	-- local list2 = QueryAabbShapes(TransformToParentPoint(
		    	-- 							vehicleTransform,VecAdd(detect,
		    	-- 					Vec(-detectRange*.5,-testHeight*1.5,-detectRange*.5))),
		    	-- 					TransformToParentPoint(
		    	-- 							vehicleTransform,VecAdd(detect,
		    	-- 					Vec(detectRange*.5,0,detectRange*.5))))
				local c = fwdPos
				vehicleTransform.pos = fwdPos
				local mi = TransformToParentPoint(
		    								vehicleTransform,Vec(-VecLength(direction)/2, -testHeight, -VecLength(direction)/2))
				local mi2 = TransformToParentPoint(
		    								vehicleTransform,Vec(-VecLength(direction)/2, -testHeight, -VecLength(direction)/2))
				local ma = TransformToParentPoint(
		    								vehicleTransform, Vec(VecLength(direction)/2, detectRange/2, VecLength(direction)/2))
				local ma2 = TransformToParentPoint(
		    								vehicleTransform, Vec(VecLength(direction)/2, detectRange/2, VecLength(direction)/2))
		    DebugWatch("mi",mi)
		    DebugWatch("ma",ma)
		    DebugWatch("fwd",fwdPos)
		    	QueryRejectVehicle(vehicle.id)
		    	QueryRequire("static")
				local list2 = QueryAabbBodies(mi2, ma2)
				QueryRequire("static")
				QueryRejectVehicle(vehicle.id)
				local list1= QueryAabbBodies(mi, ma)
		    	DebugWatch("list1",#list1)
		    	DebugWatch("list2",#list2)
		    	if(#list2==0) then 
		    		lineColour = detectColour
		    		costs[key] = costs[key] *5

		    	elseif( #list1>0)then 
		    		lineColour = hitColour
		    	end
				    if  #list1==0 and costs[key] < bestCost.val  then
				    	bestCost.key = key
				    	bestCost.val = costs[key] 
				    	bestCost.target = detect
				    end
			    DebugLine(mi, ma, lineColour[1], lineColour[2], lineColour[3])
			    DebugLine(mi2, ma2, lineColour[1], lineColour[2], lineColour[3])
		    end

		    DebugLine(vehiclePos, fwdPos, lineColour[1], lineColour[2], lineColour[3])


		end
	end
	return bestCost

	-- DebugLine(vehicleTransform.pos, fwd, 1, 0, 0)
	-- DebugLine(vehicleTransform.pos, fwdL, 1, 0, 0)
	-- DebugLine(vehicleTransform.pos, fwdR, 1, 0, 0)

end

--- shapecast

function vehicleDetection3( )

	local vehicleBody = GetVehicleBody(vehicle.id)
	local vehicleTransform = GetVehicleTransform(vehicle.id)
	local min,max = GetBodyBounds(vehicleBody)
	vehicleTransform.pos = TransformToParentPoint(vehicleTransform,Vec(0,testHeight,0))
	local vehicleTransformOrig = TransformCopy(vehicleTransform) 
	local fwd = 	TransformToParentPoint(vehicleTransform,Vec(0,0,-detectRange*1.5))
	local fwdL = 	TransformToParentPoint(vehicleTransform,Vec(detectRange,0,-detectRange))
	local fwdR = 	TransformToParentPoint(vehicleTransform,Vec(-detectRange,0,-detectRange))
	local boundsSize = VecSub(max, min)
	DebugWatch("min",VecStr(min))

	DebugWatch("max",VecStr(max))
	DebugWatch("boundsize",boundsSize)
	costs = { }
	bestCost = {key = 0, val = 1000, target = Vec(0,0,0)}

	if(VecLength(goalPos)> 0.5 and VecLength(
									VecSub(GetVehicleTransform(vehicle.id).pos,goalPos))>3) then	
		for key,detect in ipairs(detectPoints) do 

			vehicleTransform = GetVehicleTransform(vehicle.id)
			vehicleTransform.pos = TransformToParentPoint(vehicleTransform,Vec(0,testHeight,0))
			if(detect[3] <0) then
				vehicleTransform.pos = TransformToParentPoint(
		    								vehicleTransform,Vec(0,0,-boundsSize[3]*.30))
			elseif(detect[3] >0) then
				vehicleTransform.pos = TransformToParentPoint(
		    								vehicleTransform,Vec(0,0,boundsSize[3]*.30))
			end
			if(detect[1] <0) then
				vehicleTransform.pos = TransformToParentPoint(
		    								vehicleTransform,Vec(-boundsSize[1]*.25),0,0)
			elseif(detect[1] >0) then
				vehicleTransform.pos = TransformToParentPoint(
		    								vehicleTransform,Vec(boundsSize[1]*.25),0,0)
			end
			QueryRejectVehicle(vehicle.id)
		    local fwdPos = 
		    						TransformToParentPoint(
		    								vehicleTransform,detect)
		    local direction = VecSub(fwdPos,vehicleTransform.pos)
		    hit, dist = QueryRaycast(vehicleTransform.pos, direction, VecLength(direction)*.7,boundsSize[1]*.25)
		    local lineColour = clearColour

		    costs[key] = costFunc(TransformToParentPoint(
		    								vehicleTransform,detect),hit,key)
		    DebugWatch("costs: "..key,costs[key])
		    if(hit )then
		    	lineColour = hitColour
		    else
			    if costs[key] < bestCost.val  then
			    	bestCost.key = key
			    	bestCost.val = costs[key] 
			    	bestCost.target = detect
			    end
		    end
		    DebugLine(vehicleTransform.pos, fwdPos, lineColour[1], lineColour[2], lineColour[3])


		end
	end
	return bestCost

	-- DebugLine(vehicleTransform.pos, fwd, 1, 0, 0)
	-- DebugLine(vehicleTransform.pos, fwdL, 1, 0, 0)
	-- DebugLine(vehicleTransform.pos, fwdR, 1, 0, 0)

end



function vehicleDetection2( )

	local vehicleBody = GetBodyTransform(GetVehicleBody(vehicle.id))
	local vehicleTransform = GetVehicleTransform(vehicle.id)
	local min,max = GetBodyBounds(vehicleBody)
	vehicleTransform.pos = TransformToParentPoint(vehicleTransform,Vec(0,testHeight,0))
	local fwd = 	TransformToParentPoint(vehicleTransform,Vec(0,0,-detectRange*1.5))
	local fwdL = 	TransformToParentPoint(vehicleTransform,Vec(detectRange,0,-detectRange))
	local fwdR = 	TransformToParentPoint(vehicleTransform,Vec(-detectRange,0,-detectRange))

	costs = { }
	bestCost = {key = 0, val = 1000}

	if(VecLength(goalPos)> 0.5 and VecLength(
									VecSub(GetVehicleTransform(vehicle.id).pos,goalPos))>3) then	
		for key,detect in ipairs(detectPoints) do 
			QueryRejectVehicle(vehicle.id)
		    local fwdPos = 
		    						TransformToParentPoint(
		    								vehicleTransform,detect)
		    local direction = VecSub(fwdPos,vehicleTransform.pos)
		    hit, dist = QueryRaycast(vehicleTransform.pos, direction, VecLength(direction)/1,0.25)
		    local lineColour = clearColour
		    if(hit and dist<detectRange)then
		    	lineColour = hitColour
		    end
		    DebugLine(vehicleTransform.pos, fwdPos, lineColour[1], lineColour[2], lineColour[3])
		    costs[key] = costFunc(TransformToParentPoint(
		    								vehicleTransform,detect),hit,key)
		    DebugWatch("costs: "..key,costs[key])
		    if costs[key] < bestCost.val  then
		    	bestCost.key = key
		    	bestCost.val = costs[key] 
		    	bestCost.target = detect
		    end
		end
	end
	return bestCost

	-- DebugLine(vehicleTransform.pos, fwd, 1, 0, 0)
	-- DebugLine(vehicleTransform.pos, fwdL, 1, 0, 0)
	-- DebugLine(vehicleTransform.pos, fwdR, 1, 0, 0)

end

function vehicleDetection( )

	local vehicleTransform = GetBodyTransform(GetVehicleBody(vehicle.id))
	vehicleTransform.pos = TransformToParentPoint(vehicleTransform,Vec(0,testHeight,0))
	local fwd = 	TransformToParentPoint(vehicleTransform,Vec(0,0,-detectRange*1.5))
	local fwdL = 	TransformToParentPoint(vehicleTransform,Vec(detectRange,0,-detectRange))
	local fwdR = 	TransformToParentPoint(vehicleTransform,Vec(-detectRange,0,-detectRange))

	costs = { }
	bestCost = {key = 0, val = 100}

	if(VecLength(goalPos)> 0.5 and VecLength(
									VecSub(GetVehicleTransform(vehicle.id).pos,goalPos))>3) then	
		for key,detect in ipairs(detectPoints) do 
			QueryRejectVehicle(vehicle.id)
		    local fwdPos = 
		    						TransformToParentPoint(
		    								vehicleTransform,detect)
		    local direction = VecSub(fwdPos,vehicleTransform.pos)
		    hit, dist = QueryRaycast(vehicleTransform.pos, direction, VecLength(direction)/1,.5)
		    local lineColour = clearColour
		    if(hit and dist<detectRange)then
		    	lineColour = hitColour
		    end
		    DebugLine(vehicleTransform.pos, fwdPos, lineColour[1], lineColour[2], lineColour[3])
		    costs[key] = costFunc(TransformToParentPoint(
		    								vehicleTransform,detect),hit)
		    DebugWatch("costs: "..key,costs[key])
		    if costs[key] < bestCost.val  then
		    	bestCost.key = key
		    	bestCost.val = costs[key] 
		    end
		end
	end
	return bestCost

	-- DebugLine(vehicleTransform.pos, fwd, 1, 0, 0)
	-- DebugLine(vehicleTransform.pos, fwdL, 1, 0, 0)
	-- DebugLine(vehicleTransform.pos, fwdR, 1, 0, 0)

end


function MAV(targetCost)
	targetMoves.targetIndex = (targetMoves.targetIndex%#targetMoves.list)+1 
	targetMoves.target = VecSub(targetMoves.target,targetMoves.list[targetMoves.targetIndex])
	targetMoves.target = VecAdd(targetMoves.target,targetCost)
	targetMoves.list[targetMoves.targetIndex] = targetCost
	return VecScale(targetMoves.target,(#targetMoves.list/100))

end

function controlVehicle( targetCost)
	local hBrake = false
	if(VecLength(goalPos)> 0.5) then
		local targetMove = VecNormalize(targetCost.target)

		if(VecLength(
										VecSub(GetVehicleTransform(vehicle.id).pos,goalPos))>2) then
			DebugWatch("pre updated",VecStr(targetMove))
			if(targetMove[1] ~= 0 and targetMove[3] ==0) then 
				targetMove[3] = 1
				
					targetMove[1] = -targetMove[1]
				

			end
			if(targetMove[1]~= 0) then
				targetMove[3] = targetMove[3]*0.8
				targetMove[1] = targetMove[1] * 3

			end 

			DriveVehicle(vehicle.id, -targetMove[3]*drivePower,-targetMove[1], hBrake)
			DebugWatch("post updated",VecStr(targetMove))
			DebugWatch("motion2",VecStr(detectPoints[targetCost.key]))
		else 
			DriveVehicle(vehicle.id, 0,0, true)
		end
	end
end


function costFunc(testPos,hit,key)
	local cost = 10000 
	if(not hit) then 
		cost = VecLength(VecSub(testPos,goalPos))*(1-weights[key])
	end
	return cost
end

function vehicleMovement(vel,angVel)
	local vehicleTransform = GetBodyTransform(vehicle.body)
	local targetVel = 	TransformToParentPoint(vehicleTransform,vel)
	targetVel = VecSub(targetVel, vehicleTransform.pos)
	local targetAngVel = 	angVel---TransformToParentPoint(vehicleTransform,angVel)
	local currentVel = GetBodyVelocity(vehicle.body)
	local currentAngVel = GetBodyAngularVelocity(vehicle.body)

	if(VecLength(currentVel)<maxSpeed) then

		SetBodyVelocity(vehicle.body,VecAdd(currentVel,targetVel))
	end
	SetBodyAngularVelocity(vehicle.body, VecAdd(currentAngVel,targetAngVel))

end

-- SetBodyVelocity(handle, velocity)
-- SetBodyAngularVelocity(body, angVel)



function clamp(val, lower, upper)
    if lower > upper then lower, upper = upper, lower end -- swap if boundaries supplied the wrong way
    return math.max(lower, math.min(upper, val))
end





function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end



function inRange(min,max,value)
		if(min < value and value<=max) then 
			return true

		else
			return false
		end

end