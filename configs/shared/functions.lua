function CL_Notify(type, msg, time)
    TriggerEvent("esx:notify", type, time, msg)
end

function SV_Notify(src, type, msg, time)
    TriggerClientEvent("esx:notify", src, type, time, msg)
end

function announce(s, msg, time)
    TriggerClientEvent("esx:notify", s, "test", time, msg)
end

function revivePlayer(s)
    TriggerClientEvent('esx_ambulancejob:revive', s)
end

function openSkinMenu(s)
    TriggerClientEvent('esx_skin:openMenu', s)
end

function givecar(identifier, vehicleName, plate)
    if not identifier or not vehicleName or not plate then
        return
    end
    local job = "civ"
    local parking = false
    local pound = false
    local mileage = 0
    local query = [[
        INSERT INTO owned_vehicles (owner, plate, vehicle, job, stored, parking, pound, mileage) 
        VALUES (@owner, @plate, @vehicle, @job, @stored, @parking, @pound, @mileage)
        ON DUPLICATE KEY UPDATE 
        vehicle = @vehicle, job = @job, stored = @stored, parking = @parking, pound = @pound, mileage = @mileage;
    ]]

    MySQL.Async.execute(query, {
        ['@owner'] = identifier,
        ['@plate'] = plate,
        ['@vehicle'] = json.encode({model = GetHashKey(vehicleName), plate = plate}),
        ['@job'] = job or '',
        ['@stored'] = 0,
        ['@parking'] = parking or '',
        ['@pound'] = pound or '',
        ['@mileage'] = mileage or 0
    }, function(affectedRows)
      
    end)
end


function getScreenshot(source)
    -- exports["screenshot-basic"]:requestScreenshotUpload(url, 'files[]', function(data)
    --     local img = json.decode(data)
    --     return img.attachments[1].url
    -- end)
    return "https://i.imgur.com/0e2s4jT.png"
end