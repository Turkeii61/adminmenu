local function generateUUID()
    local uuid = string.gsub('xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx', '[xy]', function(c)
        local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb);

        return string.format('%x', v);
    end);

    return uuid;
end
items = {}
local menu = {
    {
        id = generateUUID(),
        type = 'submenu',
        label = 'Administration',
        permType = 'group',
        IconComponent = 'Shield',
        checked = false,
        items = {
            {
                id = generateUUID(),
                type = 'checkbox',
                label = 'Admindienst',
                IconComponent = 'Key',
                checked = false,
            },
            {
                id = generateUUID(),
                type = 'checkbox',
                label = 'NoClip',
                IconComponent = 'Ban',
                checked = false,
            },
            {
                id = generateUUID(),
                type = 'checkbox',
                label = 'Godmode',
                IconComponent = 'Shield',
                checked = false,
            },
            {
                id = generateUUID(),
                type = 'checkbox',
                label = 'Nametags',
                IconComponent = 'ScanFace',
                checked = false,
            },
            {
                id = generateUUID(),
                type = 'checkbox',
                label = 'Vanish',
                IconComponent = 'EyeOff',
                checked = false,
            },
        },
    },
    {
        id = generateUUID(),
        type = 'submenu',
        label = 'Moderation',
        permType = 'group',
        IconComponent = 'Shield',
        checked = false,
        items = {
            {
                id = generateUUID(),
                type = 'button',
                label = 'Revive (ID)',
                IconComponent = 'Rocket',
            },
            {
                id = generateUUID(),
                type = 'button',
                label = 'Revive All',
                IconComponent = 'Rocket',
            },
            {
                id = generateUUID(),
                type = 'button',
                label = 'Heal (ID)',
                IconComponent = 'Rocket',
            },
            {
                id = generateUUID(),
                type = 'button',
                label = 'Inventar Löschen (ID)',
                IconComponent = 'Rocket',
            },
            {
                id = generateUUID(),
                type = 'button',
                label = 'Loadout Löschen (ID)',
                IconComponent = 'Rocket',
            },

        },
    },
    {
        id = generateUUID(),
        type = 'submenu',
        label = 'Fahrzeugfunktionen',
        permType = 'group',
        IconComponent = 'Car',
        checked = false,
        items = {
            {
                id = generateUUID(),
                type = 'button',
                label = 'Spawn Vehicle',
                IconComponent = 'Rocket',
            },
            {
                id = generateUUID(),
                type = 'button',
                label = 'Give Vehicle (Garage)',
                IconComponent = 'Rocket',
            },
            {
                id = generateUUID(),
                type = 'button',
                label = 'Boost',
                IconComponent = 'Rocket',
            },
            {
                id = generateUUID(),
                type = 'button',
                label = 'Fulltune',
                IconComponent = 'Rocket',
            },
            {
                id = generateUUID(),
                type = 'button',
                label = 'Reparieren',
                IconComponent = 'Repair',
            },
            {
                id = generateUUID(),
                type = 'button',
                label = 'Flip',
                IconComponent = 'Flip',
            },
            {
                id = generateUUID(),
                type = 'button',
                label = 'Löschen',
                IconComponent = 'Delete',
            },
        }
    },
    {
        id = generateUUID(),
        type = 'submenu',
        label = 'Development',
        permType = 'group',
        IconComponent = 'Shield',
        checked = false,
        items = {
            {
                id = generateUUID(),
                type = 'button',
                label = 'Dimension Setzen',
                IconComponent = 'Rocket',
            },
            {
                id = generateUUID(),
                type = 'button',
                label = 'Vector 3 Kopieren',
                IconComponent = 'Rocket',
            },
            {
                id = generateUUID(),
                type = 'button',
                label = 'Vector 4 Kopieren',
                IconComponent = 'Rocket',
            },

        }
    },
    {
        id = generateUUID(),
        type = 'submenu',
        label = 'Fraktionsmanagement',
        permType = 'group',
        IconComponent = 'Shield',
        checked = false,
        items = {
            {
                id = generateUUID(),
                type = 'button',
                label = 'Job Setzen (ID)',
                IconComponent = 'Rocket',
            },
            {
                id = generateUUID(),
                type = 'button',
                label = 'Fraktion auflösen',
                IconComponent = 'Rocket',
            },
            {
                id = generateUUID(),
                type = 'button',
                label = 'Fraktions Ankündigung',
                IconComponent = 'Rocket',
            },
            {
                id = generateUUID(),
                type = 'button',
                label = 'Fraktion bringen',
                IconComponent = 'Rocket',
            },
        }
    },
    {
        id = generateUUID(),
        type = 'submenu',
        label = 'Teammanagement',
        permType = 'group',
        IconComponent = 'Shield',
        checked = false,
        items = {
            {
                id = generateUUID(),
                type = 'button',
                label = 'Gruppe Setzen (ID)',
                IconComponent = 'Rocket',
            },
            {
                id = generateUUID(),
                type = 'button',
                label = 'Teamchat Nachricht',
                IconComponent = 'Rocket',
            },
            {
                id = generateUUID(),
                type = 'button',
                label = 'Team Belohnung',
                IconComponent = 'Rocket',
            },

        }
    },
    {
        id = generateUUID(),
        type = 'submenu',
        label = 'Umgebung',
        permType = 'group',
        IconComponent = 'Mountain',
        checked = false,
        items = {
            {
                id = generateUUID(),
                type = 'button',
                label = 'Fahrzeuge löschen',
                IconComponent = 'Car',
            },
            {
                id = generateUUID(),
                type = 'button',
                label = 'Peds löschen',
                IconComponent = 'User',
            },
            {
                id = generateUUID(),
                type = 'button',
                label = 'Props löschen',
                IconComponent = 'Fence',
            },
        }
    },
    {
        id = generateUUID(),
        type = 'submenu',
        label = 'Trollfunktionen',
        permType = 'group',
        IconComponent = 'Rabbit',
        checked = false,
        items = {
            {
                id = generateUUID(),
                type = 'button',
                label = 'Hochjagen',
                IconComponent = 'Bomb',
            },
            {
                id = generateUUID(),
                type = 'button',
                label = 'Wegrammen',
                IconComponent = 'Car',
            },
            {
                id = generateUUID(),
                type = 'button',
                label = 'Flasche sitzen',
                IconComponent = 'Cup',
            },
            {
                id = generateUUID(),
                type = 'button',
                label = 'Flashbang',
                IconComponent = 'Flash',
            },
            {
                id = generateUUID(),
                type = 'button',
                label = 'Blackscreen',
                IconComponent = 'FlashOff',
            },
            {
                id = generateUUID(),
                type = 'button',
                label = 'Ped Setzen (ID)',
                IconComponent = 'FlashOff',
            },
            {
                id = generateUUID(),
                type = 'button',
                label = 'Ped Zurücksetzen (ID)',
                IconComponent = 'FlashOff',
            },
        }
    },
    {
        id = generateUUID(),
        type = 'submenu',
        label = 'Rückerstattung',
        permType = 'group',
        IconComponent = 'Code',
        checked = false,
        items = {
            {
                id = generateUUID(),
                type = 'button',
                label = 'Geld',
                IconComponent = 'Cash',
            },
            {
                id = generateUUID(),
                type = 'button',
                label = 'Waffen',
                IconComponent = 'Axe',
            },
            {
                id = generateUUID(),
                type = 'button',
                label = 'Items',
                IconComponent = 'Box',
            },
        }
    },
    {
        id = generateUUID(),
        type = 'submenu',
        label = 'Ankündigungen',
        permType = 'group',
        IconComponent = 'Alert',
        checked = false,
        items = {
            {
                id = generateUUID(),
                type = 'button',
                label = 'Teamchat Nachricht',
                IconComponent = 'Send',
            },
            {
                id = generateUUID(),
                type = 'button',
                label = 'Announce',
                IconComponent = 'Alert',
            },
        }
    },
}

