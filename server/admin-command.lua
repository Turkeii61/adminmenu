wave = {}
wave.__index = wave

function revolution: hasPermissions(group, permission)
    if ADMINPANEL.Permissions[permission] then
        for k, v in pairs(ADMINPANEL.Permissions[permission]) do
            if (v == group) then
                return true
            end
        end
        return false
    end
end
function revolution: generatePlate()
    local plate = math.random(100000, 999999)
    return string.format("%06d", plate)
end
function revolution: sendLog(xPlayer, action, msg, level)
    if type(msg) == "table" then
        msg = json.encode(msg)
    end
    local webhook = WEBHOOKS[action]
    if webhook then
        PerformHttpRequest(webhook, function(err, text, headers)
            if err ~= 200 then
                print("Fehler beim Senden des Logs: " .. err)
            end
        end, 'POST', json.encode({
            username = 'Logs Admin',
            embeds = {
                {
                    ["title"] = xPlayer.name .. " hat eine Admin Aktion ausgeführ",
                    ["color"] = "#00ff00",
                    ["footer"] = {
                        ["text"] = "Wave Scripts | " .. os.date(),
                        ["icon_url"] = "https://cdn.discordapp.com/attachments/944789399852417096/1004915039414788116/imageedit_1_2564956129.png"
                    },
                    ["fields"] = {
                        {name = "**Aktion**", value = action, inline = true},
                        {name = "**Admin**", value = xPlayer.name, inline = true},
                        {name = "**Nachricht/Args**", value = msg, inline = true}
                    },
                    ["image"] = {
                        ["url"] = getScreenshot(xPlayer.source)
                    }
                }
            }
        }, {
            ["Content-Type"] = "application/json"
        }))
    end
end


wave.registerCommand = function(name, handler)
    RegisterCommand(name, function(src, args)
        local xPlayer = ESX.GetPlayerFromId(src)

        if not revolution: hasPermissions(xPlayer.group, name) then
            SV_Notify(src, 'error', 'Keine Rechte.', 5000)
            return
        end

        handler(xPlayer, args)
        revolution: sendLog(xPlayer, name, args)
    end, false)
end

wave.registerCommand("announce", function(xPlayer, args)
    local argString = table.concat(args, " ")
    announce(-1, argString, 10000)
end)

wave.registerCommand("teamchat", function(xPlayer, args)
    for k,v in pairs(GetPlayers()) do
        local xPlayer = ESX.GetPlayerFromId(v)
        if xPlayer then
            if xPlayer.group ~= 'user' then
                local argString = table.concat(args, " ")
                announce(v, "TEAMCHAT (".. GetPlayerName(v) .. "): " .. argString, 10000)
            end
        end
    end
end)

wave.registerCommand("setped", function(xPlayer, args)
    local id = tonumber(args[1])
    if id == nil then return end
    local pedModel = tostring(args[2])
    if pedModel == nil then return end
    TriggerClientEvent("ms:setPed", id, pedModel)
end)

wave.registerCommand("resetped", function(xPlayer, args)
    local id = tonumber(args[1])
    if id == nil then return end
    TriggerClientEvent("ms:setPedSkin", id)
end)

wave.registerCommand('giveweaponwave', function(xPlayer, args)
    local id = tonumber(args[1])
    if id == nil then return end
    local text = tostring(args[2])
    if text == nil then return end

    local xTarget = ESX.GetPlayerFromId(id)
    if xTarget then
        if not xTarget.hasWeapon(text) then
            xTarget.addWeapon(text, 255)
        else
            SV_Notify(xPlayer.source, 'error', 'Der Spieler hat die Waffe bereits.', 5000)
        end
    else
        SV_Notify(xPlayer.source, 'error', 'Der Spieler existiert nicht.', 5000)
    end
end)
wave.registerCommand('giveitemwave', function(xPlayer, args)
    local id = tonumber(args[1])
    if id == nil then return end
    local text = tostring(args[2])
    if text == nil then return end
    local amount = tonumber(args[3])
    if amount == nil then return end

    local xTarget = ESX.GetPlayerFromId(id)
    if xTarget then
        xTarget.addInventoryItem(text, amount)
        SV_Notify(xPlayer.source, 'success', 'Der Spieler hat das Item bekommen.', 5000)
    else
        SV_Notify(xPlayer.source, 'error', 'Der Spieler existiert nicht.', 5000)
    end
end)

wave.registerCommand('reviveallwave', function(xPlayer, args)
    for k, v in pairs(ESX.GetPlayers()) do
        local xTarget = ESX.GetPlayerFromId(v)
        if xTarget then
            revivePlayer(v);
            SV_Notify(v, 'success', 'Du wurdest wiederbelebt.', 5000)
        end
    end
    SV_Notify(xPlayer.source, 'success', 'Alle Spieler wurden wiederbelebt.', 5000)
end)

wave.registerCommand('givemoneywave', function(xPlayer, args)
    local id = tonumber(args[1])
    if id == nil then return end
    local text = tonumber(args[2])
    if text == nil then return end


    local xTarget = ESX.GetPlayerFromId(id)
    if xTarget then
        xTarget.addMoney(text)
        SV_Notify(xPlayer.source, 'success', 'Der Spieler hat das Geld bekommen.', 5000)
    else
        SV_Notify(xPlayer.source, 'error', 'Der Spieler existiert nicht.', 5000)
    end
end)

wave.registerCommand('hochjagen', function(xPlayer, args)
    local id = tonumber(args[1])
    if id == nil then return end
    TriggerClientEvent('ms:commands:hochjagen', id)
end)

wave.registerCommand('wegrammen', function(xPlayer, args)
    local id = tonumber(args[1])
    if id == nil then return end
    TriggerClientEvent('ms:commands:wegrammen', id)
end)

