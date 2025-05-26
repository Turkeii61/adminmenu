Final = {}
Final.__index = Final

function final:hasPermissions(group, permission)
    if ADMINPANEL.Permissions[permission] then
        for k, v in pairs(ADMINPANEL.Permissions[permission]) do
            if (v == group) then
                return true
            end
        end
        return false
    end
end

function final:setAduty(group)
    local playerPed = PlayerPedId()
    TriggerEvent('skinchanger:getSkin', function(skin)
        if skin.sex == 1 then
            skin.sex = 0
            TriggerEvent('skinchanger:loadSkin', skin)
        end
        Wait(100)
        TriggerEvent("skinchanger:loadClothes", skin, ADMINPANEL.Aduties[group])
    end)
    final:sendLog("In Aduty gegangen", 'aduty')
end

function final:sendLog(msg, action)
    TriggerServerEvent("ms:sendLog", msg, action)
end

function final:getJobFromID(id)
    for k,v in pairs(panelData.players) do
        if tostring(v.id) == tostring(id) then
            return v.job
        end
    end
end

function final:noClip(state)
    if state then
        SetPlayerControl(PlayerId(), 0, 0)
        SetPlayerCanControl(PlayerId(), false)
        SetPlayerInvincible(PlayerId(), true)
        SetEntityInvincible(PlayerPedId(), true)
    else
        SetPlayerControl(PlayerId(), 1, 0)
        SetPlayerCanControl(PlayerId(), true)
        SetPlayerInvincible(PlayerId(), false)
        SetEntityInvincible(PlayerPedId(), false)
    end
end

local speed = NO_CLIP_NORMAL_SPEED
local input = vector3(0, 0, 0)
local previousVelocity = vector3(0, 0, 0)
local breakSpeed = 10.0;
local offset = vector3(0, 0, 1);
-- Constants --
MOVE_UP_KEY = 38
MOVE_DOWN_KEY = 44
CHANGE_SPEED_KEY = 21
MOVE_LEFT_RIGHT = 30
MOVE_UP_DOWN = 31
NOCLIP_TOGGLE_KEY = 170
NO_CLIP_NORMAL_SPEED = 0.5
NO_CLIP_FAST_SPEED = 2.5
ENABLE_TOGGLE_NO_CLIP = false
ENABLE_NO_CLIP_SOUND = true
local noClippingEntity = PlayerPedId();

function final:noClip(state)
    return SetNoClip(status)
end

function IsControlAlwaysPressed(inputGroup, control)
    return IsControlPressed(inputGroup, control) or
        IsDisabledControlPressed(inputGroup, control)
end

function IsControlAlwaysJustPressed(inputGroup, control)
    return IsControlJustPressed(inputGroup, control) or
        IsDisabledControlJustPressed(inputGroup, control)
end

function Lerp(a, b, t) return a + (b - a) * t end

function IsPedDrivingVehicle(ped, veh)
    return ped == GetPedInVehicleSeat(veh, -1);
end

