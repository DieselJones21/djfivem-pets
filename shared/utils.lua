function IsPetItem(itemName)
    return Config.Animals[itemName] ~= nil
end

function IsSupplyItem(itemName)
    return Config.Supplies[itemName] ~= nil
end

function IsK9Animal(animal)
    return animal and animal.k9 == true
end

function HasK9Trait(animal, trait)
    return IsK9Animal(animal) and animal.k9Traits and animal.k9Traits[trait] == true
end

function GetPlayerJobName(src)
    if Config.K9.getJob then
        return Config.K9.getJob(src)
    end
    if src then
        local ok, player = pcall(Player, src)
        if ok and player and player.state then
            local job = player.state.job
            if type(job) == 'table' then
                return job.name
            end
            if type(job) == 'string' then
                return job
            end
        end
    end
end

function IsK9Authorized(src)
    if not Config.K9 or not Config.K9.requireJob then
        return true
    end
    if src and IsPlayerAceAllowed(src, 'djfivem-pets.k9') then
        return true
    end
    local job = GetPlayerJobName(src)
    if not job then
        return false
    end
    job = job:lower()
    for i = 1, #(Config.K9.jobs or {}) do
        if Config.K9.jobs[i]:lower() == job then
            return true
        end
    end
    return false
end

function DefaultPetMetadata(itemName)
    local animal = Config.Animals[itemName]
    if not animal then return {} end

    local texture = 0
    if animal.textures and animal.textures > 0 then
        texture = math.random(0, animal.textures)
    end

    return {
        petId = GeneratePetId(),
        name = animal.label,
        species = itemName,
        health = 100,
        hunger = 100,
        thirst = 100,
        happiness = 80,
        bond = 0,
        level = 1,
        dead = false,
        collar = false,
        texture = texture,
        born = os.time(),
        lastUpdate = os.time(),
        description = ('%s named %s'):format(animal.label, animal.label),
    }
end

function GeneratePetId()
    local template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return template:gsub('[xy]', function(c)
        local v = (c == 'x') and math.random(0, 15) or math.random(8, 11)
        return ('%x'):format(v)
    end)
end

function Clamp(value, min, max)
    if value < min then return min end
    if value > max then return max end
    return value
end

function Round(value)
    return math.floor(value + 0.5)
end

function ApplyDecayToMetadata(meta, now)
    now = now or os.time()
    meta.lastUpdate = meta.lastUpdate or now

    if meta.dead then
        meta.lastUpdate = now
        return meta, false
    end

    local elapsed = now - meta.lastUpdate
    if elapsed < Config.Decay.interval then
        return meta, false
    end

    if not Config.Decay.offlineDecay then
        elapsed = math.min(elapsed, Config.Decay.interval)
    else
        elapsed = math.min(elapsed, Config.Decay.maxOfflineSeconds)
    end

    local ticks = math.floor(elapsed / Config.Decay.interval)
    if ticks <= 0 then
        return meta, false
    end

    meta.hunger = Clamp(meta.hunger - (Config.Decay.hunger * ticks), 0, 100)
    meta.thirst = Clamp(meta.thirst - (Config.Decay.thirst * ticks), 0, 100)
    meta.happiness = Clamp(meta.happiness - (Config.Decay.happiness * ticks), 0, 100)

    if meta.hunger <= 0 or meta.thirst <= 0 then
        meta.health = Clamp(meta.health - (Config.Decay.healthWhenStarving * ticks), 0, 100)
    end

    if meta.health <= 0 then
        if Config.Decay.offlineDeath or elapsed <= (Config.Decay.interval * 3) then
            meta.dead = true
            meta.health = 0
            meta.happiness = 0
        else
            meta.health = 1
        end
    end

    meta.lastUpdate = now
    UpdatePetDescription(meta)
    return meta, true
end

function UpdatePetDescription(meta)
    local animal = Config.Animals[meta.species]
    local species = animal and animal.label or 'Companion'
    local status = meta.dead and 'Deceased' or 'Alive'
    local collar = meta.collar and 'Collared' or 'No collar'
    meta.description = ('%s · %s · %s'):format(species, status, collar)
    meta.label = meta.name
end

function AgeInDays(meta)
    if not meta.born then return 0 end
    return math.max(0, math.floor((os.time() - meta.born) / 86400))
end

function ResolvePetItem(input)
    if type(input) ~= 'string' or input == '' then
        return nil
    end

    local raw = input:lower():gsub('%s+', '_'):gsub('-', '_')
    if Config.Animals[raw] then
        return raw
    end

    if not raw:find('^pet_') and Config.Animals['pet_' .. raw] then
        return 'pet_' .. raw
    end

    for name, animal in pairs(Config.Animals) do
        if animal.label:lower():gsub('%s+', '_') == raw then
            return name
        end
        if animal.modelName and animal.modelName:lower() == raw then
            return name
        end
        if name:gsub('^pet_', '') == raw then
            return name
        end
    end
end

function GetCatalog()
    local animals = {}
    for name, animal in pairs(Config.Animals) do
        animals[#animals + 1] = {
            name = name,
            label = animal.label,
            category = animal.category,
            rarity = animal.rarity,
            price = animal.price,
            canAttack = animal.canAttack == true,
            k9 = animal.k9 == true,
            k9Traits = animal.k9Traits,
            description = animal.description or '',
            image = ('images/%s.png'):format(name),
        }
    end
    table.sort(animals, function(a, b)
        if a.category == b.category then
            return a.price < b.price
        end
        return a.category < b.category
    end)

    local supplies = {}
    local order = { 'pet_food', 'pet_water', 'pet_collar', 'pet_leash', 'pet_revive' }
    for i = 1, #order do
        local name = order[i]
        local item = Config.Supplies[name]
        supplies[#supplies + 1] = {
            name = name,
            label = item.label,
            category = 'supplies',
            rarity = 'common',
            price = item.price,
            canAttack = false,
            description = item.description or '',
            image = ('images/%s.png'):format(name),
        }
    end

    return {
        animals = animals,
        supplies = supplies,
        categories = Config.Categories,
        shopName = Config.Shop.name,
        currency = Config.Shop.currency.item,
    }
end

function GetItemPrice(itemName)
    if Config.Animals[itemName] then
        return Config.Animals[itemName].price
    end
    if Config.Supplies[itemName] then
        return Config.Supplies[itemName].price
    end
end
