#include "config.lua"
#include "tools-2.lua"

pTool = GetStringParam("firehose", "none")

function init()
    AnyUpgrades = {}
end

function tick()
    for i=1, #Upgrades do
        if not AnyUpgrades[i] then
            if GetBool("savegame.mod.upgrades." ..i.. ".bought") then
                AnyUpgrades[i] = true
                local newTool = GetBool("game.tool.waterhose.enabled", true)
            end
        end
    end
end