function final:openAdminPanel()
    SendNUIMessage({
        action = 'toggleAdminpanel',
        data = { state = true }
    })
    SendNUIMessage({
        action = 'updateServerName',
        data = { serverName = panelData.serverName }
    })

    SetNuiFocus(true, false)
    SetNuiFocusKeepInput(true)

    if (not panelData.state) then
        for k, v in pairs(menu) do
            if (ADMINPANEL.Catogories[v.label]) then
                for k1, v1 in pairs(ADMINPANEL.Catogories[v.label]) do
                    if (v.permType == 'group' and v1 == panelData.group) then
                        table.insert(items, v)
                    elseif (v.permType == 'identifier') then
                        local identifier = Player(GetPlayerServerId(PlayerId())).state['ESX_Identifier']
                        if (v1 == identifier) then
                            table.insert(items, v)
                        end
                    end
                end
            end
        end
    end

    SendNUIMessage({
        action = 'addItems',
        data = items
    })
    panelData.state = true
end

LAST_RESOURCE = nil;

local AUDIOS = {
OnSelect = {
    name = 'NAV_UP_DOWN',
    ref = 'HUD_FREEMODE_SOUNDSET'
},
onChange = {
    name = 'NAV_LEFT_RIGHT',
    ref = 'HUD_FRONTEND_DEFAULT_SOUNDSET'
},
onCheck = {
    name = 'NAV_LEFT_RIGHT',
    ref = 'HUD_FRONTEND_DEFAULT_SOUNDSET'
},
onClick = {
    name = 'SELECT',
    ref = 'HUD_FRONTEND_DEFAULT_SOUNDSET',
},
Exit = {
    name = 'BACK',
    ref = 'HUD_FRONTEND_DEFAULT_SOUNDSET'
}
};


exports('SendNUIMessage', function(message)
  local resource = GetInvokingResource();

  if not resource then
    return;
  end

  LAST_RESOURCE = resource;

  SendNUIMessage(message);
end);

exports('SetNuiFocus', SetNuiFocus);
exports('SetNuiFocusKeepInput', SetNuiFocusKeepInput);

for _, callback in next, {
'OnSelect',
'onChange',
'onCheck',
'onClick',
'Exit'
} do
RegisterNUICallback(callback, function(req, resp)


    local audio = AUDIOS[callback];

    PlaySoundFrontend(-1, audio.name, audio.ref, true)

    resp('OK');
end);
end

AddEventHandler('onResourceStop', function(resource)
if LAST_RESOURCE == resource then
    SendNUIMessage({ action = 'SetMenu' });
    SendNUIMessage({ action = 'SetItems' });
end
end);