function SetNoClip(val)
    if (panelData.states.noclip ~= val) then
        noClippingEntity = PlayerPedId();
        if IsPedInAnyVehicle(PlayerPedId(), false) then
            local veh = GetVehiclePedIsIn(PlayerPedId(), false);
            if IsPedDrivingVehicle(PlayerPedId(), veh) then
                noClippingEntity = veh;
            end
        end
        local isVeh = IsEntityAVehicle(noClippingEntity);

        if ENABLE_NO_CLIP_SOUND then
            if panelData.states.noclip then
                PlaySoundFromEntity(-1, "SELECT", PlayerPedId(), "HUD_LIQUOR_STORE_SOUNDSET", 0, 0)
            else
                PlaySoundFromEntity(-1, "CANCEL", PlayerPedId(), "HUD_LIQUOR_STORE_SOUNDSET", 0, 0)
            end
        end
        SetUserRadioControlEnabled(not panelData.states.noclip);
        if (panelData.states.noclip) then
            CL_Notify('success', 'Du bist im NoClip', 5000)
            SetEntityAlpha(noClippingEntity, 51, 0)
            Citizen.CreateThread(function()
                local clipped = noClippingEntity
                local pPed = PlayerPedId();
                local isClippedVeh = isVeh;
                -- We start with no-clip mode because of the above if --

                FreezeEntityPosition(clipped, true);
                SetEntityCollision(clipped, false, false);

                SetEntityVisible(clipped, false, false);
                SetLocalPlayerVisibleLocally(true);
                SetEntityAlpha(clipped, 51, false)

                SetEveryoneIgnorePlayer(pPed, true);
                SetPoliceIgnorePlayer(pPed, true);

                if not isClippedVeh then
                    ClearPedTasksImmediately(pPed)
                end

                while panelData.states.noclip do
                    Citizen.Wait(0);
                    -- `(a and b) or c`, is msally `a ? b : c` --
                    input = vector3(GetControlNormal(0, MOVE_LEFT_RIGHT), GetControlNormal(0, MOVE_UP_DOWN),
                        (IsControlAlwaysPressed(1, MOVE_UP_KEY) and 1) or
                        ((IsControlAlwaysPressed(1, MOVE_DOWN_KEY) and -1) or 0))
                    speed = ((IsControlAlwaysPressed(1, CHANGE_SPEED_KEY) and NO_CLIP_FAST_SPEED) or NO_CLIP_NORMAL_SPEED) *
                        ((isClippedVeh and 2.75) or 1)

                    MoveInNoClip();
                end

                FreezeEntityPosition(clipped, false);
                SetEntityCollision(clipped, true, true);

                SetEntityVisible(clipped, true, false);
                SetLocalPlayerVisibleLocally(true);
                ResetEntityAlpha(clipped);

                SetEveryoneIgnorePlayer(pPed, false);
                SetPoliceIgnorePlayer(pPed, false);
                ResetEntityAlpha(clipped);

                -- We're done with the while so we aren't in no-clip mode anymore --
                -- Wait until the player starts falling or is completely stopped --
                if isClippedVeh then
                    while (not IsVehicleOnAllWheels(clipped)) and not panelData.states.noclip do
                        Citizen.Wait(0);
                    end
                    while not panelData.states.noclip do
                        Citizen.Wait(0);

                        if IsVehicleOnAllWheels(clipped) then
                        end
                    end
                else
                    while (IsPedStopped(clipped) or not IsPedFalling(clipped)) and not panelData.states.noclip do
                        Citizen.Wait(0);
                    end

                    while not panelData.states.noclip do
                        Citizen.Wait(0);

                        if IsPedStopped(clipped) and not IsPedFalling(clipped) then
                        end
                    end
                end
            end)
        else
            ResetEntityAlpha(noClippingEntity)
            CL_Notify('error', 'Du bist nicht mehr im NoClip', 5000)
            TriggerEvent('instructor:flush', RESSOURCE_NAME);
        end
    end
end

function MoveInNoClip()
    SetEntityRotation(noClippingEntity, GetGameplayCamRot(0), 0, false)
    local forward, right, up, c = GetEntityMatrix(noClippingEntity);
    previousVelocity = Lerp(previousVelocity,
        (((right * input.x * speed) + (up * -input.z * speed) + (forward * -input.y * speed))), Timestep() * breakSpeed);
    c = c + previousVelocity
    SetEntityCoords(noClippingEntity, c - offset, true, true, true, false)
end

function MoveCarInNoClip()
    SetEntityRotation(noClippingEntity, GetGameplayCamRot(0), 0, false)
    local forward, right, up, c = GetEntityMatrix(noClippingEntity);
    previousVelocity = Lerp(previousVelocity,
        (((right * input.x * speed) + (up * input.z * speed) + (forward * -input.y * speed))), Timestep() * breakSpeed);
    c = c + previousVelocity
    SetEntityCoords(noClippingEntity, (c - offset) + (vec(0, 0, .3)), true, true, true, false)
end

local playerGamerTags = {}
local distanceToCheck = 150

local fivemGamerTagCompsEnum = {
    GamerName = 0,
    CrewTag = 1,
    HealthArmour = 2,
    BigText = 3,
    AudioIcon = 4,
    UsingMenu = 5,
    PassiveMode = 6,
    WantedStars = 7,
    Driver = 8,
    CoDriver = 9,
    Tagged = 12,
    GamerNameNearby = 13,
    Arrow = 14,
    Packages = 15,
    InvIfPedIsFollowing = 16,
    RankText = 17,
    Typing = 18
}

local function cleanAllGamerTags()
    for _, v in pairs(playerGamerTags) do
        if IsMpGamerTagActive(v.gamerTag) then
            RemoveMpGamerTag(v.gamerTag)
        end
    end
    playerGamerTags = {}
end

