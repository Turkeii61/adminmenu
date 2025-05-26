panelData = {
    states = {
        aduty = false,
        noclip = false,
        godmode = false,
        nametags = false,
        vanish = false,
        freezed = false,
    },
    players = {},
    serverName = "not Loaded",
    state = false,
    group = nil
}

RegisterKeyMapping('adminpanel', 'Admin Panel', 'keyboard', ADMINPANEL.Key)
RegisterCommand('adminpanel', function()
    if (panelData.state) then
        return;
    end
    if panelData.group == nil then
        ESX.TriggerServerCallback('ms:getGroup', function(group)
            panelData.group = group.group
            panelData.serverName = group.serverName
            if final:hasPermissions(group.group, "openMenu") then
                final:openAdminPanel()
                return;
            end
        end)
    else
        if final:hasPermissions(panelData.group, "openMenu") then
            final:openAdminPanel()
            return;
        end
    end
end)

if ADMINPANEL.AdminNames then
    CreateThread(function()
        while true do
            local sleep = 2000
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)

            if panelData and panelData.players then
                for _, v in pairs(panelData.players) do
                    if v.inAduty and not v.inNoclip then
                        local playerServerId = tonumber(v.id)
                        if playerServerId then
                            local targetPlayer = GetPlayerFromServerId(playerServerId)
                            if targetPlayer and NetworkIsPlayerActive(targetPlayer) then
                                local targetPed = GetPlayerPed(targetPlayer)
                                if targetPed and DoesEntityExist(targetPed) then
                                    local targetCoords = GetEntityCoords(targetPed)
                                    local distance = #(playerCoords - targetCoords)

                                    if distance <= 20.0 then
                                        sleep = 0
                                        DrawText3D(targetCoords.x, targetCoords.y, targetCoords.z + 1.5, string.upper(v.group), ADMINPANEL.AdminNamesColor.r, ADMINPANEL.AdminNamesColor.g, ADMINPANEL.AdminNamesColor.b)
                                        DrawText3D(targetCoords.x, targetCoords.y, targetCoords.z + 1.2, v.username, ADMINPANEL.AdminNamesColor.r, ADMINPANEL.AdminNamesColor.g, ADMINPANEL.AdminNamesColor.b)
                                    end
                                end
                            end
                        end
                    end
                end
            end

            Wait(sleep)
        end
    end)
end

