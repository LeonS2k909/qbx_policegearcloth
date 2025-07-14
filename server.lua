local civilianOutfits = {}

local civilianOutfits = {} -- This should already be at the top

RegisterServerEvent("qbx_policegearcloth:storeCivilianAppearance")
AddEventHandler("qbx_policegearcloth:storeCivilianAppearance", function(appearance)
    local src = source
    civilianOutfits[src] = appearance

    -- Send a client notification + debug info
    TriggerClientEvent("qbx_policegearcloth:debugSavedAppearance", src, appearance)
end)


local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('QBCore:Server:OnJobUpdate', function(source, newJob, oldJob)
    if not source or not newJob then return end

    if newJob.name == 'police' then
        local items = {
            { name = 'WEAPON_STUNGUN', count = 1 },
            { name = 'radio',          count = 1 },
            { name = 'WEAPON_APPISTOL', count = 1 },
            { name = 'ammo-9', count = 1000 },
            { name = 'handcuffs',      count = 1 }
        }

        for _, item in ipairs(items) do
            local hasItem = exports.ox_inventory:Search(source, 'slots', item.name)

            if not hasItem or #hasItem == 0 then
                local success, response = exports.ox_inventory:AddItem(source, item.name, item.count)
                if not success then
                    print(('[qbx_job_items] Failed to give %s: %s'):format(item.name, response))
                else
                    print(('[qbx_job_items] Gave %s x%d to %d'):format(item.name, item.count, source))
                end
            else
                print(('[qbx_job_items] Player %d already has %s'):format(source, item.name))
            end
        end

        TriggerClientEvent('qbx_job_items:applyPoliceOutfit', source)
    end
end)

lib.callback.register('qbx_policegearcloth:getCivilianAppearance', function(source)
    return civilianOutfits[source]
end)