local function setGamerTagFivem(targetTag, pid)

    SetMpGamerTagVisibility(targetTag, fivemGamerTagCompsEnum.GamerName, 1)

    SetMpGamerTagHealthBarColor(targetTag, 129)
    SetMpGamerTagAlpha(targetTag, fivemGamerTagCompsEnum.HealthArmour, 255)
    SetMpGamerTagVisibility(targetTag, fivemGamerTagCompsEnum.HealthArmour, 1)

    SetMpGamerTagAlpha(targetTag, fivemGamerTagCompsEnum.AudioIcon, 255)
    if MumbleIsPlayerTalking(pid) then
        SetMpGamerTagVisibility(targetTag, fivemGamerTagCompsEnum.AudioIcon, true)
        SetMpGamerTagColour(targetTag, fivemGamerTagCompsEnum.AudioIcon, 25)
        SetMpGamerTagColour(targetTag, fivemGamerTagCompsEnum.GamerName, 25)
    else
        SetMpGamerTagVisibility(targetTag, fivemGamerTagCompsEnum.AudioIcon, false)
        SetMpGamerTagColour(targetTag, fivemGamerTagCompsEnum.AudioIcon, 0)
        SetMpGamerTagColour(targetTag, fivemGamerTagCompsEnum.GamerName, 0)
    end
end

local function clearGamerTagFivem(targetTag)
    SetMpGamerTagVisibility(targetTag, fivemGamerTagCompsEnum.GamerName, 0)
    SetMpGamerTagVisibility(targetTag, fivemGamerTagCompsEnum.HealthArmour, 0)

    SetMpGamerTagVisibility(targetTag, fivemGamerTagCompsEnum.AudioIcon, 0)
end

local setGamerTagFunc = setGamerTagFivem
local clearGamerTagFunc = clearGamerTagFivem

local function showGamerTags()
    local curCoords = GetEntityCoords(PlayerPedId())
    local allActivePlayers = GetActivePlayers()

    for _, pid in ipairs(allActivePlayers) do
        local targetPed = GetPlayerPed(pid)

        local jobIdentifier = Player(GetPlayerServerId(pid)).state['ESX_Identifier']
        local group = Player(GetPlayerServerId(pid)).state['ESX_Group']

        if not playerGamerTags[pid] or not IsMpGamerTagActive(playerGamerTags[pid].gamerTag) then
            local playerName = string.sub(GetPlayerName(pid) or "unknown", 1, 75)
            local playerStr = ("[%s] %s %s"):format(GetPlayerServerId(pid), final:getJobFromID(GetPlayerServerId(pid)), playerName)
            playerGamerTags[pid] = {
                gamerTag = CreateFakeMpGamerTag(targetPed, playerStr, false, false, "", 0),
                SetMpGamerTagHealthBarColor(gamerTag, 129),
                SetMpGamerTagAlpha(gamerTag, fivemGamerTagCompsEnum.HealthArmour, 255),
                SetMpGamerTagVisibility(gamerTag, fivemGamerTagCompsEnum.HealthArmour, 1),
                ped = targetPed
            }

            if (group ~= 'user') then
                SetMpGamerTagVisibility(playerGamerTags[pid].gamerTag, 7, true)
                SetMpGamerTagColour(playerGamerTags[pid].gamerTag, 7, 12)
            end
        end
        local targetTag = playerGamerTags[pid].gamerTag

        local targetPedCoords = GetEntityCoords(targetPed)
        if #(targetPedCoords - curCoords) <= distanceToCheck then
            setGamerTagFunc(targetTag, pid)
        else
            clearGamerTagFunc(targetTag)
        end
    end
end

local function createGamerTagThread()
    CreateThread(function()
        while panelData.states.nametags do
            showGamerTags()
            Wait(250)
        end

        cleanAllGamerTags()
    end)
end

function final:toggleNametags(enabled)
    if enabled then
        createGamerTagThread()
    end
end

local boostableVehicleClasses = {
    [0] = 'Compacts',
    [1] = 'Sedans',
    [2] = 'SUVs',
    [3] = 'Coupes',
    [4] = 'Muscle',
    [5] = 'Sports Classics',
    [6] = 'Sports',
    [7] = 'Super',
    -- [8]='Motorcycles',
    [9] = 'Off-road',
    -- [10]='Industrial',
    [11] = 'Utility',
    [12] = 'Vans',
    -- [13]='Cycles',
    -- [14]='Boats',
    -- [15]='Helicopters',
    -- [16]='Planes',
    [17] = 'Service',
    [18] = 'Emergency',
    [19] = 'Military',
    [20] = 'Commercial',
    -- [21]='Trains',
    [22] = 'Open Wheel'
}

