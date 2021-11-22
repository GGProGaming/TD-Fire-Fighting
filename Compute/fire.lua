fire_pos = {
  Vec(-52.5, 0.0, -47.5),
  Vec(-53.5, 0.0, -46.5),
  Vec(-51.5, 0.0, -48.5),
  ---Vec(154, 17.7, 332.4),
  ---Vec(-5, 0.1, 5),
  ---Vec(-5, 0.1, -5),
  --Vec(another),
  --etc.
}


time_of_next_fire = 1

function clearFires()
	RemoveAabbFires(Vec(-10000, -10000, -10000), Vec(10000, 10000, 10000))
end


function tick()
	DebugWatch("Next Fire", GetTime() - time_of_next_fire)
  if time_of_next_fire ~= nil and GetTime() > time_of_next_fire and #fire_pos > 0 then -- check here if there are fireposition left
    time_of_next_fire = GetTime() + 10 -- in 60 seconds the next fire will spawn

    -- get a point from the list, remove it from the list, and summon fires around that point.
    fire = table.remove(fire_pos, math.random(1, #fire_pos))	
	
    for i=1,10 do
      SpawnFire(VecAdd(fire, Vec(math.random(-2,2), 0, math.random(-2,2))))
    end
  end
  if InputDown("k") then
    clearFires()
  end  
end

function update(dt)
  function Firefighter()
    if Employees > 0 then
      DebugWatch("DeleteFire", true)
      spawn(function()
        if Employees["stars"] then
          if Employees[1] then
            clearFires()
            wait(5)
          end
        end
      end)
    end
  end
end





