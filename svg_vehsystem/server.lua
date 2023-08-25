ESX = exports["es_extended"]:getSharedObject()
local ox = exports.ox_inventory

RegisterServerEvent('data:svg', function(obj, count)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if Config.OnlyJob then
        for k, v in pairs(Config.EnabledJobs) do
            if xPlayer.job.name ~= v then
                return print('cheater')
            end
        end
    end

    ox:RemoveItem(src, obj, count)
end)