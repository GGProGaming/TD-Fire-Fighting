-- this marks this as a REAL valid level, preventing the
-- later init.lua from restarting it with additional layers.

-- it needs to be included into the scene under the "handle" group

local key = "savegame.mod"
local handleKey = key .. ".handle"
function init()
	SetBool(handleKey, true)
end