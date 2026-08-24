local function petOptions()
    return {
        {
            name = 'djfivem_pets_pet',
            icon = 'fa-solid fa-hand',
            label = 'Pet',
            distance = Config.InteractDistance,
            onSelect = function()
                TriggerServerEvent('djfivem-pets:server:action', { action = 'pet' })
            end,
        },
        {
            name = 'djfivem_pets_feed',
            icon = 'fa-solid fa-bowl-food',
            label = 'Feed',
            distance = Config.InteractDistance,
            onSelect = function()
                TriggerServerEvent('djfivem-pets:server:action', { action = 'feed' })
            end,
        },
        {
            name = 'djfivem_pets_water',
            icon = 'fa-solid fa-bottle-water',
            label = 'Give water',
            distance = Config.InteractDistance,
            onSelect = function()
                TriggerServerEvent('djfivem-pets:server:action', { action = 'water' })
            end,
        },
        {
            name = 'djfivem_pets_walk',
            icon = 'fa-solid fa-dog',
            label = 'Walk',
            distance = Config.InteractDistance,
            canInteract = function()
                return IsLocalPetOut() and not LocalPet.walking
            end,
            onSelect = function()
                TriggerServerEvent('djfivem-pets:server:action', { action = 'walk' })
            end,
        },
        {
            name = 'djfivem_pets_unwalk',
            icon = 'fa-solid fa-link-slash',
            label = 'End walk',
            distance = Config.InteractDistance,
            canInteract = function()
                return IsLocalPetOut() and LocalPet.walking
            end,
            onSelect = function()
                TriggerServerEvent('djfivem-pets:server:action', { action = 'unwalk' })
            end,
        },
        {
            name = 'djfivem_pets_sit',
            icon = 'fa-solid fa-chair',
            label = 'Sit',
            distance = Config.InteractDistance,
            onSelect = function()
                TriggerServerEvent('djfivem-pets:server:action', { action = 'sit' })
            end,
        },
        {
            name = 'djfivem_pets_follow',
            icon = 'fa-solid fa-person-walking',
            label = 'Follow',
            distance = Config.InteractDistance,
            onSelect = function()
                TriggerServerEvent('djfivem-pets:server:action', { action = 'follow' })
            end,
        },
        {
            name = 'djfivem_pets_attack',
            icon = 'fa-solid fa-skull',
            label = 'Attack target',
            distance = Config.InteractDistance,
            canInteract = function()
                local animal = LocalPet.species and Config.Animals[LocalPet.species]
                return animal and animal.canAttack
            end,
            onSelect = function()
                TriggerServerEvent('djfivem-pets:server:action', { action = 'attack' })
            end,
        },
        {
            name = 'djfivem_pets_menu',
            icon = 'fa-solid fa-paw',
            label = 'Pet menu',
            distance = Config.InteractDistance,
            onSelect = function()
                OpenPetMenu()
            end,
        },
    }
end

function AddPetTarget(ped)
    if not Config.Target.useOxTarget then return end
    if GetResourceState('ox_target') ~= 'started' then return end
    exports.ox_target:addLocalEntity(ped, petOptions())
end

CreateThread(function()
    if Config.Target.useOxTarget then return end

    while true do
        local sleep = 800
        if IsLocalPetOut() then
            local dist = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(LocalPet.ped))
            if dist <= Config.InteractDistance then
                sleep = 0
                BeginTextCommandDisplayHelp('STRING')
                AddTextComponentSubstringPlayerName('Press ~INPUT_CONTEXT~ to open the pet menu')
                EndTextCommandDisplayHelp(0, false, false, -1)
                if IsControlJustPressed(0, 38) then
                    OpenPetMenu()
                end
            end
        end
        Wait(sleep)
    end
end)
