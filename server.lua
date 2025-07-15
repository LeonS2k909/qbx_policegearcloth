-- server.lua
-- QBX Police Gear Cloth – Server Side

-- Debug helper
local function DebugPrint(...)
    if Config.DebugMode then
        print('[qbx_policegearcloth]', ...)
    end
end

-- Give police items
RegisterNetEvent('qbx_policegearcloth:server:GivePoliceGear')
AddEventHandler('qbx_policegearcloth:server:GivePoliceGear', function(source)
    DebugPrint('GivePoliceGear to:', source)
    for _, item in ipairs(Config.PoliceItems) do
        local count = exports.ox_inventory:Search(source, 'count', item.name)
        if not count or count == 0 then
            exports.ox_inventory:AddItem(source, item.name, item.count)
            DebugPrint('Added', item.name, 'x'..item.count)
        end
    end
end)

-- Handle job updates (police join & leave)
RegisterNetEvent('QBCore:Server:OnJobUpdate')
AddEventHandler('QBCore:Server:OnJobUpdate', function(source, newJob, oldJob)
    if not source then return end

    -- Joined police
    if newJob.name == Config.PoliceJobName then
        DebugPrint('Player', source, 'became police')
        TriggerClientEvent('qbx_policegearcloth:client:SaveCivilianAppearance', source)

        Citizen.SetTimeout(800, function()
            TriggerClientEvent('qbx_policegearcloth:client:ApplyPoliceOutfit', source)
            Citizen.SetTimeout(400, function()
                TriggerEvent('qbx_policegearcloth:server:GivePoliceGear', source)
            end)
        end)
    end

    -- Left police (goes to unemployed or another job)
    if oldJob.name == Config.PoliceJobName then
        DebugPrint('Player', source, 'left police')
        Citizen.SetTimeout(800, function()
            TriggerClientEvent('qbx_policegearcloth:client:RestoreCivilianAppearance', source)
        end)
    end
end)

-- Debug command
RegisterCommand('forcepoliceoutfit', function(source)
    if source == 0 then return end
    TriggerClientEvent('qbx_policegearcloth:client:ApplyPoliceOutfit', source)
end, true)
