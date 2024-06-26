local Config = Config or {}

if Config.Framework == "QBCore" then
    QBCore = exports['qb-core']:GetCoreObject()
elseif Config.Framework == "ESX" then
    ESX = nil
    Citizen.CreateThread(function()
        while ESX == nil do
            TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
            Citizen.Wait(0)
        end
    end)
end

function Notify(msg, type)
    if Config.Framework == "QBCore" then
        QBCore.Functions.Notify(msg, type)
    elseif Config.Framework == "ESX" then
        ESX.ShowNotification(msg)
    end
end

function openCategoryMenu()
    local options = {}

    for category, _ in pairs(Config.Categories) do
        table.insert(options, {
            title = category,
            icon = 'fas fa-car',
            event = 'kuban_jobgarage:openVehicleMenu',
            args = { category = category }
        })
    end

    lib.registerContext({
        id = 'category_menu',
        title = Config.CategoryTitle,
        options = options
    })

    lib.showContext('category_menu')
end

RegisterNetEvent('kuban_jobgarage:openVehicleMenu')
AddEventHandler('kuban_jobgarage:openVehicleMenu', function(data)
    local category = data.category
    local options = {}

    for _, vehicle in pairs(Config.Categories[category]) do
        table.insert(options, {
            title = vehicle.name,
            icon = 'fas fa-car-side',
            event = 'kuban_jobgarage:spawnVehicle',
            args = { model = vehicle.model }
        })
    end

    lib.registerContext({
        id = 'vehicle_menu',
        title = 'Select Vehicle',
        options = options
    })

    lib.showContext('vehicle_menu')
end)

RegisterNetEvent('kuban_jobgarage:spawnVehicle')
AddEventHandler('kuban_jobgarage:spawnVehicle', function(data)
    local model = data.model
    local playerJob = nil
    local spawnPoint = nil

    if Config.Framework == "QBCore" then
        playerJob = QBCore.Functions.GetPlayerData().job.name
    elseif Config.Framework == "ESX" then
        playerJob = ESX.GetPlayerData().job.name
    end

    for _, garage in pairs(Config.Garages) do
        if playerJob == garage.job then
            spawnPoint = Config.SpawnPoint
            break
        end
    end

    if Config.Framework == "QBCore" then
        QBCore.Functions.SpawnVehicle(model, function(vehicle)
            setupVehicle(vehicle, spawnPoint)
        end, spawnPoint.coords, true)
    elseif Config.Framework == "ESX" then
        ESX.Game.SpawnVehicle(model, spawnPoint.coords, spawnPoint.heading, function(vehicle)
            setupVehicle(vehicle, spawnPoint)
        end)
    end
end)

function setupVehicle(vehicle, spawnPoint)
    local randomNumber = math.random(1000, 9999)
    local plate = Config.Plate..randomNumber
    SetVehicleNumberPlateText(vehicle, plate)
    SetEntityCoords(vehicle, spawnPoint.coords.x, spawnPoint.coords.y, spawnPoint.coords.z, 0.0, 0.0, 0.0, false)
    SetEntityHeading(vehicle, spawnPoint.heading)
    SetVehicleDoorsLocked(vehicle, 2)
    if Config.SpawnInVehicle then
        TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
        Notify('Vehicle spawned successfully.', 'success')
    end
end

function openCustomizationMenu()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    if vehicle == 0 then
        Notify('You must be in a vehicle to customize it.', 'error')
        return
    end

    local options = {
        { title = 'Repair', icon = Config.RepairIcon, event = 'kuban_jobgarage:repairVehicle' },
        { title = 'Livery', icon = Config.LiveryIcon, event = 'kuban_jobgarage:customizeVehicleLivery' },
        { title = 'Extras', icon = Config.ExtraIcon, event = 'kuban_jobgarage:customizeVehicleExtras' },
        { title = 'Color', icon = Config.ColorIcon, event = 'kuban_jobgarage:customizeVehicleColor' },
        { title = 'Plate', icon = Config.PlateIcon, event = 'kuban_jobgarage:customizeVehiclePlate' }
    }

    lib.registerContext({
        id = 'customization_menu',
        title = 'Customize Vehicle',
        options = options
    })

    lib.showContext('customization_menu')
end

