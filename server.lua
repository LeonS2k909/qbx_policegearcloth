local function DebugPrint(...)
    if Config.DebugMode then
        print('[qbx_policegearcloth]', ...)
    end
end

-- Event to handle police gear assignment
RegisterNetEvent('qbx_policegearcloth:server:GivePoliceGear', function(source))
    DebugPrint('Giving police gear to:', source)
    
    for _, item in ipairs(Config.PoliceItems) do
        local itemCount = exports.ox_inventory:Search(source, 'count', item.name)
        
        if not itemCount or itemCount == 0 then
            local success = exports.ox_inventory:AddItem(source, item.name, item.count)
            DebugPrint(success and ('Gave %s x%d'):format(item.name, item.count) or 
                        ('Failed to give %s'):format(item.name))
        else
            DebugPrint(('Player already has %s (count: %d)'):format(item.name, itemCount))
        end
    end
end

-- Handle job changes
RegisterNetEvent('QBCore:Server:OnJobUpdate', function(source, newJob, oldJob)
    if not source or newJob.name ~= Config.PoliceJobName then return end
    DebugPrint(('Player %s became police'):format(source))

    -- 1. Save civilian clothes
    TriggerClientEvent('qbx_policegearcloth:client:SaveCivilianAppearance', source)
    
    -- 2. Apply police outfit
    Citizen.SetTimeout(1000, function()
        DebugPrint('Applying police outfit for:', source)
        TriggerClientEvent('qbx_policegearcloth:client:ApplyPoliceOutfit', source)
        
        -- 3. Give police items
        Citizen.SetTimeout(500, function()
            TriggerEvent('qbx_policegearcloth:server:GivePoliceGear', source)
        end)
    end)
end)

-- Debug command to trigger police outfit
RegisterCommand('forcepoliceoutfit', function(source)
    if source == 0 then return end
    DebugPrint('Forcing police outfit for:', source)
    TriggerClientEvent('qbx_policegearcloth:client:ApplyPoliceOutfit', source)
end, true)