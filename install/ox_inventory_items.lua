--[[
    Copy these entries into ox_inventory/data/items.lua
    Copy images from install/images/ into ox_inventory/web/images/
]]

local function petItem(label, weight)
    return {
        label = label,
        weight = weight,
        stack = false,
        close = true,
        consume = 0,
        server = { export = 'djfivem-pets.usePet' },
        client = { export = 'djfivem-pets.usePetClient' },
    }
end

local ITEMS = {
    pet_chop = petItem('Chop', 4200),
    pet_husky = petItem('Husky', 3600),
    pet_retriever = petItem('Retriever', 3400),
    pet_shepherd = petItem('German Shepherd', 3800),
    pet_dusa_doberman = petItem('Dusa Doberman', 3700),
    pet_westy = petItem('West Highland Terrier', 1400),
    pet_poodle = petItem('Poodle', 1800),
    pet_sphynx = petItem('Sphynx', 800),
    pet_cane = petItem('Cane Corso', 4500),
    pet_bulldog = petItem('English Bulldog', 3200),
    pet_aussiepup = petItem('Aussie Puppy', 1200),
    pet_dalmatian = petItem('Dalmatian', 3300),
    pet_dodo = petItem('Dodo', 2200),
    pet_fdpuppy = petItem('Frenchie Puppy', 1100),
    pet_husky_np = petItem('Husky NP', 3600),
    pet_lspd = petItem('LSPD K9', 4000),
    pet_pit = petItem('Pit Bull', 3500),
    pet_pitpup = petItem('Pit Bull Puppy', 1300),
    pet_raccoon = petItem('Raccoon', 900),
    pet_retriever_np = petItem('Retriever NP', 3400),
    pet_rotpuppy = petItem('Rottweiler Puppy', 1500),
    pet_shepherd_np = petItem('Shepherd NP', 3800),
    pet_bostonpup = petItem('Boston Terrier Puppy', 1000),
    pet_boxerpup = petItem('Boxer Puppy', 1200),
    pet_capybara = petItem('Capybara', 5500),
    pet_piglet = petItem('Piglet', 1800),
    pet_blackbear = petItem('Black Bear', 8000),
    pet_donkey = petItem('Donkey', 7000),
    pet_goat = petItem('Goat', 4000),
    pet_honeybadger = petItem('Honey Badger', 1800),
    pet_wolf = petItem('Wolf', 4200),
    pet_pig = petItem('Pig', 5000),
    pet_skunk = petItem('Skunk', 700),
    pet_turkey = petItem('Turkey', 1600),
    pet_chowchow = petItem('Chow Chow', 3100),
    pet_dalpup = petItem('Dalmatian Puppy', 1100),
    pet_doberman = petItem('Doberman', 3700),
    pet_dachshund = petItem('Longhair Dachshund', 1400),
    pet_reindeer = petItem('Reindeer', 7500),
    pet_robot = petItem('Zathura', 3000),
    pet_yorkie = petItem('Yorkshire Terrier Puppy', 700),
    pet_food = {
        label = 'Premium Kibble',
        weight = 200,
        stack = true,
        close = true,
        consume = 0,
        server = { export = 'djfivem-pets.useFood' },
    },
    pet_water = {
        label = 'Fresh Water',
        weight = 200,
        stack = true,
        close = true,
        consume = 0,
        server = { export = 'djfivem-pets.useWater' },
    },
    pet_collar = {
        label = 'Leather Collar',
        weight = 80,
        stack = true,
        close = true,
        consume = 0,
        server = { export = 'djfivem-pets.useCollar' },
    },
    pet_leash = {
        label = 'Walking Leash',
        weight = 120,
        stack = false,
        close = true,
        consume = 0,
        server = { export = 'djfivem-pets.useLeash' },
    },
    pet_revive = {
        label = 'Revive Kit',
        weight = 250,
        stack = true,
        close = true,
        consume = 0,
        server = { export = 'djfivem-pets.useRevive' },
    },
}

--[[
    Paste into ox_inventory/data/items.lua:

    ['pet_chop'] = {
        label = 'Chop',
        weight = 4200,
        stack = false,
        close = true,
        consume = 0,
        server = { export = 'djfivem-pets.usePet' },
        client = { export = 'djfivem-pets.usePetClient' },
    },
]]

return ITEMS
