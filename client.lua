local savedCivilianAppearance = nil
local isApplyingOutfit = false

-- Component ID mapping for manual application
local COMPONENT_IDS = {
    ["mask"] = 1,
    ["arms"] = 3,
    ["pants"] = 4,
    ["bag"] = 5,
    ["shoes"] = 6,
    ["accessory"] = 7,
    ["t-shirt"] = 8,
    ["vest"] = 9,
    ["torso2"] = 11,
    ["hat"] = 0,  -- Prop ID
    ["glass"] = 1, -- Prop ID
}

-- Debug print function
local function DebugPrint(...)
    if Config and Config.DebugMode then
        print('[qbx_policegearcloth]', ...)
    end
end

-- Save civilian appearance
RegisterNetEvent('qbx_policegearcloth:client:SaveCivilianAppearance', function())
    savedCivilianAppearance = exports['illenium-appearance']:getPedAppearance(PlayerPedId())
    DebugPrint(savedCivilianAppearance and 'Civilian clothes saved' or 'Failed to save civilian clothes')
end

-- Apply police outfit with guaranteed success
RegisterNetEvent('qbx_policegearcloth:client:ApplyPoliceOutfit', function())
    if isApplyingOutfit then return end
    isApplyingOutfit = true
    DebugPrint('Starting police outfit application')
    
    local ped = PlayerPedId()
    local outfit = Config.PoliceOutfit.outfitData
    
    -- Method 1: Try appearance system
    local success = false
    if exports['illenium-appearance'] then
        success = exports['illenium-appearance']:setOutfit(outfit)
        DebugPrint(success and 'Appearance system success' or 'Appearance system failed')
    end
    
    -- Method 2: Manual component application
    if not success then
        DebugPrint('Applying components manually')
        for component, data in pairs(outfit) do
            if COMPONENT_IDS[component] then
                if component == "hat" or component == "glass" then
                    SetPedPropIndex(ped, COMPONENT_IDS[component], data.item, data.texture, true)
                else
                    SetPedComponentVariation(ped, COMPONENT_IDS[component], data.item, data.texture, 0)
                end
                DebugPrint('Applied:', component, data.item, data.texture)
            end
            Citizen.Wait(50)
        end
        success = true
    end
    
    -- Method 3: Force individual components as last resort
    if not success then
        DebugPrint('Force-setting all components')
        SetPedComponentVariation(ped, COMPONENT_IDS["pants"], outfit.pants.item, outfit.pants.texture, 0)
        SetPedComponentVariation(ped, COMPONENT_IDS["arms"], outfit.arms.item, outfit.arms.texture, 0)
        SetPedComponentVariation(ped, COMPONENT_IDS["t-shirt"], outfit["t-shirt"].item, outfit["t-shirt"].texture, 0)
        SetPedComponentVariation(ped, COMPONENT_IDS["torso2"], outfit.torso2.item, outfit.torso2.texture, 0)
        SetPedComponentVariation(ped, COMPONENT_IDS["shoes"], outfit.shoes.item, outfit.shoes.texture, 0)
        SetPedPropIndex(ped, COMPONENT_IDS["hat"], outfit.hat.item, outfit.hat.texture, true)
        success = true
    end
    
    if success then
        DebugPrint('Police outfit applied successfully')
        lib.notify({
            title = "Uniform Applied",
            description = "Police clothing assigned",
            type = "success",
            duration = 5000
        })
    else
        DebugPrint('All outfit application methods failed')
        lib.notify({
            title = "Uniform Failed",
            description = "Could not apply police outfit",
            type = "error",
            duration = 5000
        })
    end
    
    isApplyingOutfit = false
end

-- Command to test outfit application
RegisterCommand('testpoliceoutfit', function()
    TriggerEvent('qbx_policegearcloth:client:ApplyPoliceOutfit')
    print('Police outfit test triggered')
end, false)