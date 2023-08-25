ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function (job)
    ESX.PlayerData.job = job
end)

local can = false
local options = {
    {
        name = 'diagnostic',
        icon = 'fas fa-clipboard',
        label = Lang.analyze,
        distance = 2.5,
        onSelect = function(data)

            if Config.OnlyJob then
                for k, v in pairs(Config.EnabledJobs) do
                    if ESX.PlayerData.job.name == v then
                        can = true
                        break
                    end
                end
                if not can then Config.Notify(Lang.noJob) return end
            end

            Diagnostic(data)
            lib.showMenu('diagnostic')
            can = false
        end
    },
    {
        name = 'repair',
        icon = 'fas fa-toolbox',
        label = Lang.repair,
        distance = 2.5,
        onSelect = function(data)

            if Config.OnlyJob then
                for k, v in pairs(Config.EnabledJobs) do
                    if ESX.PlayerData.job.name == v then
                        can = true
                        break
                    end
                end
                if not can then Config.Notify(Lang.noJob) return end
            end

            Repair(data)
            can = false
        end
    },
    {
        name = 'clean',
        icon = 'fas fa-hand-sparkles',
        label = Lang.clean,
        distance = 2.5,
        onSelect = function(data)

            if Config.OnlyJob then
                for k, v in pairs(Config.EnabledJobs) do
                    if ESX.PlayerData.job.name == v then
                        can = true
                        break
                    end
                end  
                if not can then Config.Notify(Lang.noJob) return end
            end

            Clean(data)
            can = false
        end
    },
    
}
exports.ox_target:addGlobalVehicle(options)

Diagnostic = function(data)
    lib.registerMenu({
        id = 'diagnostic',
        title = Lang.diagnostic,
        position = 'top-left',
        options = {
            {label = Lang.plate..GetVehicleNumberPlateText(data.entity), description = Lang.forCopy, icon = 'magnifying-glass', args = {copy = true, value = GetVehicleNumberPlateText(data.entity)}},
            {label = Lang.engine, icon = 'car', progress = GetVehicleEngineHealth(data.entity), colorScheme = '#006400'},
            {label = Lang.fuel, icon = 'gas-pump', progress = GetVehicleFuelLevel(data.entity), colorScheme = '#ff7f50'},
            {label = Lang.temperature, icon = 'temperature-three-quarters', progress = GetVehicleDirtLevel(data.entity), colorScheme = '#ff8c00'},
            {label = Lang.oil, icon = 'oil-can', progress = GetVehicleOilLevel(data.entity), colorScheme = '#808000'},
        }
    }, function(selected, scrollIndex, args)
        if args.copy then
            lib.setClipboard(string.gsub(args.value, "^%s*(.-)%s*$", "%1"))
            Config.Notify(Lang.copied)
        end
    end)
end

Repair = function(data)
    local ped = cache.ped
    local veh = data.entity

    local count = exports.ox_inventory:Search('count', Config.ItemRepair)
    if count < 1 then return Config.Notify(Lang.noRepairItem) end

    if IsPedArmed(ped, 6) then
        TriggerEvent('ox_inventory:disarm')
    end

    FreezeEntityPosition(ped, true)

    if lib.progressCircle({
        duration = 8000,
        position = 'bottom',
        label = Lang.repairing,
        useWhileDead = false,
        canCancel = false,
        disable = {
            car = true,
        },
        anim = {
            scenario = 'PROP_HUMAN_BUM_BIN',
        },
    }) then
        FreezeEntityPosition(ped, false)

        local time = 0
        NetworkRequestControlOfEntity(veh)
        while not NetworkHasControlOfEntity(veh) and time < 50 do
            Wait(100)
            time = time + 1
        end
        SetVehicleFixed(veh)
        SetVehicleDeformationFixed(veh)
        SetVehicleUndriveable(veh, false)
        SetVehicleEngineOn(veh, true, true)

        local num = 1
        TriggerServerEvent('data:svg', Config.ItemRepair, num)                  
    end
end

Clean = function(data)
    local ped = cache.ped
    local veh = data.entity

    if GetVehicleDirtLevel(veh) == 0 then return Config.Notify(Lang.alreadyClean) end

    local count = exports.ox_inventory:Search('count', Config.ItemCleaning)
    if count < 1 then return Config.Notify(Lang.noCleanItem) end

    if IsPedArmed(ped, 6) then
        TriggerEvent('ox_inventory:disarm')
    end

    FreezeEntityPosition(ped, true)

    if lib.progressCircle({
        duration = 15000,
        position = 'bottom',
        label = Lang.cleaning,
        useWhileDead = false,
        canCancel = false,
        disable = {
            car = true,
        },
        anim = {
            dict = 'amb@world_human_maid_clean@',
            clip = 'base'
        },
        prop = {
            model = `prop_sponge_01`,
            bone = 28422,
            pos = vec3(0.0, 0.0, -0.01),
            rot = vec3(90.0, 0.0, 0.0)
        },
    }) then
        FreezeEntityPosition(ped, false)

        NetworkRequestControlOfEntity(veh)
        while not NetworkHasControlOfEntity(veh) do
            Wait(1000)
        end
        
        SetVehicleDirtLevel(veh, 0)

        local num = 1
        TriggerServerEvent('data:svg', Config.ItemCleaning, num)
    end
end