function DrawText3D(x, y, z, text, r, g, b)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local camCoords = GetGameplayCamCoords()
    local dist = #(vector3(camCoords.x, camCoords.y, camCoords.z) - vector3(x, y, z))
    local scale = ADMINPANEL.AdminNamesSize
    if onScreen then
        SetTextScale(scale, scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(r, g, b, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(1, 0, 0, 0, 255)
        SetTextDropShadow()
        SetTextOutline()
        SetTextCentre(1)

        SetTextEntry("STRING")
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end


RegisterNUICallback('nuiFocus', function(data, cb)
    local focus = data.focus
    local cursor = data.cursor
    local input = data.input
    SetNuiFocus(focus, cursor)
    if input then
        SetNuiFocusKeepInput(true)
    else
        SetNuiFocusKeepInput(false)
    end
    print(string.format("NUI Focus: focus=%s, cursor=%s, input=%s", tostring(focus), tostring(cursor), tostring(input)))
    cb('ok')
end)

RegisterNuiCallback('onChange', function(data, cb)
    for k, v in pairs(items) do
        if (v.type == 'submenu') then
            for k1, v1 in pairs(v.items) do
                if (v1.id == data.selected) then
                    if (v1.label == 'Admindienst') then
                        v1.checked = not v1.checked
                        panelData.states.aduty = v1.checked
                        panelData.states.godmode = v1.checked
                        if (v1.checked) then
                            CL_Notify('success', "Du bist nun im Aduty.", 5000)
                            final:setAduty(panelData.group)
                        else
                            CL_Notify('error', "Du bist nun nicht mehr im Aduty.", 5000)
                            final:sendLog("Adminmenu: Admin-Modus beendet", 'aduty')
                            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                                TriggerEvent('skinchanger:loadSkin', skin)
                            end)
                        end
                    end
                    if (v1.label == 'NoClip') then
                        v1.checked = not v1.checked
                        panelData.states.noclip = v1.checked
                        final:noClip(v1.checked)
                        final:sendLog("NoClip " .. (v1.checked and "aktiviert" or "deaktiviert"), 'noclip')
                    end

                    if (v1.label == 'Godmode') then
                        v1.checked = not v1.checked
                        panelData.states.godmode = v1.checked
                        if v1.checked then
                            CL_Notify('success', "Du bist nun im Godmode.", 5000)
                        else
                            CL_Notify('error', "Du bist nicht mehr im Godmode.", 5000)
                        end
                        final:sendLog("Godmode " .. (v1.checked and "aktiviert" or "deaktiviert"), 'godmode')
                    end

                    if (v1.label == 'Nametags') then
                        v1.checked = not v1.checked
                        panelData.states.nametags = v1.checked
                        final:toggleNametags(v1.checked)
                        if v1.checked then
                            CL_Notify('success', "Du hast Nametags eingeschaltet.", 5000)
                        else
                            CL_Notify('error', "Du hast Nametags ausgeschaltet.", 5000)
                        end
                        final:sendLog("Nametags " .. (v1.checked and "eingeschaltet" or "ausgeschaltet"), 'nametags')
                    end

                    if (v1.label == 'Vanish') then
                        v1.checked = not v1.checked
                        panelData.states.vanish = v1.checked
                        SetEntityVisible(PlayerPedId(), not v1.checked, false)
                        if v1.checked then
                            CL_Notify('success', "Du bist im Vanish.", 5000)
                        else
                            CL_Notify('error', "Du bist nicht mehr im Vanish.", 5000)
                        end
                        final:sendLog("Vanish " .. (v1.checked and "aktiviert" or "deaktiviert"), 'vanish')
                    end

                end
            end
        end
    end
    cb(data)
end)

RegisterNuiCallback('onClick', function(data, cb)
    for k, v in pairs(items) do
        if (v.type == 'submenu') then
            for k1, v1 in pairs(v.items) do
                if (v1.id == data.selected) then
                    if (v1.label == 'Boost') then
                        boostVehicle()
                        final:sendLog("Boost aktiviert", 'boost')
                    end
                    if (v1.label == 'Löschen') then
                        if (not IsPedInAnyVehicle(PlayerPedId(), false)) then
                            return CL_Notify('error', 'Du bist in keinem Fahrzeug!', 5000)
                        end
                        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                        SetEntityAsMissionEntity(vehicle, true, true)
                        DeleteVehicle(vehicle)
                        CL_Notify('success', 'Fahrzeug gelöscht', 5000)
                        final:sendLog("Fahrzeug gelöscht", 'deleteVehicle')
                    end

                    if (v1.label == 'Reparieren') then
                        if (not IsPedInAnyVehicle(PlayerPedId(), false)) then
                            return CL_Notify('error', 'Du bist in keinem Fahrzeug!', 5000)
                        end
                        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
                        SetVehicleUndriveable(veh, false)
                        SetVehicleFixed(veh)
                        SetVehicleEngineOn(veh, true, false)
                        SetVehicleDirtLevel(veh, 0.0)
                        SetVehicleOnGroundProperly(veh)
                        final:sendLog("Fahrzeug repariert", 'repairVehicle')
                    end

                    if (v1.label == 'Flip') then
                        if (not IsPedInAnyVehicle(PlayerPedId(), false)) then
                            return CL_Notify('error', 'Du bist in keinem Fahrzeug!', 5000)
                        end
                        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
                        SetVehicleOnGroundProperly(veh)
                        final:sendLog("Fahrzeug geflippt", 'flipVehicle')
                    end

                    if (v1.label == 'Fulltune') then
                        if (not IsPedInAnyVehicle(PlayerPedId(), false)) then
                            return CL_Notify('error', 'Du bist in keinem Fahrzeug!', 5000)
                        end

                        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
                        fulltune(veh)
                        CL_Notify('success', 'Fahrzeug fulltuned!', 5000)
                        final:sendLog("Fahrzeug fulltuned", 'fullTune')
                    end

                    -- Clear
                    if (v1.label == 'Fahrzeuge löschen') then
                        CL_Notify('success', "Fahrzeuge werden Cleart!", 5000)
                        TriggerServerEvent("adminmenu:cleanArea:server", "cars")
                        final:sendLog("Fahrzeuge gelöscht", 'clearVehicles')
                    end

                    if (v1.label == 'Peds löschen') then
                        CL_Notify('success', "Peds werden Cleart!", 5000)
                        TriggerServerEvent("adminmenu:cleanArea:server", "peds")
                        final:sendLog("Peds gelöscht", 'clearPeds')
                    end

                    if (v1.label == 'Props löschen') then
                        CL_Notify('success', "Props werden Cleart!", 5000)
                        TriggerServerEvent("adminmenu:cleanArea:server", "props")
                        final:sendLog("Props gelöscht", 'clearProps')
                    end

                    -- Troll
                    if (v1.label == 'Hochjagen') then
                        OpenIDModal("hochjagen")
                    end

                    if (v1.label == 'Wegrammen') then
                        OpenIDModal("wegrammen")
                    end

                    if (v1.label == 'Flasche sitzen') then
                        OpenIDModal("flasche")
                    end

                    if (v1.label == 'Flashbang') then
                        OpenIDModal("flashbang")
                    end

                    if (v1.label == 'Blackscreen') then
                        OpenIDModal("blackscreen")
                    end

                    -- Announce
                    if (v1.label == 'Announce') then
                        OpenTextModal("announce")
                    end

                    if (v1.label == 'Teamchat Nachricht') then
                        OpenTextModal("teamchat")
                    end

                    -- Erstattung

                    if(v1.label == "Geld") then
                        OpenIDModal("givemoneyFinal")
                    end

                    if(v1.label == "Waffen") then
                        OpenIDModal("giveweaponFinal")
                    end

                    if(v1.label == "Items") then
                        OpenIDModal("giveitemFinal")

                    end

                    if (v1.label == "Revive (ID)") then
                        OpenIDModal2("revive")
                    end

                    if (v1.label == "Revive All") then
                        ExecuteCommand("reviveallFinal")
                    end

                    if (v1.label == "Heal (ID)") then
                        OpenIDModal2("heal")
                    end

                    if (v1.label == "Inventar Löschen (ID)") then
                        OpenIDModal2("clearinventory")
                    end

                    if (v1.label == "Loadout Löschen (ID)") then
                        OpenIDModal2("loadoutclear")
                    end

                    if (v1.label == "Spawn Vehicle") then
                        OpenTextModal("spawnvehicle")
                    end

                    if (v1.label == "Give Vehicle (Garage)") then
                        OpenIDModal3("givevehicle")
                    end

                    if (v1.label == "Dimension Setzen") then
                        OpenIDModal4("setdimension")
                    end
                    if (v1.label == "Vector 3 Kopieren") then
                        local coords = GetEntityCoords(PlayerPedId())
                        local x, y, z = coords.x, coords.y, coords.z
                        CL_Notify('success', x .. ", " .. y .. ", " .. z, 5000)
                    end
                    if (v1.label == "Vector 4 Kopieren") then
                        local coords = GetEntityCoords(PlayerPedId())
                        local x, y, z = coords.x, coords.y, coords.z
                        local h = GetEntityHeading(PlayerPedId())
                        CL_Notify('success', x .. ", " .. y .. ", " .. z .. ", " .. h, 5000)
                    end

                    if (v1.label == "Ped Setzen (ID)") then
                        OpenIDModal4("setped")
                    end

                    if (v1.label == "Ped Zurücksetzen (ID)") then
                        OpenIDModal("resetped")
                    end

                    if (v1.label == "Gruppe Setzen (ID)") then
                        OpenIDModal("setgroup")
                    end

                    if (v1.label == "Team Belohnung") then
                        OpenTextModal("giveteammoney")
                    end

                    if (v1.label == "Fraktion bringen") then
                        OpenTextModal("bringfraktion")
                    end

                    if (v1.label == "Fraktions Ankündigung") then
                        OpenTextModal("frakannounce")
                    end

                    if (v1.label == "Fraktion auflösen") then
                        OpenTextModal("frakaufloesen")
                    end

                    if (v1.label == "Job Setzen (ID)") then
                        OpenIDModal ("setjobFinal")
                    end
                end
            end
        end
    end
    cb(data)
end)

CreateThread(function()
	while true do
		Wait(2000)
		if panelData.states.godmode then
			SetEntityInvincible(GetPlayerPed(-1), true)
			SetPlayerInvincible(PlayerId(), true)
			SetPedCanRagdoll(GetPlayerPed(-1), false)
			ClearPedBloodDamage(GetPlayerPed(-1))
			ResetPedVisibleDamage(GetPlayerPed(-1))
			ClearPedLastWeaponDamage(GetPlayerPed(-1))
			SetEntityProofs(GetPlayerPed(-1), true, true, true, true, true, true, true, true)
        else
			SetEntityInvincible(GetPlayerPed(-1), false)
			SetPlayerInvincible(PlayerId(), false)
			SetPedCanRagdoll(GetPlayerPed(-1), true)
			ClearPedLastWeaponDamage(GetPlayerPed(-1))
			SetEntityProofs(GetPlayerPed(-1), false, false, false, false, false, false, false, false)
		end
	end
end)

RegisterNuiCallback('closeAdminpanel', function(data, cb)
    panelData.state = false
    items = {}
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
    cb({})
end)

RegisterNetEvent('sendPlayersList')
AddEventHandler('sendPlayersList', function(players)
    for k,v in pairs(players) do
        v.distance = math.floor(#(v.distance - GetEntityCoords(GetPlayerPed(-1))))
    end
    panelData.players = players
    SendNUIMessage({
        type = 'updatePlayersList',
        players = players
    })
end)


RegisterNetEvent("adminmenu:cleanArea:client")
AddEventHandler("adminmenu:cleanArea:client", function(typee)
    local ObjectsToDelete = {}


    if typee == "cars" then
        ObjectsToDelete = GetGamePool("CVehicle")

    elseif typee == "peds" then
        ObjectsToDelete = GetGamePool("CPed")
    elseif typee == "props" then
        local objects = GetGamePool("CObject")
        local pickups = GetGamePool("CPickup")
        for _, object in pairs(objects) do
            table.insert(ObjectsToDelete, object)
        end
        for _, pickup in pairs(pickups) do
            table.insert(ObjectsToDelete, pickup)
        end
    end

    for _, entity in pairs(ObjectsToDelete) do
        if DoesEntityExist(entity) then

            if typee == "cars" and not IsPedAPlayer(GetPedInVehicleSeat(entity, -1)) then
                if not NetworkHasControlOfEntity(entity) then
                    local attempts = 0
                    repeat
                        NetworkRequestControlOfEntity(entity)
                        attempts = attempts + 1
                        Wait(100)
                    until (NetworkHasControlOfEntity(entity) or attempts >= 500)
                end
                DeleteEntity(entity)
            elseif typee ~= "cars" then
                if not NetworkHasControlOfEntity(entity) then
                    local attempts = 0
                    repeat
                        NetworkRequestControlOfEntity(entity)
                        attempts = attempts + 1
                        Wait(100)
                    until (NetworkHasControlOfEntity(entity) or attempts >= 500)
                end
                DeleteEntity(entity)
            end
        end
        Wait(1)
    end
end)



function OpenIDModal2(aktion)
    final:openDialog('Spieler ID Eingeben', function(value)
        value = tonumber(value)
        if not value or value <= 0 then
            CL_Notify('error', "Ungültige Eingabe", 5000)
            return
        end
        SetNuiFocus(true, false)
        CL_Notify('success', "Aktion erfolgreich für Spieler mit ID " .. value, 5000)
        TriggerServerEvent("adminpanel:player:send:action:server", aktion, value)
    end)
end

function OpenIDModal(aktion)
    final:openDialog('Spieler ID Eingeben', function(value)
        value = tonumber(value)
        if not value or value <= 0 then
            CL_Notify('error', "Ungültige Eingabe", 5000)
            return
        end

        if aktion == "giveitemFinal" or aktion == "giveweaponFinal" or aktion == "givemoneyFinal" then
            final:openDialog("Waffe/Item/Geld Eingeben", function(valuee)
                if valuee == "" or not valuee then
                    CL_Notify('error', "Textfeld darf nicht leer sein", 5000)
                    return
                end

                if aktion == "giveitemFinal" then
                    final:openDialog("Amount Eingeben", function(valueee)
                        valueee = tonumber(valueee)
                        if not valueee then
                            CL_Notify('error', "Ungültige Anzahl", 5000)
                            return
                        end
                        ExecuteCommand(aktion .. " " .. value .. " " .. valuee .. " " .. valueee)
                        SetNuiFocus(true, false)
                    end)
                else
                    ExecuteCommand(aktion .. " " .. value .. " " .. valuee)
                    SetNuiFocus(true, false)
                end
            end)
        elseif aktion == "setgroup" then
            final:openDialog('Gruppe Eingeben', function(valuee)
                valuee = tostring(valuee)
                if not valuee then
                    CL_Notify('error', "Ungültige Eingabe", 5000)
                    return
                end
                SetNuiFocus(true, false)
                ExecuteCommand("setgroup "..value.." "..valuee)
            end)
        elseif aktion == "setjobFinal" then
            final:openDialog('Job Eingeben', function(valuee)
                valuee = tostring(valuee)
                if not valuee then
                    CL_Notify('error', "Ungültige Eingabe", 5000)
                    return
                end
                final:openDialog('Grade Eingeben', function(valueee)
                    valueee = tonumber(valueee)
                    if not valueee then
                        CL_Notify('error', "Ungültige Eingabe", 5000)
                        return
                    end

                    SetNuiFocus(true, false)
                    ExecuteCommand("setjobFinal "..value.." "..valuee.. " "..valueee)
                end)

            end)
        else
            CL_Notify('success', "Aktion erfolgreich für Spieler mit ID " .. value, 5000)
            ExecuteCommand(aktion .. " " .. value)
            SetNuiFocus(true, false)
        end
    end)
end

function OpenIDModal3(aktion)
    final:openDialog('Spieler ID Eingeben', function(value)
        value = tonumber(value)
        if not value or value <= 0 then
            CL_Notify('error', "Ungültige Eingabe", 5000)
            return
        end
        final:openDialog('Auto Namen Eingeben', function(valuee)
            if not valuee or valuee == "" then
                CL_Notify('error', "Ungültige Eingabe", 5000)
                return
            end
            CL_Notify('success', "Aktion erfolgreich für Spieler mit ID " .. value, 5000)
            TriggerServerEvent("adminpanel:player:send:action:server:givecar", aktion, value, valuee)
            SetNuiFocus(true, false)
        end)
    end)
end

function OpenIDModal4(aktion)
    final:openDialog('Spieler ID Eingeben', function(value)
        value = tonumber(value)
        if not value or value <= 0 then
            CL_Notify('error', "Ungültige Eingabe", 5000)
            return
        end
        if aktion == "setped" then
            if not final:hasPermissions(panelData.group, "setped") then
                CL_Notify('error', "Du hast keine Berechtigung, dein Ped zu setzen.")
                return
            end
            final:openDialog('Ped Eingeben', function(valuee)
                valuee = tostring(valuee)
                if not valuee then
                    CL_Notify('error', "Ungültige Eingabe", 5000)
                    return
                end
                SetNuiFocus(true, false)
                ExecuteCommand("setped "..value.." "..valuee)
                SetNuiFocus(true, false)
            end)


        else
            final:openDialog('Dimension Eingeben', function(valuee)
                valuee = tonumber(valuee)
                if not valuee then
                    CL_Notify('error', "Ungültige Eingabe", 5000)
                    return
                end
                SetNuiFocus(true, false)
                TriggerServerEvent("adminpanel:player:send:action:server:dimension", aktion, value, valuee)
            end)
        end

    end)
end

function OpenTextModal(aktion)
    final:openDialog("Text Eingeben", function(value)
        if not value or value == "" then
            CL_Notify('error', "Textfeld darf nicht leer sein", 5000)
            return
        end

        if aktion == "spawnvehicle" then
            if not final:hasPermissions(panelData.group, "spawnvehicle") then
                CL_Notify('error', "Du hast keine Berechtigung, ein Auto zu spawnen.")
                return
            end

            local playerPed = PlayerPedId()
            local coords = GetEntityCoords(playerPed)
            RequestModel(value)
            while not HasModelLoaded(value) do
                Wait(0)
            end

            local vehicle = CreateVehicle(GetHashKey(value), coords.x, coords.y, coords.z, GetEntityHeading(playerPed), true, false)
            SetPedIntoVehicle(playerPed, vehicle, -1)
            SetModelAsNoLongerNeeded(value)
            CL_Notify('success', "Fahrzeug erfolgreich gespawnt.", 5000)
            SetNuiFocus(true, false)
        elseif aktion == "frakannounce" then
            final:openDialog('Fraktionsname Eingeben', function(valuee)
                valuee = tostring(valuee)
                if not valuee then
                    CL_Notify('error', "Ungültige Eingabe", 5000)
                    return
                end
                SetNuiFocus(true, false)
                ExecuteCommand("frakannounce "..valuee.. " "..value)
            end)
        else
            ExecuteCommand(aktion .. " " .. value)
            SetNuiFocus(true, false)
        end
    end)
end


RegisterNuiCallback('adminpanel:player:send:action', function(JsonData, cb)
    local FormatedData = json.decode(JsonData.data)
    local playerId = tonumber(FormatedData.playerid)
    local action = tostring(FormatedData.aktion)

    if FormatedData and playerId and action then
        TriggerServerEvent("adminpanel:player:send:action:server", action, playerId)
    end
end)