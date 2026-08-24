function IsPetItem(itemName)
    return Config.Animals[itemName] ~= nil
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
    local species = animal and animal.label or 'Pet'
    local status = meta.dead and 'Deceased' or 'Alive'
    local collar = meta.collar and 'Collared' or 'No collar'
    meta.description = ('%s · %s · %s'):format(species, status, collar)
    meta.label = meta.name
end

function AgeInDays(meta)
    if not meta.born then return 0 end
    return math.max(0, math.floor((os.time() - meta.born) / 86400))
end
