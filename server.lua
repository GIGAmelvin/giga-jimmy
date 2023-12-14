local QBCore = exports["qb-core"]:GetCoreObject()
local Util = exports["giga-util"]:GetUtils()

local function Debugger(identifier)
  return Util.Debugger(GetCurrentResourceName() .. ":server:" .. identifier)
end

QBCore.Functions.CreateUseableItem(Config.Item, function(source)
  local debug = Debugger("use:" .. Config.Item)
  debug({ src = source, })
  TriggerClientEvent("giga-jimmy:client:BreakIn", source)
end)
