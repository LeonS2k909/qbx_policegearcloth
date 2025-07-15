-- client.lua
-- QBX Police Gear Cloth – Client Side

-- Debug helper
local function DebugPrint(...)
    if Config and Config.DebugMode then
        print('[qbx_policegearcloth]', ...)
    end
end

-- State
local savedCivilianAppearance = nil
local isApplyingOutfit        = false

-- Component mapping
local COMPONENT_IDS = {
    mask      = 1,  arms      = 3,  pants     = 4,
    bag       = 5,  shoes     = 6,  accessory = 7,
    ["t-shirt"]= 8,  vest      = 9,  torso2    = 11,
    hat       = 0,  glass     = 1,
}

-- 1. Save civilian look
RegisterNetEvent('qbx_policegearcloth:client:SaveCivilianAppearance', function()
    local ped = PlayerPedId()
    savedCivilianAppearance = exports['illenium-appearance']:getPedAppearance(ped)
    DebugPrint(savedCivilianAppearance and 'Civilian clothes saved' or 'Save failed')
end)

-- 2. Restore civilian look
RegisterNetEvent('qbx_policegearcloth:client:RestoreCivilianAppearance', function()
    if not savedCivilianAppearance then
        DebugPrint('No saved appearance to restore')
        return
    end

    DebugPrint('Restoring civilian appearance')
    exports['illenium-appearance']:setPlayerAppearance(savedCivilianAppearance)
    lib.notify({
        title       = "Clothes Restored",
        description = "You are back in your civilian outfit",
        type        = "success",
        duration    = 4000
    })
end)

-- 3. Apply police outfit
RegisterNetEvent('qbx_policegearcloth:client:ApplyPoliceOutfit', function()
    if isApplyingOutfit then return end
    isApplyingOutfit = true

    DebugPrint('Starting police outfit')
    local ped    = PlayerPedId()
    local outfit = Config.PoliceOutfit and Config.PoliceOutfit.outfitData

    if not outfit then
        DebugPrint('Missing Config.PoliceOutfit.outfitData')
        lib.notify({ title="Uniform Failed", description="No police outfit set", type="error", duration=4000 })
        isApplyingOutfit = false
        return
    end

    local success = false

    -- Method A: Illenium-Appearance
    if exports['illenium-appearance'] then
        local ok, res = pcall(exports['illenium-appearance'].setOutfit, exports['illenium-appearance'], outfit)
        if ok and res then
            success = true
            DebugPrint('setOutfit succeeded')
        else
            DebugPrint('setOutfit failed:', res)
        end
    end

    -- Method B: Manual apply
    if not success then
        DebugPrint('Manual apply begin')
        local count = 0
        for comp, data in pairs(outfit) do
            local id = COMPONENT_IDS[comp]
            if id and data.item and data.texture then
                if comp == "hat" or comp == "glass" then
                    SetPedPropIndex(ped, id, data.item, data.texture, true)
                else
                    SetPedComponentVariation(ped, id, data.item, data.texture, 0)
                end
                count = count + 1
                DebugPrint('Applied', comp, data.item, data.texture)
                Citizen.Wait(50)
            end
        end
        success = count > 0
        DebugPrint('Manual components applied:', count)
    end

    -- Method C: Force fallback
    if not success then
        DebugPrint('Force fallback components')
        for _, comp in ipairs({ "pants","arms","t-shirt","torso2","shoes","hat" }) do
            local data = outfit[comp]
            local id   = COMPONENT_IDS[comp]
            if id and data then
                if comp == "hat" then
                    SetPedPropIndex(ped, id, data.item, data.texture, true)
                else
                    SetPedComponentVariation(ped, id, data.item, data.texture, 0)
                end
                Citizen.Wait(50)
            end
        end
        success = true
    end

    -- Notify result
    if success then
        DebugPrint('Police outfit applied')
        lib.notify({ title="Uniform Applied", description="Police uniform equipped", type="success", duration=4000 })
    else
        DebugPrint('All methods failed')
        lib.notify({ title="Uniform Failed", description="Could not equip police uniform", type="error", duration=4000 })
    end

    isApplyingOutfit = false
end)

-- 4. Test command
RegisterCommand('testpoliceoutfit', function()
    TriggerEvent('qbx_policegearcloth:client:ApplyPoliceOutfit')
end)
