-- config.lua
Config = {}

-- Toggle debug prints
Config.DebugMode = true

-- Police job identifier
Config.PoliceJobName = "police"

-- Items to give on police duty
Config.PoliceItems = {
    { name = "handcuffs", count = 1 },
    { name = "radio",    count = 1 },
}

-- Outfit data for police
Config.PoliceOutfit = {
    outfitData = {
        pants     = { item = 25, texture = 0 },
        arms      = { item = 15, texture = 0 },
        ["t-shirt"]= { item = 2,  texture = 0 },
        torso2    = { item = 35, texture = 0 },
        shoes     = { item = 10, texture = 0 },
        hat       = { item = 5,  texture = 0 },
        glass     = { item = 0,  texture = 0 },
    }
}
