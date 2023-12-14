local QBCore = exports["qb-core"]:GetCoreObject()
local Util = exports["giga-util"]:GetUtils()

local function Debugger(identifier)
  return Util.Debugger(GetCurrentResourceName() .. ":client:" .. identifier)
end

local function IsVehicleExempt(vehicle)
  if not #Config.Exempt.Classes then return false end
  local vehicleClass = GetVehicleClass(vehicle)
  for _, exemptVehicleClass in ipairs(Config.Exempt.Classes) do
    if vehicleClass == exemptVehicleClass then return true end
  end
  local vehicleModel = GetEntityModel(vehicle)
  for _, exemptVehicleModel in ipairs(Config.Exempt.Models) do
    if vehicleModel == exemptVehicleModel then return true end
  end
  return false
end

RegisterNetEvent("giga-jimmy:client:BreakIn")
AddEventHandler("giga-jimmy:client:BreakIn", function()
  local debug = Debugger("event:BreakIn")
  local pos = GetEntityCoords(PlayerPedId())
  if type(pos) ~= "vector3" then return debug("pos not vector3") end
  local vehicle = GetClosestVehicle(pos.x, pos.y, pos.z, 5.0, 0, 71)
  debug({ vehicle = vehicle, })
  if not DoesEntityExist(vehicle) then
    return QBCore.Functions.Notify(
      "Vehicle is not locked!", "error")
  end

  if IsVehicleExempt(vehicle) then return QBCore.Functions.Notify("You cannot break into this vehicle!", "error") end
  if QBCore.Functions.GetPlate(vehicle) == "BUY ME" then return QBCore.Functions.Notify(
    "You cannot break into this vehicle!", "error") end
  Citizen.CreateThread(function()
    exports["progressbar"]:Progress({
      name = "giga-jimmy",
      duration = Util.Chance.Range(Config.Duration.Minimum, Config.Duration.Maximum),
      label = "Attempting to break in...",
      useWhileDead = false,
      canCancel = true,
      controlDisables = {
        disableMovement = true,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
      },
      animation = {
        animDict = "veh@break_in@0h@p_m_one@",
        anim = "low_force_entry_ds",
        flags = 17,
      },
      prop = {
        model = "prop_ing_crowbar",
        bone = 57005,
        coords = {
          x = 0.1,
          y = 0.0,
          z = 0.0,
        },
        rotation = {
          x = -90.0,
          y = 180.0,
          z = 0.0,
        },
      },
    }, function(cancelled)
      ClearPedTasksImmediately(PlayerPedId())
      if cancelled then return end
      if not Util.Chance.Boolean(Config.Probability.Success) then
        return QBCore.Functions.Notify("Failed to break in.",
          "error")
      end
      --SetVehicleDoorsLocked(vehicle, 1)
      TriggerServerEvent("qb-vehiclekeys:server:breakindoor", NetworkGetNetworkIdFromEntity(vehicle))

      QBCore.Functions.Notify("Successfully broke in!", "success")
    end)
  end)

  local shouldAlert = Config.Alert.Enabled and Util.Chance.Boolean(Config.Probability.Alert) or false
  debug({ shouldAlert = shouldAlert, })
  if not shouldAlert then return end
  debug("reporting crime...")
  exports["ps-dispatch"]:VehicleTheft(vehicle)
end)
