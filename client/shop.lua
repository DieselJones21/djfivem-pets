local shopPed = 0

local function spawnShop()
    if not Config.Shop.enabled then return end

    local model = Config.Shop.ped
    RequestModel(model)
    local timeout = GetGameTimer() + 5000
    while not HasModelLoaded(model) do
        if GetGameTimer() > timeout then return end
        Wait(10)
    end

    local c = Config.Shop.coords
    shopPed = CreatePed(4, model, c.x, c.y, c.z - 1.0, c.w, false, true)
    SetEntityInvincible(shopPed, true)
    SetBlockingOfNonTemporaryEvents(shopPed, true)
    FreezeEntityPosition(shopPed, true)
    SetPedDiesWhenInjured(shopPed, false)
    SetPedCanRagdollFromPlayerImpact(shopPed, false)
    if Config.Shop.scenario then
        TaskStartScenarioInPlace(shopPed, Config.Shop.scenario, 0, true)
    end
    SetModelAsNoLongerNeeded(model)

    if Config.Shop.blip.enabled then
        local blip = AddBlipForCoord(c.x, c.y, c.z)
        SetBlipSprite(blip, Config.Shop.blip.sprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, Config.Shop.blip.scale)
        SetBlipColour(blip, Config.Shop.blip.color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(Config.Shop.blip.label)
        EndTextCommandSetBlipName(blip)
    end

    if GetResourceState('ox_target') == 'started' then
        exports.ox_target:addLocalEntity(shopPed, {
            {
                name = 'djfivem_pets_shop',
                icon = 'fa-solid fa-shop',
                label = locale('shop_browse'),
                onSelect = function()
                    exports.ox_inventory:openInventory('shop', { type = 'djfivem_petstore' })
                end,
            },
        })
    else
        CreateThread(function()
            while DoesEntityExist(shopPed) do
                local sleep = 800
                local dist = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(shopPed))
                if dist < 2.2 then
                    sleep = 0
                    BeginTextCommandDisplayHelp('STRING')
                    AddTextComponentSubstringPlayerName('Press ~INPUT_CONTEXT~ to browse the pet store')
                    EndTextCommandDisplayHelp(0, false, false, -1)
                    if IsControlJustPressed(0, 38) then
                        exports.ox_inventory:openInventory('shop', { type = 'djfivem_petstore' })
                    end
                end
                Wait(sleep)
            end
        end)
    end
end

CreateThread(function()
    spawnShop()
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() and shopPed ~= 0 and DoesEntityExist(shopPed) then
        DeletePed(shopPed)
    end
end)
