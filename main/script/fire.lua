#include "terminal.lua"
#include "config.lua"

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
function init()
  GetFireCount()
end

time_of_next_fire = 1

function tick()
  for i=1, #Mails do
    if GetString("savegame.mod.task." ..i.. ".status","Accepted") then
      DebugWatch("Next Fire", GetTime() - time_of_next_fire)
      if time_of_next_fire ~= nil and GetTime() > time_of_next_fire and #fire_pos > 0 then -- check here if there are fireposition left

        -- get a point from the list, remove it from the list, and summon fires around that point.
        fire = table.remove(fire_pos, math.random(1, #fire_pos))	
    
        for i=1,10 do
          SpawnFire(VecAdd(fire, Vec(math.random(-2,2), 0, math.random(-2,2))))
        end
        
        if GetFireCount() > 0 then
          time_of_next_fire = GetTime() + 80
          RemoveAabbFires(Vec(-10000,-10000,-10000), Vec(10000,10000,10000))
        else
        end
      end
    end
  end
end







