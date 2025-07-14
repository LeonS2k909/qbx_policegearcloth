local prevAppearance = nil
local currentJob = nil

-- Your outfit data remains unchanged
local policeOutfit = {
    pants = { item = 24, texture = 0 },
    arms = { item = 20, texture = 0 },
    ["t-shirt"] = { item = 58, texture = 0 },
    vest = { item = 0, texture = 0 },
    torso2 = { item = 317, texture = 0 },
    shoes = { item = 51, texture = 0 },
    accessory = { item = 0, texture = 0 },
    bag = { item = 0, texture = 0 },
    hat = { item = -1, texture = -1 },
    glass = { item = 0, texture = 0 },
    mask = { item = 0, texture = 0 }
}

RegisterNetEvent('qbx_job_items:applyPoliceOutfit', function()
    Wait(500)
    local ped = PlayerPedId()
    prevAppearance = exports['illenium-appearance']:getPedAppearance(ped)

    local success = exports['illenium-appearance']:setOutfit(policeOutfit)
    if success then
        lib.notify({ title = "Uniform Applied", description = "Police clothing assigned.", type = "success" })
    else
        lib.notify({ title = "Uniform Failed", description = "Could not apply police outfit. Check illenium-appearance setup.", type = "error" })
    end
end)

RegisterNetEvent('player:setJob', function(jobData)
    local newJob = jobData.name
    local grade = jobData.grade

    -- Restore appearance BEFORE updating currentJob
    if newJob == "unemployed" and grade == 0 and currentJob == "police" then
        if prevAppearance then
            exports['illenium-appearance']:setPlayerAppearance(prevAppearance)
            lib.notify({ title = "Back to Civilian", description = "Restored your previous outfit.", type = "info" })
        else
            lib.notify({ title = "Outfit Not Saved", description = "No civilian clothing stored to restore.", type = "error" })
        end
    end

    currentJob = newJob
end)

RegisterNetEvent("qbx_policegearcloth:debugSavedAppearance", function(savedAppearance)
    if savedAppearance then
        lib.notify({
            title = "Civilian Clothing Saved",
            description = "Previous outfit has been stored.",
            type = "success"
        })

        -- Output the actual saved appearance to your client console
        print("[qbx_policegearcloth] Saved Appearance:")
        print(json.encode(savedAppearance, { indent = true }))
    else
        lib.notify({
            title = "Save Failed",
            description = "Appearance data was not captured.",
            type = "error"
        })
    end
end)