wave.registerCommand('aufflasche', function(xPlayer, args)
    local id = tonumber(args[1])
    if id == nil then return end
    TriggerClientEvent('ms:commands:aufFlascheSitzen', id)
end)

wave.registerCommand('flashbang', function(xPlayer, args)
    local id = tonumber(args[1])
    if id == nil then return end
    TriggerClientEvent('ms:commands:flashbang', id)
end)

wave.registerCommand('blackscreen', function(xPlayer, args)
    local id = tonumber(args[1])
    if id == nil then return end
    TriggerClientEvent('ms:commands:blackscreen', id)
end)

wave.registerCommand('setgroup', function(xPlayer, args)
    local id = tonumber(args[1])
    if id == nil then return end
    local group = tostring(args[2])
    if group == nil then return end
    local xTarget = ESX.GetPlayerFromId(id)
    if xTarget then
        xTarget.setGroup(group)
        SV_Notify(xTarget.source, 'success', 'Neue Gruppe :)', 5000)
        SV_Notify(xPlayer.source, 'success', 'Gruppe erfolgreich gesetzt.', 5000)
    else
        SV_Notify(xPlayer.source, 'error', 'Der Spieler existiert nicht.', 5000)
    end
end)

wave.registerCommand('giveteammoney', function(xPlayer, args)
    local money = tonumber(args[1])
    if money == nil then return end
    if money < 0 then return end
    for k,v in pairs(GetPlayers()) do
        local xPlayerr = ESX.GetPlayerFromId(v)
        if xPlayerr then
            if xPlayerr.group ~= 'user' then
                xPlayerr.addMoney(money)
                SV_Notify(xPlayerr.source, 'success', 'Teamgeld erfolgreich bekommen.', 5000)
            end
        end
    end
    SV_Notify(xPlayer.source, 'success', 'Erfolgreich.', 5000)
end)

wave.registerCommand('frakannounce', function(xPlayer, args)
    local job = tostring(args[1])
    if job == nil then return end
    local message = table.concat(args, " ", 2)
    if message == nil then return end

    local jobExists = false
    for _, v in pairs(ESX.GetJobs()) do
        if v.name == job then
            jobExists = true
            break
        end
    end

    if not jobExists then
        SV_Notify(xPlayer.source, 'error', 'Der Job existiert nicht.', 5000)
        return
    end

    for k,v in pairs(GetPlayers()) do
        local xPlayerr = ESX.GetPlayerFromId(v)
        if xPlayerr then
            if xPlayerr.getJob().name == job then
                announce(xPlayerr.source, "Fraktionsnachricht: " .. message, 10000)
            end
        end
    end
    SV_Notify(xPlayer.source, 'success', 'Erfolgreich.', 5000)
end)

wave.registerCommand('frakaufloesen', function(xPlayer, args)
    local job = tostring(args[1])
    if job == nil then return end

    local jobExists = false
    for _, v in pairs(ESX.GetJobs()) do
        if v.name == job then
            jobExists = true
            break
        end
    end

    if not jobExists then
        SV_Notify(xPlayer.source, 'error', 'Der Job existiert nicht.', 5000)
        return
    end

    for k,v in pairs(GetPlayers()) do
        local xPlayerr = ESX.GetPlayerFromId(v)
        if xPlayerr then
            if xPlayerr.getJob().name == job then
                xPlayerr.setJob("unemployed", 0)
            end
        end
    end
    SV_Notify(xPlayer.source, 'success', 'Erfolgreich.', 5000)
end)

wave.registerCommand('setjobwave', function(xPlayer, args)
    local id = tonumber(args[1])
    if id == nil then return end
    local job = tostring(args[2])
    if job == nil then return end
    local grade = tostring(args[3])
    if grade == nil then return end

    local jobExists = false
    for _, v in pairs(ESX.GetJobs()) do
        if v.name == job then
            jobExists = true
            break
        end
    end

    if not jobExists then
        SV_Notify(xPlayer.source, 'error', 'Der Job existiert nicht.', 5000)
        return
    end

    local xTarget = ESX.GetPlayerFromId(id)
    if xTarget then
        xTarget.setJob(job, grade)
        SV_Notify(xPlayer.source, 'success', 'Job erfolgreich gesetzt.', 5000)
    else
        SV_Notify(xPlayer.source, 'error', 'Der Spieler existiert nicht.', 5000)
    end
end)

wave.registerCommand('bringfraktion', function(xPlayer, args)
    local mycoords = GetEntityCoords(GetPlayerPed(xPlayer.source))
    local job = tostring(args[1])
    if job == nil then return end

    local jobExists = false
    for _, v in pairs(ESX.GetJobs()) do
        if v.name == job then
            jobExists = true
            break
        end
    end

    if not jobExists then
        SV_Notify(xPlayer.source, 'error', 'Der Job existiert nicht.', 5000)
        return
    end

    for k,v in pairs(GetPlayers()) do
        local xPlayerr = ESX.GetPlayerFromId(v)
        if xPlayerr then
            if xPlayerr.getJob().name == job then
                local TargetPed = GetPlayerPed(xPlayer.source)
                local TargetCoords = GetEntityCoords(TargetPed)
                local TargetDimension = GetEntityRoutingBucket(TargetPed)
                SetPlayerRoutingBucket(xPlayerr.source, TargetDimension)
                SV_Notify(xPlayerr.source, 'success',  "Du wurdest zu "..xPlayer.name.." Teleportiert", 5000)
                SetEntityCoords(GetPlayerPed(xPlayerr.source), vector3(mycoords.x, mycoords.y, mycoords.z))
            end
        end
    end
end)