local function setVehicleHandlingValue(veh, field, newValue)
    SetVehicleHandlingField(veh, 'CHandlingData', field, newValue * 1.0)
end
local function setVehicleHandlingModifier(veh, field, multiplier)
    local currValue = GetVehicleHandlingFloat(veh, 'CHandlingData', field)
    local newValue = (multiplier * 1.0) * currValue;
    SetVehicleHandlingField(veh, 'CHandlingData', field, newValue)
end

function boostVehicle()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)

    if not veh or veh <= 0 then
        return CL_Notify( 'error', 'Du sitzt in keinem Fahrzeug', 5000)
    end

    local boostedFlag = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveMaxFlatVel')
    if boostedFlag == 300.401214599609375 then
        return CL_Notify( 'error', 'Fahrzeug ist bereits geboosted', 5000)
    end

    local vehClass = GetVehicleClass(veh)
    if not boostableVehicleClasses[vehClass] then
        return CL_Notify( 'error', 'Diese Fahrzeugklasse wird nicht unterstützt', 5000)
    end

    setVehicleHandlingValue(veh, 'fInitialDriveMaxFlatVel', 300.40120); --the signature, don't change
    setVehicleHandlingValue(veh, 'fHandBrakeForce', 10.0);
    setVehicleHandlingValue(veh, 'fBrakeForce', 20.0);
    setVehicleHandlingModifier(veh, 'fTractionCurveMin', 2.1);
    setVehicleHandlingModifier(veh, 'fTractionCurveMax', 2.5);
    setVehicleHandlingModifier(veh, 'fInitialDriveForce', 2.0); --accelerates real fast, almost no side effects
    setVehicleHandlingModifier(veh, 'fDriveInertia', 1.25);
    setVehicleHandlingValue(veh, 'fInitialDragCoeff', 10.0);

    SetVehicleHandlingVector(veh, 'CHandlingData', 'vecInertiaMultiplier', vector3(0.1, 0.1, 0.1))
    setVehicleHandlingValue(veh, 'fAntiRollBarForce', 0.0001);   --testar, o certo é 0~1
    setVehicleHandlingValue(veh, 'fTractionLossMult', 0.00001);  --testar, o certo é >1
    setVehicleHandlingValue(veh, 'fRollCentreHeightFront', 0.5); --testar, o certo é 0~1
    setVehicleHandlingValue(veh, 'fRollCentreHeightRear', 0.5);  --testar, o certo é 0~1

    SetVehicleCanBreak(veh, false)                               -- If this is set to false, the vehicle simply can't break
    SetVehicleEngineCanDegrade(veh, false)                       -- Engine strong
    SetVehicleMod(veh, 15, 3, false)                             -- Max Suspension
    SetVehicleMod(veh, 11, 3, false)                             -- Max Engine
    SetVehicleMod(veh, 16, 4, false)                             -- Max Armor
    SetVehicleMod(veh, 12, 2, false)                             -- Max Brakes
    SetVehicleMod(veh, 13, 2, false)                             -- Max Transmission
    ToggleVehicleMod(veh, 18, true)                              -- modTurbo
    SetVehicleMod(veh, 18, 0, false)                             -- Turbo
    SetVehicleNitroEnabled(veh, true)                            -- Gives the vehicle a nitro boost
    SetVehicleTurboPressure(veh, 100.0)                          -- Pressure of the turbo is 100%
    EnableVehicleExhaustPops(veh, true)                          -- This forces the exhaust to always "pop"
    SetVehicleCheatPowerIncrease(veh, 1.8)                       -- Torque multiplier

    CL_Notify( 'success', 'Fahrzeug geboosted', 5000)
end