RegisterNetEvent('kuban_jobgarage:repairVehicle')
AddEventHandler('kuban_jobgarage:repairVehicle', function()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    
    if vehicle ~= 0 then
        local doorIndex = 4 
        SetVehicleDoorOpen(vehicle, doorIndex, false, false)
        QBCore.Functions.Progressbar("repair_vehicle", Config.ProgressBarText, Config.Timetorepair, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done
            SetVehicleFixed(vehicle)
            SetVehicleDirtLevel(vehicle, 0)
            Notify(Config.RepairSuccess, 'success')
        end)
    else
        Notify(Config.NotInVehicle, 'error')
    end
end)


RegisterNetEvent('kuban_jobgarage:customizeVehicleLivery')
AddEventHandler('kuban_jobgarage:customizeVehicleLivery', function()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    local liveryCount = GetVehicleLiveryCount(vehicle)
    local currentLivery = GetVehicleLivery(vehicle)
    local options = {}

    if liveryCount > 0 then
        for i = 0, liveryCount - 1 do
            table.insert(options, {
                title = 'Livery ' .. i,
                icon = currentLivery == i and 'fas fa-check' or 'fas fa-times',
                iconColor = currentLivery == i and 'green' or 'red',
                event = 'kuban_jobgarage:setVehicleLivery',
                args = { livery = i, reopen = true }
            })
        end
    else
        table.insert(options, {
            title = 'No Liveries',
            disabled = true
        })
    end

    lib.registerContext({
        id = 'livery_menu',
        title = 'Select Livery',
        options = options
    })

    lib.showContext('livery_menu')
end)

RegisterNetEvent('kuban_jobgarage:setVehicleLivery')
AddEventHandler('kuban_jobgarage:setVehicleLivery', function(data)
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    SetVehicleLivery(vehicle, data.livery)
    if data.reopen then
        TriggerEvent('kuban_jobgarage:customizeVehicleLivery')
    end
end)

RegisterNetEvent('kuban_jobgarage:customizeVehicleExtras')
AddEventHandler('kuban_jobgarage:customizeVehicleExtras', function()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    local options = {}
    local hasExtras = false

    for i = 0, 20 do
        if DoesExtraExist(vehicle, i) then
            hasExtras = true
            local label = 'Extra ' .. i
            local state = IsVehicleExtraTurnedOn(vehicle, i)
            local stateLabel = state and 'Disable' or 'Enable'
            table.insert(options, {
                title = label .. ' (' .. stateLabel .. ')',
                icon = state and 'fas fa-check' or 'fas fa-times',
                iconColor = state and 'green' or 'red',
                event = 'kuban_jobgarage:setVehicleExtra',
                args = { extra = i, state = not state, reopen = true }
            })
        end
    end

    if not hasExtras then
        table.insert(options, {
            title = 'No Extras',
            disabled = true
        })
    end

    lib.registerContext({
        id = 'extras_menu',
        title = 'Customize Extras',
        options = options
    })

    lib.showContext('extras_menu')
end)

RegisterNetEvent('kuban_jobgarage:setVehicleExtra')
AddEventHandler('kuban_jobgarage:setVehicleExtra', function(data)
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    SetVehicleExtra(vehicle, data.extra, data.state and 0 or 1)
    if data.reopen then
        TriggerEvent('kuban_jobgarage:customizeVehicleExtras')
    end
end)

RegisterNetEvent('kuban_jobgarage:customizeVehicleColor')
AddEventHandler('kuban_jobgarage:customizeVehicleColor', function()
    local input = lib.inputDialog('Enter Vehicle Colors', {
        { type = 'color', label = 'Primary Color' },
        { type = 'color', label = 'Secondary Color' }
    })

    if input then
        local primaryColor = input[1]
        local secondaryColor = input[2]
        local playerPed = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(playerPed, false)

        SetVehicleCustomPrimaryColour(vehicle, tonumber(primaryColor:sub(2, 3), 16), tonumber(primaryColor:sub(4, 5), 16), tonumber(primaryColor:sub(6, 7), 16))
        SetVehicleCustomSecondaryColour(vehicle, tonumber(secondaryColor:sub(2, 3), 16), tonumber(secondaryColor:sub(4, 5), 16), tonumber(secondaryColor:sub(6, 7), 16))
    end
end)

RegisterNetEvent('kuban_jobgarage:customizeVehiclePlate')
AddEventHandler('kuban_jobgarage:customizeVehiclePlate', function()
    local input = lib.inputDialog('Enter New Plate', {
        { type = 'input', label = 'New Plate', placeholder = 'Enter new plate number' }
    })

    if input then
        local newPlate = input[1]
        local playerPed = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(playerPed, false)

        SetVehicleNumberPlateText(vehicle, newPlate)
        Notify('Plate changed successfully.', 'success')
    end
end)

