local menuOpen = false

local function closeMenu()
    if not menuOpen then return end
    menuOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'close' })
end

local function pushMenu(data)
    menuOpen = true
    SetNuiFocus(true, true)
    SendNUIMessage({ action = 'open', data = data })
end

function OpenPetMenu(petId)
    local data = lib.callback.await('djfivem-pets:getMenuData', false, petId)
    if not data or not data.pets or #data.pets == 0 then
        lib.notify({
            title = locale('resource_name'),
            description = locale('no_pets'),
            type = 'error',
        })
        return
    end
    pushMenu(data)
end

local function refreshMenu(petId)
    if not menuOpen then return end
    local data = lib.callback.await('djfivem-pets:getMenuData', false, petId)
    if not data or not data.pets or #data.pets == 0 then
        closeMenu()
        return
    end
    SendNUIMessage({ action = 'update', data = data })
end

RegisterNetEvent('djfivem-pets:client:refreshMenu', function(petId)
    refreshMenu(petId)
end)

RegisterNUICallback('close', function(_, cb)
    closeMenu()
    cb({ ok = true })
end)

RegisterNUICallback('select', function(body, cb)
    refreshMenu(body and body.petId)
    cb({ ok = true })
end)

RegisterNUICallback('action', function(body, cb)
    local action = body and body.action
    local petId = body and body.petId
    if not action then
        cb({ ok = false })
        return
    end

    if action == 'rename' then
        SetNuiFocus(false, false)
        local input = lib.inputDialog(locale('resource_name'), {
            { type = 'input', label = 'Name', required = true, min = 2, max = 16 },
        })
        if input and input[1] then
            TriggerServerEvent('djfivem-pets:server:action', { action = 'rename', petId = petId, name = input[1] })
        end
        Wait(150)
        if menuOpen then
            SetNuiFocus(true, true)
            refreshMenu(petId)
        end
        cb({ ok = true })
        return
    end

    TriggerServerEvent('djfivem-pets:server:action', { action = action, petId = petId })
    SetTimeout(350, function()
        refreshMenu(petId)
    end)
    cb({ ok = true })
end)

lib.addKeybind({
    name = 'djfivem_petmenu',
    description = 'Open pet menu',
    defaultKey = Config.MenuKey,
    onPressed = function()
        if menuOpen then
            closeMenu()
        else
            OpenPetMenu()
        end
    end,
})

lib.addKeybind({
    name = 'djfivem_petattack',
    description = 'Pet attack',
    defaultKey = Config.AttackKey,
    onPressed = function()
        if not IsLocalPetOut() then return end
        TriggerServerEvent('djfivem-pets:server:action', { action = 'attack' })
    end,
})

RegisterCommand('petmenu', function()
    OpenPetMenu()
end, false)

RegisterNetEvent('djfivem-pets:client:openMenu', function()
    OpenPetMenu()
end)