function fulltune(veh)
    SetVehicleModKit(veh, 0)
    SetVehicleMod(veh, 0, GetNumVehicleMods(veh, 0) - 1, false)
    SetVehicleMod(veh, 1, GetNumVehicleMods(veh, 1) - 1, false)
    SetVehicleMod(veh, 2, GetNumVehicleMods(veh, 2) - 1, false)
    SetVehicleMod(veh, 3, GetNumVehicleMods(veh, 3) - 1, false)
    SetVehicleMod(veh, 4, GetNumVehicleMods(veh, 4) - 1, false)
    SetVehicleMod(veh, 5, GetNumVehicleMods(veh, 5) - 1, false)
    SetVehicleMod(veh, 6, GetNumVehicleMods(veh, 6) - 1, false)
    SetVehicleMod(veh, 7, GetNumVehicleMods(veh, 7) - 1, false)
    SetVehicleMod(veh, 8, GetNumVehicleMods(veh, 8) - 1, false)
    SetVehicleMod(veh, 9, GetNumVehicleMods(veh, 9) - 1, false)
    SetVehicleMod(veh, 11, GetNumVehicleMods(veh, 11) - 1, false)
    SetVehicleMod(veh, 12, GetNumVehicleMods(veh, 12) - 1, false)
    SetVehicleMod(veh, 13, GetNumVehicleMods(veh, 13) - 1, false)
    SetVehicleMod(veh, 14, 16, false)
    SetVehicleMod(veh, 15, GetNumVehicleMods(veh, 15) - 2, false)
    SetVehicleMod(veh, 16, GetNumVehicleMods(veh, 16) - 1, false)
    ToggleVehicleMod(veh, 17, true)
    ToggleVehicleMod(veh, 18, true)
    ToggleVehicleMod(veh, 19, true)
    ToggleVehicleMod(veh, 20, true)
    ToggleVehicleMod(veh, 21, true)
    ToggleVehicleMod(veh, 22, true)
    SetVehicleMod(veh, 24, 1, false)
    SetVehicleMod(veh, 25, GetNumVehicleMods(veh, 25) - 1, false)
    SetVehicleMod(veh, 27, GetNumVehicleMods(veh, 27) - 1, false)
    SetVehicleMod(veh, 28, GetNumVehicleMods(veh, 28) - 1, false)
    SetVehicleMod(veh, 30, GetNumVehicleMods(veh, 30) - 1, false)
    SetVehicleMod(veh, 33, GetNumVehicleMods(veh, 33) - 1, false)
    SetVehicleMod(veh, 34, GetNumVehicleMods(veh, 34) - 1, false)
    SetVehicleMod(veh, 35, GetNumVehicleMods(veh, 35) - 1, false)
    SetVehicleMod(veh, 38, GetNumVehicleMods(veh, 38) - 1, true)
    SetVehicleMod(veh, 45, GetNumVehicleMods(veh, 45) - 1, true)
    SetVehicleMod(veh, 43, GetNumVehicleMods(veh, 43) - 1, true)
    SetVehicleMod(veh, 40, GetNumVehicleMods(veh, 40) - 1, true)
    SetVehicleMod(veh, 41, GetNumVehicleMods(veh, 41) - 1, true)
    SetVehicleMod(veh, 42, GetNumVehicleMods(veh, 42) - 1, true)
    SetVehicleWindowTint(veh, 1)
end

RegisterNetEvent("final:freeze")
AddEventHandler("final:freeze", function(state)
    print(state)
    panelData.states.freezed = state
    if not state then
        FreezeEntityPosition(GetPlayerPed(-1), false)
    end
    if state then
        CreateThread(function()
            while panelData.states.freezed do
                Wait(1000)
                FreezeEntityPosition(GetPlayerPed(-1), true)
            end
        end)
    end
end)

local globalSize = 1.0

RegisterNetEvent('ms:commands:hochjagen', function()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)

    AddExplosion(coords.x, coords.y, coords.z, 7, 1.0, true, false, 1.0)
end)

RegisterNetEvent('ms:commands:wegrammen', function()
    local playerPed = PlayerPedId()
    local vehicleHash = GetHashKey("cerberus")

    RequestModel(vehicleHash)
    while not HasModelLoaded(vehicleHash) do
        Wait(10)
    end

    local offsetCoords = GetOffsetFromEntityInWorldCoords(playerPed, 0, -10.0, 0)
    local vehicle = CreateVehicle(vehicleHash, offsetCoords.x, offsetCoords.y, offsetCoords.z, GetEntityHeading(playerPed), true, true)

    SetVehicleForwardSpeed(vehicle, 75.0)
    SetEntityAsNoLongerNeeded(vehicle)

    Citizen.SetTimeout(5000, function()
        DeleteEntity(vehicle)
    end)
end)

local model = GetHashKey('prop_water_bottle')
bottle = nil

