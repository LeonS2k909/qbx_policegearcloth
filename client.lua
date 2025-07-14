local currentJob = nil

local function storeCivilianAppearance()
    local ped = PlayerPedId()
    local appearance = exports['illenium-appearance']:getPedAppearance(ped)
    if appearance then
        TriggerServerEvent("qbx_policegearcloth:storeCivilianAppearance", appearance)
    end
end

RegisterNetEvent('qbx_job_items:applyPoliceOutfit', function()
    Wait(500)
    storeCivilianAppearance()

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

    lib.notify(success and {
        title = "Uniform Applied",
        description = "Police clothing assigned.",
        type = "success"
    } or {
        title = "Uniform Failed",
        description = "Could not apply police outfit.",
        type = "error"
    })
end)

RegisterNetEvent('player:setJob', function(jobData)
    local newJob = jobData.name
    local grade = jobData.grade

    if newJob == "unemployed" and grade == 0 and currentJob == "police" then
        lib.callback('qbx_policegearcloth:getCivilianAppearance', false, function(civilianAppearance)
            if civilianAppearance then
                exports['illenium-appearance']:setPlayerAppearance(civilianAppearance)
                lib.notify({ title = "Back to Civilian", description = "Restored your saved outfit.", type = "info" })
                print("[Client] Civilian outfit restored from server.")
                print(json.encode(civilianAppearance, { indent = true }))
            else
                lib.notify({ title = "Restore Failed", description = "No saved civilian clothing found.", type = "error" })
                print("[Client] Failed to fetch appearance.")
            end
        end)
    end

    currentJob = newJob
end)

RegisterCommand("restoreAppearance", function()
    lib.callback('qbx_policegearcloth:getCivilianAppearance', false, function(civilianAppearance)
        if civilianAppearance then
            exports['illenium-appearance']:setPlayerAppearance(civilianAppearance)
            lib.notify({ title = "Manual Restore", description = "Applied saved civilian outfit.", type = "info" })
            print("[Client] Manual restore executed.")
            print(json.encode(civilianAppearance, { indent = true }))
        else
            lib.notify({ title = "Restore Failed", description = "No saved civilian clothing found.", type = "error" })
            print("[Client] Manual restore failed – no data returned.")
        end
    end)
end, false)
