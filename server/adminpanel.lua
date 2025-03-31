local inAduty = {}
local inNoclip = {}
ESX.RegisterServerCallback('ms:getGroup', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        cb({group=xPlayer.getGroup(), serverName=GetConvar('sv_hostname', 'not Loaded')})
    else
        cb(nil)
    end
end)

RegisterServerEvent("adminmenu:cleanArea:server")
AddEventHandler("adminmenu:cleanArea:server", function(typee)
    TriggerClientEvent("adminmenu:cleanArea:client", -1, typee)
end)

Citizen.CreateThread(function()
    while true do
        local players = {}

        for _, playerId in ipairs(GetPlayers()) do
            local name = GetPlayerName(playerId)
            local ped = GetPlayerPed(playerId)

            if DoesEntityExist(ped) then
                local pedCoords = GetEntityCoords(ped)
                local health = GetEntityHealth(ped)
                local armor = GetPedArmour(ped)
                local xPlayer = ESX.GetPlayerFromId(playerId)

                local group = "user"
                local job = "Arbeitslos (0)"
                if xPlayer then
                    group = xPlayer.getGroup()
                    job = xPlayer.getJob().label .. " (" .. xPlayer.getJob().grade .. ")"
                end
                table.insert(players, {
                    id = playerId,
                    username = name,
                    distance = pedCoords,
                    health = health,
                    job = job,
                    inAduty = inAduty[tonumber(playerId)],
                    inNoclip = inNoclip[tonumber(playerId)],
                    armor = armor,
                    group = group
                })
            end
        end

        TriggerClientEvent("sendPlayersList", -1, players)
        Wait(1000 * ADMINPANEL.RefreshTime)
    end
end)


TESTEAADASDATTSD
local freezedPlayers = {}

RegisterServerEvent("adminpanel:player:send:action:server")
AddEventHandler("adminpanel:player:send:action:server", function(action, playerId)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(playerId)

    if not revolution: hasPermissions(xPlayer.group, action) then
        SV_Notify(xPlayer.source, 'error',  "Du hast keine Rechte für diese Aktion!", 5000)
        return
    end
    if xTarget then
        if action == "revive" then
            revivePlayer(xTarget.source);
            SV_Notify(xPlayer.source, 'success',  "Du hast " .. GetPlayerName(playerId) .. " Wiederbelebt!", 5000)
            SV_Notify(xTarget.source, 'success',  "Du wurdest von einem Admin Wiederbelebt!", 5000)
        elseif action == "goto" then
            local TargetPed = GetPlayerPed(xTarget.source)
            local TargetCoords = GetEntityCoords(TargetPed)
            local TargetDimension = GetEntityRoutingBucket(TargetPed)
            SetPlayerRoutingBucket(xPlayer.source, TargetDimension)
            SV_Notify(xPlayer.source, 'success', "Du hast dich zu "..xTarget.name.." Teleportiert", 5000)
            SetEntityCoords(GetPlayerPed(xPlayer.source), vector3(TargetCoords.x, TargetCoords.y, TargetCoords.z))
        elseif action == "bring" then
            local PlayerPed = GetPlayerPed(xPlayer.source)
            local PlayerCoords = GetEntityCoords(PlayerPed)
            local PlayerDimension = GetEntityRoutingBucket(PlayerPed)
            SetPlayerRoutingBucket(xTarget.source, PlayerDimension)

            SV_Notify(xPlayer.source, 'success', "Du hast "..xTarget.name.." zu dir Teleportiert", 5000)
            SetEntityCoords(GetPlayerPed(xTarget.source), vector3(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z))
        elseif action == "freeze" then
            if freezedPlayers[xTarget.source] then
                freezedPlayers[xTarget.source] = nil
                TriggerClientEvent("revolution: freeze", xTarget.source, false)
                SV_Notify(xPlayer.source, 'warning',  "entfreezed!", 5000)
            else
                freezedPlayers[xTarget.source] = true
                TriggerClientEvent("revolution: freeze", xTarget.source, true)
                SV_Notify(xPlayer.source, 'warning',  "entfreezed!", 5000)
            end
        elseif action == "charreset" then
            SV_Notify(xPlayer.source, 'success',  "Char gereset!", 5000)
            DropPlayer(xTarget.source, "Dein Char wurde zurückgesetzt! :(")
            MySQL.Async.execute('DELETE FROM users WHERE identifier = @identifier', {['@identifier'] = xTarget.getIdentifier()}, function(result) end)
        elseif action == "skinchanger" then
            SV_Notify(xPlayer.source, 'success',  "Skinmenü geöffnet!", 5000)
            openSkinMenu(xTarget.source)
        elseif action == "support" then
            SV_Notify(xTarget.source, 'error',  "Du wurdest in den Support gerufen!", 20000)
            SV_Notify(xTarget.source, 'error',  "Du wurdest in den Support gerufen!", 20000)
            freezedPlayers[xTarget.source] = true
            TriggerClientEvent("revolution: freeze", xTarget.source, true)
            SV_Notify(xPlayer.source, 'success',  "Supportcall gestartet!", 5000)
            Wait(60000 * 5)
            freezedPlayers[xTarget.source] = nil
            TriggerClientEvent("revolution: freeze", xTarget.source, false)
        elseif action == "revive" then
            revivePlayer(xTarget.source);
            SV_Notify(xPlayer.source, 'success',  "Du hast " .. GetPlayerName(playerId) .. " Wiederbelebt!", 5000)
            SV_Notify(xTarget.source, 'success',  "Du wurdest von einem Admin Wiederbelebt!", 5000)
        elseif action == "heal" then
            TriggerClientEvent("revolution: heal", xTarget.source)
            SV_Notify(xPlayer.source, 'success',  "Du hast " .. GetPlayerName(playerId) .. " geheilt!", 5000)
        elseif action == "clearinventory" then

            for k,v in pairs(xTarget.inventory) do
                if v.count > 0 then
                    xTarget.removeInventoryItem(v.name, v.count)
                end
            end
            SV_Notify(xPlayer.source, 'success',  "Du hast " .. GetPlayerName(playerId) .. " Inventar geleert!", 5000)
        elseif action == "loadoutclear" then
            for k,v in pairs(xTarget.loadout) do
                xTarget.removeWeapon(v.name)
            end
            SV_Notify(xPlayer.source, 'success',  "Du hast " .. GetPlayerName(playerId) .. " Loadout geleert!", 5000)
        end

    else
        SV_Notify(xPlayer.source, 'warning', "Fehler: Spieler mit der ID: " .. playerId .. " nicht gefunden.", 5000)
    end
end)


