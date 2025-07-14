local prevAppearance = nil

RegisterNetEvent('qbx_job_items:applyPoliceOutfit', function()
    Wait(500)

    local ped = PlayerPedId()
    prevAppearance = exports['illenium-appearance']:getPedAppearance(ped)

    if prevAppearance then
        print("[Client] Civilian appearance captured.")
    else
        print("[Client] Failed to capture civilian appearance.")
    end

    local success = exports['illenium-appearance']:setOutfit({
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
    })

    if success then
        lib.notify({
            title = "Uniform Applied",
            description = "Police clothing assigned.",
            type = "success"
        })
        print("[Client] Police uniform applied.")
    else
        lib.notify({
            title = "Uniform Failed",
            description = "Could not apply police outfit.",
            type = "error"
        })
        print("[Client] Failed to apply police uniform.")
    end
end)

-- 📦 Manual command to check what was saved
RegisterCommand("checkSavedAppearance", function()
    if prevAppearance then
        lib.notify({
            title = "Appearance Saved",
            description = "Civilian clothing data is available.",
            type = "info"
        })
        print("[Client] Civilian Appearance Structure:")
        print(json.encode(prevAppearance, { indent = true }))
    else
        lib.notify({
            title = "No Data",
            description = "No civilian outfit captured yet.",
            type = "error"
        })
        print("[Client] No civilian appearance available.")
    end
end, false)

RegisterNetEvent('player:setJob', function(jobData)
    local newJob = jobData.name
    local grade = jobData.grade

    if newJob == "unemployed" and grade == 0 and prevAppearance then
        exports['illenium-appearance']:setPlayerAppearance(prevAppearance)
        lib.notify({
            title = "Back to Civilian",
            description = "Restored saved clothing from earlier.",
            type = "info"
        })
        print("[Client] Civilian appearance restored.")
        print(json.encode(prevAppearance, { indent = true }))
    end
end)

