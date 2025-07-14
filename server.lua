local civilianOutfits = {}

RegisterServerEvent("qbx_policegearcloth:storeCivilianAppearance")
AddEventHandler("qbx_policegearcloth:storeCivilianAppearance", function(appearance)
    local src = source
    civilianOutfits[src] = appearance

    print("[Server] Civilian appearance saved for player " .. src)
    print(json.encode(appearance, { indent = true }))
end)

lib.callback.register('qbx_policegearcloth:getCivilianAppearance', function(source)
    local data = civilianOutfits[source]
    if data then
        print("[Server] Returning civilian appearance for " .. source)
        print(json.encode(data, { indent = true }))
    else
        print("[Server] No appearance found for " .. source)
    end
    return data
end)