function deleteVehicle()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    if vehicle == 0 then
        Notify('You must be in a vehicle to store it.', 'error')
        return
    end
    local seat = GetSeatPedIsTryingToEnter(playerPed)
    if seat == -1 then
        Notify('You must be inside a vehicle to store it.', 'error')
        return
    end
    local door = Config.DoorIndex or 0
    SetVehicleDoorOpen(vehicle, door, false, false)
    TaskLeaveVehicle(playerPed, vehicle, 0)
    while IsPedInAnyVehicle(playerPed, false) do
        Citizen.Wait(0)
    end
    if Config.Framework == "QBCore" then
        QBCore.Functions.DeleteVehicle(vehicle)
    elseif Config.Framework == "ESX" then
        ESX.Game.DeleteVehicle(vehicle)
    end

    Notify('Vehicle stored successfully.', 'success')
    PlaySoundFrontend(-1, "CONFIRM_BEEP", "HUD_MINI_GAME_SOUNDSET", 1)
end



Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local playerJob = nil

         if Config.Framework == "QBCore" then
            local playerData = QBCore.Functions.GetPlayerData()
            if playerData and playerData.job then
                playerJob = playerData.job.name
            end
        elseif Config.Framework == "ESX" then
            local playerData = ESX.GetPlayerData()
            if playerData and playerData.job then
                playerJob = playerData.job.name
            end
        end

        for _, garage in pairs(Config.Garages) do
            if playerJob == garage.job then
                for _, location in pairs(garage.Locations) do
                    local distance = #(playerCoords - location.coords)
                    if distance < Config.TextDrawDistance then
                        DrawMarker(Config.CarDrawMarker, location.coords.x, location.coords.y, location.coords.z - 0.97, 0.0, 0.0, 0.0, 0.0, 0, 0.0, 2.0, 2.0, 2.2, 0, 128, 0, 70, false, true, 2, false, false, false, false)
                        if Config.Framework == "QBCore" then
                            QBCore.Functions.DrawText3D(location.coords.x, location.coords.y, location.coords.z, Config.CarTextUI)
                        elseif Config.Framework == "ESX" then
                            ESX.Game.Utils.DrawText3D(location.coords, Config.CarTextUI)
                        end
                        if IsControlJustReleased(0, Config.InteractKey) then
                            openCategoryMenu()
                        end
                    end

                end

                local customizationDistance = #(playerCoords - garage.CustomizationPoint.coords)
                local playerVeh = GetVehiclePedIsIn(playerPed, false)
                if playerVeh ~= 0 and customizationDistance < Config.TextDrawDistance then
                    DrawMarker(Config.CustomDrawMarker, garage.CustomizationPoint.coords.x, garage.CustomizationPoint.coords.y, garage.CustomizationPoint.coords.z - 0.97, 0.0, 0.0, 0.0, 0.0, 0, 0.0, 2.0, 2.0, 2.2, 0, 0, 255, 70, false, true, 2, nil, nil, false)
                    if Config.Framework == "QBCore" then
                        QBCore.Functions.DrawText3D(garage.CustomizationPoint.coords.x, garage.CustomizationPoint.coords.y, garage.CustomizationPoint.coords.z, Config.CustomTextUI)
                    elseif Config.Framework == "ESX" then
                        ESX.Game.Utils.DrawText3D(garage.CustomizationPoint.coords, Config.CustomTextUI)
                    end
                    if IsControlJustReleased(0, Config.InteractKey) then
                        openCustomizationMenu()
                    end
                end

                local deleteDistance = #(playerCoords - garage.DeletePoint.coords)
                if playerVeh ~= 0 and deleteDistance < Config.TextDrawDistance then
                    DrawMarker(Config.DeleteDrawMarker, garage.DeletePoint.coords.x, garage.DeletePoint.coords.y, garage.DeletePoint.coords.z - 0.97, 0.0, 0.0, 0.0, 0.0, 0, 0.0, 2.0, 2.0, 2.2, 255, 0, 0, 100, false, true, 2, nil, nil, false)
                    if Config.Framework == "QBCore" then
                        QBCore.Functions.DrawText3D(garage.DeletePoint.coords.x, garage.DeletePoint.coords.y, garage.DeletePoint.coords.z, Config.DeleteTextUI)
                    elseif Config.Framework == "ESX" then
                        ESX.Game.Utils.DrawText3D(garage.DeletePoint.coords, Config.DeleteTextUI)
                    end
                    if IsControlJustReleased(0, Config.InteractKey) then
                        deleteVehicle()
                    end
                end
            end
        end
    end
end)
