spawned = nil

Citizen.CreateThread(function()
    while true do
        local pCoords = GetEntityCoords(PlayerPedId())
        for i=1, #Cars do  
            if #(pCoords - Cars[i].pos) < DrawDistance then                                    
                if Cars[i].spawned == nil then
                    SpawnLocalCar(i) 
                end
            else
                DeleteEntity(Cars[i].spawned)
                Cars[i].spawned = nil                                
            end
            Wait(500)
        end
    end
end)

Citizen.CreateThread(function() 
    while true do
        for i=1, #Cars do
            if Cars[i].spawned ~= nil and Cars[i].spin then
                SetEntityHeading(Cars[i].spawned, GetEntityHeading(Cars[i].spawned) - 0.3)
            end
        end
        Wait(5)
    end
end)

function SpawnLocalCar(i)
    Citizen.CreateThread(function()
        local hash = GetHashKey(Cars[i].model)
        RequestModel(hash)
        local attempt = 0
        while not HasModelLoaded(hash) do
            attempt = attempt + 1
            if attempt > 2000 then return end
            Wait(0)
        end
        local veh = CreateVehicle(hash, Cars[i].pos.x, Cars[i].pos.y, Cars[i].pos.z-1,Cars[i].heading, false, false)
        SetModelAsNoLongerNeeded(hash)
        SetVehicleEngineOn(veh, false)
        SetVehicleBrakeLights(veh, false)
        SetVehicleLights(veh, 0)
        SetVehicleLightsMode(veh, 0)
        SetVehicleInteriorlight(veh, false)
        SetVehicleOnGroundProperly(veh)
        FreezeEntityPosition(veh, true)
        SetVehicleCanBreak(veh, true)
        SetVehicleFullbeam(veh, false)
        if carInvincible then
        SetVehicleReceivesRampDamage(veh, true)
        RemoveDecalsFromVehicle(veh)
        SetVehicleCanBeVisiblyDamaged(veh, true)
        SetVehicleLightsCanBeVisiblyDamaged(veh, true)
        SetVehicleWheelsCanBreakOffWhenBlowUp(veh, false)  
        SetDisableVehicleWindowCollisions(veh, true)    
        SetEntityInvincible(veh, true)
        end
        if DoorLock then 
            SetVehicleDoorsLocked(veh, 2)
        end
        SetVehicleNumberPlateText(veh, Cars[i].plate)
        Cars[i].spawned = veh
    end)
end

AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() then
        for i=1, #Cars do
            if Cars[i].spawned ~= nil then
                DeleteEntity(Cars[i].spawned)
            end
        end
    end
end)

