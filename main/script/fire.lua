#include "config.lua"

fire_pos = {
  Vec(-13.9, 0.9, -17.8),
  Vec(-23.7, 0.9, -54.3),
  Vec(-32.3, 6.5, -47.8),
  ---Vec(154, 17.7, 332.4),
  ---Vec(-5, 0.1, 5),
  ---Vec(-5, 0.1, -5),
  --Vec(another),
  --etc.
}
f = GetFireCount()

time_of_next_fire = 1
time_stuff = 1

Taskss = {}

function tick()
  for i=1, #StartMails do
    if GetString("savegame.mod.task." ..i.. ".status","Accepted") then
      DebugWatch("Next Fire", GetTime() - time_of_next_fire)
      if time_of_next_fire ~= nil and GetTime() > time_of_next_fire and #fire_pos > 0 then -- check here if there are fireposition left

        -- get a point from the list, remove it from the list, and summon fires around that point.
        fire = table.remove(fire_pos, math.random(1, #fire_pos))	
    
        for i=1,10 do
          SpawnFire(VecAdd(fire, Vec(math.random(-2,2), 0, math.random(-2,2))))
        end
      end
      if f > 0 then
        if time_stuff ~= nil and GetTime() > time_stuff then
          time_stuff = GetTime() + 10
          RemoveAabbFires(Vec(-10000,-10000,-10000), Vec(10000,10000,10000))
        end
      end
    end
  end
end







