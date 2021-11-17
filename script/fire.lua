fire_pos = {
  Vec(154, 21.7, 327.4),
  Vec(154, 17.7, 332.4),
  Vec(-5, 0.1, 5),
  Vec(-5, 0.1, -5),
  --Vec(another),
  --etc.
}

function init()
  time_of_next_fire = 1
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
end