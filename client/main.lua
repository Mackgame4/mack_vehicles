-- mack_barriers
ESX =					nil
local PlayerData		= {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

--[[RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
	end)
end)]]--

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

AddEventHandler('onClientResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    for i=1, #Config.BarrierList do
        if Config.BarrierList[i].status == "locked" then
            local object_model = Config.BarrierList[i].objType
            local x,y,z = Config.BarrierList[i].objCoords.x, Config.BarrierList[i].objCoords.y, Config.BarrierList[i].objCoords.z
            Config.BarrierList[i].created_object = CreateObjectNoOffset(object_model, x, y, z, 1, 0, 1)
            SetEntityHeading(Config.BarrierList[i].created_object, Config.BarrierList[i].heading)
            PlaceObjectOnGroundProperly(Config.BarrierList[i].created_object)
            FreezeEntityPosition(Config.BarrierList[i].created_object, true)
            SetModelAsNoLongerNeeded(object_model)
        end
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local coords = GetEntityCoords(PlayerPedId())
		for i=1, #Config.BarrierList do
            if GetDistanceBetweenCoords(coords, Config.BarrierList[i].objCoords.x, Config.BarrierList[i].objCoords.y, Config.BarrierList[i].objCoords.z, true) < Config.BarrierList[i].maxDistance then
                if IsControlJustReleased(0, 38) and PlayerData.job ~= nil and PlayerData.job.name == Config.BarrierList[i].authorizedJob then
                    if Config.BarrierList[i].status == "locked" then
                        Config.BarrierList[i].status = "unlocked"
                        if DoesEntityExist(Config.BarrierList[i].created_object) then
                            DeleteEntity(Config.BarrierList[i].created_object)
                            if Config.Debug then
                                print("barreira apagada")
                            end
                        end
                    elseif Config.BarrierList[i].status == "unlocked" then
                        Config.BarrierList[i].status = "locked"
                        if not DoesEntityExist(Config.BarrierList[i].created_object) then
                            local object_model = Config.BarrierList[i].objType
                            local x,y,z = Config.BarrierList[i].objCoords.x, Config.BarrierList[i].objCoords.y, Config.BarrierList[i].objCoords.z
                            Config.BarrierList[i].created_object = CreateObjectNoOffset(object_model, x, y, z, 1, 0, 1)
                            SetEntityHeading(Config.BarrierList[i].created_object, Config.BarrierList[i].heading)
                            PlaceObjectOnGroundProperly(Config.BarrierList[i].created_object)
                            FreezeEntityPosition(Config.BarrierList[i].created_object, true)
                            SetModelAsNoLongerNeeded(object_model)
                        end
                        if Config.Debug then
                            print("barreira spawn")
                        end
                    end
                elseif IsControlJustReleased(0, 38) and Config.BarrierList[i].authorizedJob == "none" then
                    if Config.BarrierList[i].status == "locked" then
                        Config.BarrierList[i].status = "unlocked"
                        if DoesEntityExist(Config.BarrierList[i].created_object) then
                            DeleteEntity(Config.BarrierList[i].created_object)
                            if Config.Debug then
                                print("barreira apagada")
                            end
                        end
                    elseif Config.BarrierList[i].status == "unlocked" then
                        Config.BarrierList[i].status = "locked"
                        if not DoesEntityExist(Config.BarrierList[i].created_object) then
                            local object_model = Config.BarrierList[i].objType
                            local x,y,z = Config.BarrierList[i].objCoords.x, Config.BarrierList[i].objCoords.y, Config.BarrierList[i].objCoords.z
                            Config.BarrierList[i].created_object = CreateObjectNoOffset(object_model, x, y, z, 1, 0, 1)
                            SetEntityHeading(Config.BarrierList[i].created_object, Config.BarrierList[i].heading)
                            PlaceObjectOnGroundProperly(Config.BarrierList[i].created_object)
                            FreezeEntityPosition(Config.BarrierList[i].created_object, true)
                            SetModelAsNoLongerNeeded(object_model)
                        end
                        if Config.Debug then
                            print("barreira spawn")
                        end
                    end
                end
                if Config.BarrierList[i].status == "locked" then
                    DrawText3Ds(Config.BarrierList[i].objCoords.x, Config.BarrierList[i].objCoords.y, Config.BarrierList[i].objCoords.z+0.5, '[~r~E~s~] ~r~Locked~s~')
                elseif Config.BarrierList[i].status == "unlocked" then
                    DrawText3Ds(Config.BarrierList[i].objCoords.x, Config.BarrierList[i].objCoords.y, Config.BarrierList[i].objCoords.z+0.5, '[~r~E~s~] ~g~Unlocked~s~')
                end
            end
        end
	end
end)

-- ServerSync
local status = "locked"

RegisterCommand("update", function(source , args, rawCommand)
    if status == "locked" then
        status = "unlocked"
    elseif status == "unlocked" then
        status = "locked"
    end
    --print(status)
	TriggerServerEvent("mack_vehicles:update", status)
end)

RegisterNetEvent('mack_vehicles:update')
AddEventHandler('mack_vehicles:update', function(update)
    print(update)
end)

function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.4, 0.4)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextEntry("STRING")
    SetTextCentre(1)
    SetTextColour(255, 255, 255, 215)
    SetTextOutline()
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 270
    DrawRect(_x,_y + 0.015, 0.005 + factor, 0.03, 31, 31, 31, 155)
end

-- mack_vehicles
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(300)
        if IsPedInAnyVehicle(GetPlayerPed(-1)) then
            local ped = GetPlayerPed(-1)
            local vehicle = GetVehiclePedIsIn(ped, false)
            local posped = GetEntityCoords(ped)
            local vClass = GetVehicleClass(vehicle)
            local num = StartShapeTestCapsule(posped.x,posped.y,posped.z+4,posped.x,posped.y,posped.z-2.0, 2, 1, ped, 7)
            local arg1, arg2, arg3, arg4, arg5 = GetShapeTestResultEx(num)
            if Config.Debug then
                print("Ground hash: "..arg5)
                print("Debug:"..Config.Debug)
            end
            if vClass == 0 or vClass == 1 or vClass == 3 or vClass == 4 or vClass == 5 or vClass == 6 or vClass == 7 then
                if arg5 == 0 or arg5 == 282940568 or arg5 == 11879676648 or arg5 == 1187676648 or arg5 == -754997699 or arg5 == -365631240 or arg5 == 1886546517 or arg5 == -1447280105 or arg5 == -729112334 or arg5 == 951832588 or arg5 == 1639053622 or arg5 == -1301352528 or arg5 == -1084640111 or arg5 == 1907048430 or arg5 == 999829011 or arg5 == -1775485061 then
                    Wait(300)
                    if Config.Debug then
                        print("road")
                        SetVehicleColours(vehicle, 0, 0);
                    end
                    SetVehicleEnginePowerMultiplier(vehicle, 0.0)
                    --SetVehicleReduceGrip(vehicle, false)
                else
                    Wait(300)
                    if Config.Debug then
                        print("not road")
                        SetVehicleColours(vehicle, 27, 27);
                    end
                    SetVehicleEnginePowerMultiplier(vehicle, -50.0)
                    --SetVehicleReduceGrip(vehicle, true)
                end
            end
        end
	end
end)