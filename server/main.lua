local Spawned = {}
local Cooldown = {}
local LastHealthWrite = {}

math.randomseed(os.time())

local function notify(src, nType, key, ...)
    lib.notify(src, {
        title = locale('resource_name'),
        description = locale(key, ...),
        type = nType or 'inform',
    })
end

local function onCooldown(src, name, ms)
    Cooldown[src] = Cooldown[src] or {}
    local now = GetGameTimer()
    if Cooldown[src][name] and now < Cooldown[src][name] then
        return true
    end
    Cooldown[src][name] = now + (ms or Config.ActionCooldown)
    return false
end

local function getItems(src)
    return exports.ox_inventory:GetInventoryItems(src) or {}
end

local function countItem(src, name)
    local count = exports.ox_inventory:Search(src, 'count', name)
    if type(count) == 'table' then
        local total = 0
        for _, value in pairs(count) do
            total = total + (tonumber(value) or 0)
        end
        return total
    end
    return tonumber(count) or 0
end

local function saveMeta(src, slot, meta)
    UpdatePetDescription(meta)
    meta.lastUpdate = os.time()
    exports.ox_inventory:SetMetadata(src, slot, meta)
end

local function ensureMeta(src, slot, item)
    local meta = item.metadata or {}
    if not meta.petId then
        meta = DefaultPetMetadata(item.name)
        saveMeta(src, slot, meta)
        item.metadata = meta
        return meta
    end
    local changed
    meta, changed = ApplyDecayToMetadata(meta)
    if changed then
        saveMeta(src, slot, meta)
        item.metadata = meta
    end
    return meta
end

local function findPetById(src, petId)
    for slot, item in pairs(getItems(src)) do
        if item and IsPetItem(item.name) then
            local meta = ensureMeta(src, slot, item)
            if meta.petId == petId then
                return slot, item, meta
            end
        end
    end
end

local function findFirstPet(src, deadOnly)
    for slot, item in pairs(getItems(src)) do
        if item and IsPetItem(item.name) then
            local meta = ensureMeta(src, slot, item)
            if not deadOnly or meta.dead then
                return slot, item, meta
            end
        end
    end
end

local function addBond(meta, amount)
    meta.level = meta.level or 1
    meta.bond = meta.bond or 0
    if meta.level >= Config.Needs.maxLevel then
        meta.bond = Config.Needs.bondPerLevel
        return
    end
    meta.bond = meta.bond + amount
    while meta.bond >= Config.Needs.bondPerLevel and meta.level < Config.Needs.maxLevel do
        meta.bond = meta.bond - Config.Needs.bondPerLevel
        meta.level = meta.level + 1
    end
end

local function supplies(src)
    return {
        food = countItem(src, Config.SupplyItems.food),
        water = countItem(src, Config.SupplyItems.water),
        collar = countItem(src, Config.SupplyItems.collar),
        leash = countItem(src, Config.SupplyItems.leash),
        revive = countItem(src, Config.SupplyItems.revive),
    }
end

local function serialize(src, item, meta)
    local animal = Config.Animals[item.name] or {}
    local spawned = Spawned[src]
    local isOut = spawned and spawned.petId == meta.petId or false
    return {
        petId = meta.petId,
        name = meta.name or animal.label,
        species = item.name,
        speciesLabel = animal.label or item.label or item.name,
        canAttack = animal.canAttack == true,
        dead = meta.dead == true,
        collar = meta.collar == true,
        spawned = isOut,
        walking = isOut and spawned.walking or false,
        sitting = false,
        health = Round(meta.health or 0),
        hunger = Round(meta.hunger or 0),
        thirst = Round(meta.thirst or 0),
        happiness = Round(meta.happiness or 0),
        bond = Round(meta.bond or 0),
        level = meta.level or 1,
        ageDays = AgeInDays(meta),
        texture = meta.texture or 0,
    }
end

