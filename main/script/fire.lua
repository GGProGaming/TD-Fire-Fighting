#include "config.lua"

time_of_next_fire = 5

Taskss = {}

fireSpread = 0.4
maxFires = 300

employeeSpeeds = {250,220,180,150}

function init()
  SetInt("game.fire.maxcount", 300)
  SetFloat("game.fire.spread", 0.4)
  for i=1,4 do SetFloat('savegame.mod.employees.4.currentWaitingTime', employeeSpeeds[i]) end
  
  tasksRunning = 0
  
  fire_pos = {}
  
  local firestarters = FindLocations("firestarter",true)
  for i=1, #firestarters do
	table.insert(fire_pos,GetLocationTransform(firestarters[i]).pos)
  end
end

function tick(dt)
  
  for i=1, #StartMails do
    if GetString(string.format('savegame.mod.task.%d.status', i)) == 'Accepted' and not GetBool(string.format('savegame.mod.task.%d.spawned', i)) then
      if GetTime() - GetFloat(string.format('savegame.mod.task.%d.accepted.timestamp', i)) > time_of_next_fire and #fire_pos > 0 then -- check here if there are fireposition left

        -- get a point from the list, remove it from the list, and summon fires around that point.
        fire = table.remove(fire_pos, math.random(1, #fire_pos))	
    
        for i=1,10 do
          SpawnFire(VecAdd(fire, Vec(math.random(-2,2), 0, math.random(-2,2))))
        end
		
		tasksRunning = tasksRunning +1 
		
		SetBool(string.format('savegame.mod.task.%d.spawned', i), true)
      end
    end
  end
  
  f = QueryAabbFireCount(Vec(-10000,-10000,-10000), Vec(10000,10000,10000))  
  
  if f > 0 then	
  
	local employeeReady = 0
	for employee=4,1,-1 do
		if GetInt('savegame.mod.employees.4.hired') > 0 then 
			if GetFloat('savegame.mod.employees.4.currentWaitingTime') > 0 then
				DebugWatch("Employee "..employee, string.format("Waiting (%d s)",GetFloat('savegame.mod.employees.4.currentWaitingTime')))			
				SetFloat('savegame.mod.employees.4.currentWaitingTime', GetFloat('savegame.mod.employees.4.currentWaitingTime') - dt)
			else
				DebugWatch("Employee "..employee, "Ready")
				SetBool('savegame.mod.employees.4.readyToFightAFire',true)			
				employeeReady = employee
			end				
			break
		end
	end	
	
	if employeeReady > 0 then		
		DebugPrint("Employee "..employeeReady.." deleted the fire.")
		RemoveAabbFires(Vec(-10000,-10000,-10000), Vec(10000,10000,10000))
		SetBool('savegame.mod.employees.'..employeeReady..'.readyToFightAFire',false)		
		SetFloat('savegame.mod.employees.'..employeeReady..'.currentWaitingTime', employeeSpeeds[employeeReady])		
	end
  elseif GetInt('savegame.mod.tasks.running') > 0 then
	for i=1, tasksRunning do
		DebugPrint("Task complete! You received 100$.")		
		SetInt('savegame.mod.userMoney', GetInt('savegame.mod.userMoney') + 100)
	end		
	tasksRunning = 0
  end
end