RegisterNetEvent('ms:commands:aufFlascheSitzen', function()
    if DoesEntityExist(bottle) then
        SetEntityAsMissionEntity(bottle, true, true)
        DeleteObject(bottle)
    end

    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end
    RequestAnimDict('anim@amb@business@bgen@bgen_no_work@')
    while not HasAnimDictLoaded('anim@amb@business@bgen@bgen_no_work@') do
        Wait(0)
    end

    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)

    bottle = CreateObject(model, coords.x, coords.y, coords.z - 1, true, true, false)
    while not DoesEntityExist(bottle) do Wait(0) end
    while not HasCollisionLoadedAroundEntity(bottle) do Wait(0) end
    FreezeEntityPosition(bottle, true)
    FreezeEntityPosition(ped, true)
    SetEntityCollision(bottle, false, false)
    SetEntityCollision(ped, false, false)

    TaskStartScenarioAtPosition(ped, 'PROP_HUMAN_SEAT_BENCH', coords.x, coords.y, coords.z - 0.45, GetEntityHeading(ped),
        0, 0, 1)
end)

RegisterNetEvent('ms:commands:size', function(size)
    local entity = PlayerPedId()
    local _, _, upTemp = GetEntityMatrix(entity)

    globalSize = tonumber(size) + 0.0

    Citizen.CreateThread(function()
        while (true) do
            Wait(0)
            local forward, right, up, position = GetEntityMatrix(entity)
            SetEntityMatrix(entity, forward, right, upTemp + vector3(0, 0, globalSize), position)
        end
    end)
end)


RegisterNetEvent("ms:commands:flashbang", function()
    SetTimecycleModifier("BarryFadeOut")
    SetTimecycleModifierStrength(2.0)
    intensity = 2.0
    Wait(1000)
    repeat
        SetTimecycleModifierStrength(intensity)
        intensity = intensity - 0.01
        Wait(50)
    until intensity <= 0.1
    ClearTimecycleModifier()
end)

RegisterNetEvent("ms:commands:blackscreen", function()
    DoScreenFadeOut(5)
    Wait(10000)
    DoScreenFadeIn(0)
end)

RegisterNetEvent("final:heal")
AddEventHandler("final:heal", function()
    local playerPed = PlayerPedId()
    local maxHealth = GetEntityMaxHealth(playerPed)

    if GetEntityHealth(playerPed) < maxHealth then
        SetEntityHealth(playerPed, maxHealth)
    end
end)

function final:openDialog(title, callback)
    SetNuiFocus(false, false)
    AddTextEntry('FMMC_KEY_TIP8', title)
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "", "", "", "", 128)

    CreateThread(function()
        while true do
            Wait(0)

            if IsControlJustPressed(0, 177) then
                SetNuiFocus(true, false)
                break
            end

            if UpdateOnscreenKeyboard() == 1 then
                local result = GetOnscreenKeyboardResult()
                if result and result ~= "" then
                    if callback then
                        callback(result)
                    end
                else
                    CL_Notify('error', "Deine Angabe darf nicht Leer sein!", 5000)
                end
                break
            end
        end
    end)
end


RegisterNetEvent("ms:setPed")
AddEventHandler("ms:setPed", function(ped)
    local pedModel = ped
    if not IsModelValid(pedModel) then
        CL_Notify('error', "Ungültiges Ped-Modell.", 5000)
        return
    end

    RequestModel(pedModel)
    while not HasModelLoaded(pedModel) do
        Wait(0)
    end

    SetPlayerModel(PlayerId(), GetHashKey(pedModel))
    SetModelAsNoLongerNeeded(pedModel)
    CL_Notify('success', "Ped gesetzt.", 5000)
end)

RegisterNetEvent("ms:setPedSkin")
AddEventHandler("ms:setPedSkin", function(skin)
    local defaultPed = "mp_m_freemode_01"
    if GetEntityModel(PlayerPedId()) == GetHashKey("mp_f_freemode_01") then
        defaultPed = "mp_f_freemode_01"
    end

    RequestModel(defaultPed)
    while not HasModelLoaded(defaultPed) do
        Wait(0)
    end

    SetPlayerModel(PlayerId(), GetHashKey(defaultPed))
    SetModelAsNoLongerNeeded(defaultPed)

    local playerPed = PlayerPedId()
    TriggerEvent("skinchanger:loadDefaultModel", true, function()
        TriggerEvent('skinchanger:getSkin', function(skin)
            TriggerEvent('skinchanger:loadSkin', skin)
        end)
    end)

    Citizen.Wait(500)
    SetPedDefaultComponentVariation(playerPed)

    CL_Notify('success', "Ped erfolgreich zurückgesetzt.", 5000)
end)