local function listPets(src)
    local pets = {}
    for slot, item in pairs(getItems(src)) do
        if item and IsPetItem(item.name) then
            local meta = ensureMeta(src, slot, item)
            pets[#pets + 1] = serialize(src, item, meta)
        end
    end
    table.sort(pets, function(a, b)
        return a.name:lower() < b.name:lower()
    end)
    return pets
end

local function refresh(src, petId)
    TriggerClientEvent('djfivem-pets:client:refreshMenu', src, petId)
end

local function forceDespawn(src)
    Spawned[src] = nil
    TriggerClientEvent('djfivem-pets:client:forceDespawn', src)
end

local function tooFar(src)
    local spawned = Spawned[src]
    if not spawned or not spawned.netId then return true end
    local playerPed = GetPlayerPed(src)
    local entity = NetworkGetEntityFromNetworkId(spawned.netId)
    if not playerPed or playerPed == 0 then return true end
    if not entity or entity == 0 then return false end
    return #(GetEntityCoords(playerPed) - GetEntityCoords(entity)) > (Config.InteractDistance + 2.0)
end

local function killPet(src, slot, item, meta, reason)
    meta.dead = true
    meta.health = 0
    meta.happiness = 0
    saveMeta(src, slot, meta)
    if Spawned[src] and Spawned[src].petId == meta.petId then
        forceDespawn(src)
    end
    notify(src, 'error', reason == 'injury' and 'pet_died_injury' or 'pet_died_needs', meta.name)
    refresh(src, meta.petId)
end

local function togglePet(src, item, slot)
    if onCooldown(src, 'call', Config.CallCooldown) then
        notify(src, 'error', 'busy')
        return
    end

    local meta = ensureMeta(src, slot, item)
    if meta.dead then
        notify(src, 'error', 'pet_dead', meta.name)
        return
    end

    local spawned = Spawned[src]
    if spawned then
        if spawned.petId == meta.petId then
            lib.callback.await('djfivem-pets:despawnPet', src)
            Spawned[src] = nil
            notify(src, 'inform', 'pet_recalled', meta.name)
            refresh(src, meta.petId)
            return
        end
        notify(src, 'error', 'pet_already_out')
        return
    end

    local netId = lib.callback.await('djfivem-pets:spawnPet', src, meta)
    if not netId then
        notify(src, 'error', 'action_failed')
        return
    end

    Spawned[src] = { petId = meta.petId, netId = netId, walking = false }
    notify(src, 'success', 'pet_called', meta.name)
    refresh(src, meta.petId)
end

local function requireSpawned(src, meta)
    local spawned = Spawned[src]
    if not spawned or spawned.petId ~= meta.petId then
        notify(src, 'error', 'pet_not_out')
        return false
    end
    if meta.dead then
        notify(src, 'error', 'pet_dead', meta.name)
        return false
    end
    return spawned
end

local Actions = {}

function Actions.toggle(src, slot, item, meta)
    togglePet(src, item, slot)
end

function Actions.pet(src, slot, item, meta)
    if not requireSpawned(src, meta) then return end
    if tooFar(src) then
        notify(src, 'error', 'pet_too_far', meta.name)
        return
    end
    meta.happiness = Clamp(meta.happiness + Config.Needs.petHappiness, 0, 100)
    addBond(meta, Config.Needs.bondPet)
    saveMeta(src, slot, meta)
    TriggerClientEvent('djfivem-pets:client:playPet', src)
    notify(src, 'success', 'petted', meta.name)
    refresh(src, meta.petId)
end

function Actions.feed(src, slot, item, meta)
    if not requireSpawned(src, meta) then return end
    if tooFar(src) then
        notify(src, 'error', 'pet_too_far', meta.name)
        return
    end
    if countItem(src, Config.SupplyItems.food) < 1 then
        notify(src, 'error', 'need_food')
        return
    end
    if not exports.ox_inventory:RemoveItem(src, Config.SupplyItems.food, 1) then
        notify(src, 'error', 'need_food')
        return
    end
    meta.hunger = Clamp(meta.hunger + Config.Needs.feedAmount, 0, 100)
    meta.happiness = Clamp(meta.happiness + 6, 0, 100)
    addBond(meta, Config.Needs.bondFeed)
    saveMeta(src, slot, meta)
    TriggerClientEvent('djfivem-pets:client:playFeed', src)
    notify(src, 'success', 'fed', meta.name)
    refresh(src, meta.petId)
end

function Actions.water(src, slot, item, meta)
    if not requireSpawned(src, meta) then return end
    if tooFar(src) then
        notify(src, 'error', 'pet_too_far', meta.name)
        return
    end
    if countItem(src, Config.SupplyItems.water) < 1 then
        notify(src, 'error', 'need_water')
        return
    end
    if not exports.ox_inventory:RemoveItem(src, Config.SupplyItems.water, 1) then
        notify(src, 'error', 'need_water')
        return
    end
    meta.thirst = Clamp(meta.thirst + Config.Needs.waterAmount, 0, 100)
    meta.happiness = Clamp(meta.happiness + 4, 0, 100)
    saveMeta(src, slot, meta)
    TriggerClientEvent('djfivem-pets:client:playFeed', src)
    notify(src, 'success', 'watered', meta.name)
    refresh(src, meta.petId)
end

function Actions.collar(src, slot, item, meta)
    if not requireSpawned(src, meta) then return end
    if tooFar(src) then
        notify(src, 'error', 'pet_too_far', meta.name)
        return
    end
    if meta.collar then
        notify(src, 'inform', 'already_collared', meta.name)
        return
    end
    if countItem(src, Config.SupplyItems.collar) < 1 then
        notify(src, 'error', 'need_collar_item')
        return
    end
    if not exports.ox_inventory:RemoveItem(src, Config.SupplyItems.collar, 1) then
        notify(src, 'error', 'need_collar_item')
        return
    end
    meta.collar = true
    saveMeta(src, slot, meta)
    TriggerClientEvent('djfivem-pets:client:collarAttached', src)
    notify(src, 'success', 'collar_on', meta.name)
    refresh(src, meta.petId)
end

function Actions.walk(src, slot, item, meta)
    if not requireSpawned(src, meta) then return end
    if meta.dead then
        notify(src, 'error', 'cannot_walk_dead')
        return
    end
    if not meta.collar then
        notify(src, 'error', 'need_collar_equipped', meta.name)
        return
    end
    if countItem(src, Config.SupplyItems.leash) < 1 then
        notify(src, 'error', 'need_leash')
        return
    end
    local veh = GetVehiclePedIsIn(GetPlayerPed(src), false)
    if veh and veh ~= 0 then
        notify(src, 'error', 'cannot_walk_vehicle')
        return
    end
    if Spawned[src].walking then
        notify(src, 'inform', 'already_walking')
        return
    end
    Spawned[src].walking = true
    TriggerClientEvent('djfivem-pets:client:startWalk', src)
    notify(src, 'success', 'walk_started', meta.name)
    refresh(src, meta.petId)
end

function Actions.unwalk(src, slot, item, meta)
    local spawned = Spawned[src]
    if not spawned or spawned.petId ~= meta.petId or not spawned.walking then
        notify(src, 'inform', 'not_walking')
        return
    end
    spawned.walking = false
    TriggerClientEvent('djfivem-pets:client:stopWalk', src)
    notify(src, 'inform', 'walk_ended')
    refresh(src, meta.petId)
end

function Actions.sit(src, slot, item, meta)
    if not requireSpawned(src, meta) then return end
    TriggerClientEvent('djfivem-pets:client:setSit', src, true)
    notify(src, 'inform', 'sit', meta.name)
end

function Actions.stay(src, slot, item, meta)
    if not requireSpawned(src, meta) then return end
    TriggerClientEvent('djfivem-pets:client:setStay', src, true)
    notify(src, 'inform', 'stay', meta.name)
end

function Actions.follow(src, slot, item, meta)
    if not requireSpawned(src, meta) then return end
    if Spawned[src].walking then
        Spawned[src].walking = false
        TriggerClientEvent('djfivem-pets:client:stopWalk', src)
    end
    TriggerClientEvent('djfivem-pets:client:setSit', src, false)
    TriggerClientEvent('djfivem-pets:client:setStay', src, false)
    notify(src, 'inform', 'follow', meta.name)
end

function Actions.attack(src, slot, item, meta)
    if onCooldown(src, 'attack', Config.AttackCooldown) then
        notify(src, 'error', 'attack_cooldown')
        return
    end
    if not requireSpawned(src, meta) then return end
    local animal = Config.Animals[item.name]
    if not animal or not animal.canAttack then
        notify(src, 'error', 'attack_not_dog', meta.name)
        return
    end
    local target = lib.callback.await('djfivem-pets:getAttackTarget', src)
    if not target then
        notify(src, 'error', 'attack_no_target')
        return
    end
    if target.isPlayer then
        if not Config.AttackPlayers then
            notify(src, 'error', 'attack_players_disabled')
            return
        end
        if target.serverId == src then
            notify(src, 'error', 'attack_no_target')
            return
        end
    end
    if Spawned[src].walking then
        Spawned[src].walking = false
        TriggerClientEvent('djfivem-pets:client:stopWalk', src)
    end
    TriggerClientEvent('djfivem-pets:client:attack', src, target)
    notify(src, 'warning', 'attack_started', meta.name)
end

function Actions.revive(src, slot, item, meta)
    if not meta.dead then
        notify(src, 'inform', 'not_dead', meta.name)
        return
    end
    if countItem(src, Config.SupplyItems.revive) < 1 then
        notify(src, 'error', 'need_revive')
        return
    end
    if not exports.ox_inventory:RemoveItem(src, Config.SupplyItems.revive, 1) then
        notify(src, 'error', 'need_revive')
        return
    end
    meta.dead = false
    meta.health = Config.Needs.reviveHealth
    meta.hunger = Config.Needs.reviveHunger
    meta.thirst = Config.Needs.reviveThirst
    meta.happiness = Config.Needs.reviveHappiness
    saveMeta(src, slot, meta)
    notify(src, 'success', 'revived', meta.name)
    refresh(src, meta.petId)
end

function Actions.rename(src, slot, item, meta, payload)
    local name = payload and payload.name
    if type(name) ~= 'string' then
        notify(src, 'error', 'invalid_name')
        return
    end
    name = name:gsub('^%s+', ''):gsub('%s+$', '')
    if #name < 2 or #name > 16 or name:find('[^%w%s%-]') then
        notify(src, 'error', 'invalid_name')
        return
    end
    meta.name = name
    saveMeta(src, slot, meta)
    notify(src, 'success', 'renamed', name)
    refresh(src, meta.petId)
end

local function runAction(src, payload)
    payload = payload or {}
    local action = payload.action
    if not action or not Actions[action] then return end
    if action ~= 'attack' and action ~= 'toggle' and onCooldown(src, 'action', Config.ActionCooldown) then
        notify(src, 'error', 'busy')
        return
    end

    local slot, item, meta
    if payload.petId then
        slot, item, meta = findPetById(src, payload.petId)
    elseif Spawned[src] then
        slot, item, meta = findPetById(src, Spawned[src].petId)
    else
        slot, item, meta = findFirstPet(src, action == 'revive')
    end

    if not slot then
        notify(src, 'error', 'missing_item')
        return
    end

    Actions[action](src, slot, item, meta, payload)
end

lib.callback.register('djfivem-pets:getMenuData', function(source, petId)
    local pets = listPets(source)
    local selected = petId
    if not selected or not petId then
        if Spawned[source] then
            selected = Spawned[source].petId
        elseif pets[1] then
            selected = pets[1].petId
        end
    end
    return {
        pets = pets,
        selected = selected,
        supplies = supplies(source),
        spawnedPetId = Spawned[source] and Spawned[source].petId or nil,
        walking = Spawned[source] and Spawned[source].walking or false,
    }
end)

RegisterNetEvent('djfivem-pets:server:action', function(payload)
    runAction(source, payload)
end)

RegisterNetEvent('djfivem-pets:server:setWalking', function(walking)
    local src = source
    if Spawned[src] then
        Spawned[src].walking = walking and true or false
    end
end)

RegisterNetEvent('djfivem-pets:server:petKilled', function()
    local src = source
    local spawned = Spawned[src]
    if not spawned then return end
    local slot, item, meta = findPetById(src, spawned.petId)
    if not slot then
        forceDespawn(src)
        return
    end
    if meta.dead then return end
    killPet(src, slot, item, meta, 'injury')
end)

RegisterNetEvent('djfivem-pets:server:syncHealth', function(mapped)
    local src = source
    local spawned = Spawned[src]
    if not spawned then return end
    mapped = tonumber(mapped)
    if not mapped then return end
    mapped = Clamp(mapped, 0, 100)
    local now = GetGameTimer()
    if LastHealthWrite[src] and (now - LastHealthWrite[src]) < 4000 and mapped > 0 then
        return
    end
    LastHealthWrite[src] = now
    local slot, item, meta = findPetById(src, spawned.petId)
    if not slot then return end
    if meta.dead then return end
    if mapped <= 0 then
        killPet(src, slot, item, meta, 'injury')
        return
    end
    if math.abs((meta.health or 100) - mapped) < 4 then return end
    meta.health = mapped
    saveMeta(src, slot, meta)
end)

local function useSupplyAction(src, action)
    if not Spawned[src] and action ~= 'revive' then
        notify(src, 'error', 'pet_not_out')
        return
    end
    runAction(src, { action = action })
end

exports('usePet', function(event, item, inventory, slot)
    if event ~= 'usingItem' then return end
    togglePet(inventory.id, item, slot)
end)

exports('useFood', function(event, item, inventory)
    if event ~= 'usingItem' then return end
    useSupplyAction(inventory.id, 'feed')
end)

exports('useWater', function(event, item, inventory)
    if event ~= 'usingItem' then return end
    useSupplyAction(inventory.id, 'water')
end)

exports('useCollar', function(event, item, inventory)
    if event ~= 'usingItem' then return end
    useSupplyAction(inventory.id, 'collar')
end)

exports('useLeash', function(event, item, inventory)
    if event ~= 'usingItem' then return end
    if not Spawned[inventory.id] then
        notify(inventory.id, 'error', 'pet_not_out')
        return
    end
    runAction(inventory.id, { action = 'walk' })
end)

exports('useRevive', function(event, item, inventory)
    if event ~= 'usingItem' then return end
    runAction(inventory.id, { action = 'revive' })
end)

local function registerHooks()
    exports.ox_inventory:registerHook('createItem', function(payload)
        if not payload or not payload.item or not IsPetItem(payload.item.name) then
            return
        end
        local metadata = payload.metadata or {}
        if metadata.petId then
            UpdatePetDescription(metadata)
            return metadata
        end
        return DefaultPetMetadata(payload.item.name)
    end)

    exports.ox_inventory:registerHook('swapItems', function(payload)
        local src = payload.source
        local spawned = Spawned[src]
        if not spawned then return end
        local fromItem = payload.fromSlot
        if type(fromItem) ~= 'table' then return end
        if not fromItem.metadata or fromItem.metadata.petId ~= spawned.petId then return end
        if payload.fromType == 'player' and payload.toType ~= 'player' then
            forceDespawn(src)
        elseif payload.fromType == 'player' and payload.toInventory ~= payload.fromInventory then
            forceDespawn(src)
        end
    end)
end

CreateThread(function()
    if Config.Shop.enabled then
        exports.ox_inventory:RegisterShop('djfivem_petstore', {
            name = Config.Shop.name,
            inventory = Config.ShopItems,
        })
    end
    registerHooks()
end)

CreateThread(function()
    while true do
        Wait(math.max(10, Config.Needs.walkTick) * 1000)
        for _, id in ipairs(GetPlayers()) do
            local src = tonumber(id)
            if src then
                for slot, item in pairs(getItems(src)) do
                    if item and IsPetItem(item.name) then
                        local meta = item.metadata or {}
                        if meta.petId then
                            local changed
                            meta, changed = ApplyDecayToMetadata(meta)
                            local spawned = Spawned[src]
                            if spawned and spawned.petId == meta.petId and spawned.walking and not meta.dead then
                                if countItem(src, Config.SupplyItems.leash) < 1 then
                                    spawned.walking = false
                                    TriggerClientEvent('djfivem-pets:client:stopWalk', src)
                                    notify(src, 'error', 'need_leash')
                                else
                                    meta.happiness = Clamp(meta.happiness + Config.Needs.walkHappinessPerTick, 0, 100)
                                    meta.hunger = Clamp(meta.hunger - Config.Needs.walkHungerCost, 0, 100)
                                    meta.thirst = Clamp(meta.thirst - Config.Needs.walkThirstCost, 0, 100)
                                    addBond(meta, Config.Needs.bondWalk)
                                    changed = true
                                end
                            end
                            if meta.dead and spawned and spawned.petId == meta.petId then
                                killPet(src, slot, item, meta, 'needs')
                            elseif changed then
                                saveMeta(src, slot, meta)
                                if spawned and spawned.petId == meta.petId then
                                    refresh(src, meta.petId)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

lib.addCommand('givepet', {
    help = locale('command_givepet'),
    restricted = 'group.admin',
    params = {
        { name = 'target', type = 'playerId', help = 'Player id' },
        { name = 'species', type = 'string', help = 'rottweiler, monkey, coyote, mtlion...' },
    },
}, function(source, args)
    local itemName = args.species:lower()
    local aliases = {
        mountainlion = 'pet_mtlion',
        mountain_lion = 'pet_mtlion',
        lion = 'pet_mtlion',
        chimp = 'pet_monkey',
        chimpanzee = 'pet_monkey',
    }
    if aliases[itemName] then
        itemName = aliases[itemName]
    elseif not itemName:find('^pet_') then
        itemName = 'pet_' .. itemName
    end
    if not Config.Animals[itemName] then
        notify(source, 'error', 'command_givepet_species')
        return
    end
    local meta = DefaultPetMetadata(itemName)
    if exports.ox_inventory:AddItem(args.target, itemName, 1, meta) then
        notify(source, 'success', 'command_givepet_done', meta.name, GetPlayerName(args.target) or tostring(args.target))
    else
        notify(source, 'error', 'action_failed')
    end
end)

AddEventHandler('playerDropped', function()
    local src = source
    Spawned[src] = nil
    Cooldown[src] = nil
    LastHealthWrite[src] = nil
end)
