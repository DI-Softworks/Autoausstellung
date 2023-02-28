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
        local tryAgainBitch = 0
        while not HasModelLoaded(hash) do
            tryAgainBitch = tryAgainBitch + 1
            if tryAgainBitch > 2000 then return end
            Wait(0)
        end
        local vehicleeee = CreateVehicle(hash, Cars[i].pos.x, Cars[i].pos.y, Cars[i].pos.z-1,Cars[i].heading, false, false)
        SetModelAsNoLongerNeeded(hash)
        SetVehicleEngineOn(vehicleeee, false)
        SetVehicleBrakeLights(vehicleeee, false)
        SetVehicleLights(vehicleeee, 0)
        SetVehicleLightsMode(vehicleeee, 0)
        SetVehicleInteriorlight(vehicleeee, false)
        SetVehicleOnGroundProperly(vehicleeee)
        FreezeEntityPosition(vehicleeee, true)
        SetVehicleCanBreak(vehicleeee, true)
        SetVehicleFullbeam(vehicleeee, false)
        if carInvincible then
        SetVehicleReceivesRampDamage(vehicleeee, true)
        RemoveDecalsFromVehicle(vehicleeee)
        SetVehicleCanBeVisiblyDamaged(vehicleeee, true)
        SetVehicleLightsCanBeVisiblyDamaged(vehicleeee, true)
        SetVehicleWheelsCanBreakOffWhenBlowUp(vehicleeee, false)  
        SetDisableVehicleWindowCollisions(vehicleeee, true)    
        SetEntityInvincible(vehicleeee, true)
        end
        if DoorLock then 
            SetVehicleDoorsLocked(vehicleeee, 2)
        end
        SetVehicleNumberPlateText(vehicleeee, Cars[i].plate)
        Cars[i].spawned = vehicleeee
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

