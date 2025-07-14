local prevAppearance = nil

RegisterNetEvent('qbx_job_items:applyPoliceOutfit', function()
    Wait(500)

    -- Save current civilian appearance before applying uniform
    local ped = PlayerPedId()
    prevAppearance = exports['illenium-appearance']:getPedAppearance(ped)

    if prevAppearance then
        print("[Client] Civilian appearance saved.")
    else
        print("[Client] Failed to capture civilian appearance.")
    end

    -- Apply police uniform
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
        print("[Client] Police outfit applied.")
    else
        lib.notify({
            title = "Uniform Failed",
            description = "Could not apply police outfit.",
            type = "error"
        })
        print("[Client] Outfit application failed.")
    end
end)
