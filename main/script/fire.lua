#include "config.lua"

time_of_next_fire = 5

Taskss = {}

fireSpread = 0.4
maxFires = 300

function init()
  SetInt("game.fire.maxcount", 300)
  SetFloat("game.fire.spread", 0.4)
  for i=1,4 do SetFloat('savegame.mod.employees.4.currentWaitingTime', Employees[i].speed) end
  
  tasksRunning = 0
  
  fire_pos = {}
  
  local firestarters = FindLocations("firestarter",true)
  for i=1, #firestarters do
	table.insert(fire_pos,GetLocationTransform(firestarters[i]).pos)
  end
end

function handleEmployees(dt)
	for employee=4,1,-1 do
		if GetInt('savegame.mod.employees.'..employee..'.hired') > 0 then 
			local waitingText = string.format("Waiting (%d s)",math.floor(GetFloat('savegame.mod.employees.'..employee..'.currentWaitingTime')));
			if math.floor(GetFloat('savegame.mod.employees.'..employee..'.currentWaitingTime')) == 0 then
				waitingText = "Ready"
			end
			DebugWatch("Employee "..employee, waitingText.." | Time for next payment: " .. math.floor(60*6-GetFloat('savegame.mod.employees.'..employee..'.currentWorkingTime')) .."s")				
			if GetFloat('savegame.mod.employees.'..employee..'.currentWorkingTime') > 60*6 then			
				local cost = Employees[employee].costPerHour
			
				DebugPrint("Employee "..employee.." charges you "..cost.."$")
				SetInt('savegame.mod.userMoney', GetInt('savegame.mod.userMoney') - cost)		
				SetFloat('savegame.mod.employees.'..employee..'.currentWorkingTime',0)				
			else
				SetFloat('savegame.mod.employees.'..employee..'.currentWorkingTime',GetFloat('savegame.mod.employees.'..employee..'.currentWorkingTime') + dt)				
			end		

			if GetFloat('savegame.mod.employees.'..employee..'.currentWaitingTime') > 0 then				
				SetFloat('savegame.mod.employees.'..employee..'.currentWaitingTime', GetFloat('savegame.mod.employees.'..employee..'.currentWaitingTime') - dt)
			end							
		end
	end	
end

function tick(dt)
  
  handleEmployees(dt)
  
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
		if GetInt('savegame.mod.employees.'..employee..'.hired') > 0 then 
			if GetFloat('savegame.mod.employees.'..employee..'.currentWaitingTime') <= 0 then				
				employeeReady = employee
			end				
			break
		end
	end	
	
	if employeeReady > 0 then		
		DebugPrint("Employee "..employeeReady.." deleted the fire." .. Employees[employeeReady].speed)
		RemoveAabbFires(Vec(-10000,-10000,-10000), Vec(10000,10000,10000))
		SetFloat('savegame.mod.employees.'..employeeReady..'.currentWaitingTime', Employees[employeeReady].speed)		
	end
  elseif GetInt('savegame.mod.tasks.running') > 0 then
	for i=1, tasksRunning do
		DebugPrint("Task completed! You received 100$.")		
		SetInt('savegame.mod.userMoney', GetInt('savegame.mod.userMoney') + 100)
	end		
	tasksRunning = 0
  end
end