RegisterNetEvent("adminpanel:player:send:action:server:givecar")
AddEventHandler("adminpanel:player:send:action:server:givecar", function(action, playerId, vehicleName)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(playerId)

    if not revolution: hasPermissions(xPlayer.group, action) then
        SV_Notify(xPlayer.source, 'error',  "Du hast keine Berechtigung, das Admin-Menü zu öffnen.")
        return
    end
    if xTarget then
        if action == "givevehicle" then
            givecar(xTarget.getIdentifier(), vehicleName, revolution: generatePlate())
            SV_Notify(xPlayer.source, 'success',  "Du hast " .. GetPlayerName(playerId) .. " ein Fahrzeug gegeben!", 5000)
            revolution: sendLog(xPlayer, "givevehicle", "Auto gegeben an ".. xTarget.getIdentifier())
        end

    else
        SV_Notify(xPlayer.source, 'warning', "Fehler: Spieler mit der ID: " .. xTarget.source .. " nicht gefunden.", 5000)
    end
end)

RegisterNetEvent("adminpanel:player:send:action:server:dimension")
AddEventHandler("adminpanel:player:send:action:server:dimension", function(action, playerId, dimension)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(playerId)

    if not revolution: hasPermissions(xPlayer.group, action) then
        SV_Notify(xPlayer.source, 'error',  "Du hast keine Berechtigung, das Admin-Menü zu öffnen.")
        return
    end
    if xTarget then
        if action == "setdimension" then
            SetPlayerRoutingBucket(xTarget.source, tonumber(dimension))
            SV_Notify(xPlayer.source, 'success',  "Du hast " .. GetPlayerName(playerId) .. " Dimension gesetzt!", 5000)
        end

    else
        SV_Notify(xPlayer.source, 'warning', "Fehler: Spieler mit der ID: " .. playerId .. " nicht gefunden.", 5000)
    end
end)

RegisterNetEvent("ms:sendLog")
AddEventHandler("ms:sendLog", function(msg, action)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        if action == "aduty" then
            if inAduty[xPlayer.source] then
                inAduty[xPlayer.source] = false
            else
                inAduty[xPlayer.source] = true
            end
        end
        if action == "noclip" then
            if inNoclip[xPlayer.source] then
                inNoclip[xPlayer.source] = false
            else
                inNoclip[xPlayer.source] = true
            end
        end
        revolution: sendLog(xPlayer, action, msg)
    else
        print("Fehler: Spieler mit der ID: " .. xPlayer.source .. " nicht gefunden.")
    end
end)