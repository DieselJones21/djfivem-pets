Config = {}

Config.Debug = false
Config.MenuKey = 'F6'
Config.AttackKey = 'G'
Config.MaxSpawnedPets = 1
Config.Menu = {
    top = '2.2vh',
    right = '1.6vw',
    width = 332,
}

Config.CallCooldown = 1200
Config.ActionCooldown = 1200
Config.AttackCooldown = 8000
Config.FollowDistance = 2.2
Config.WalkFollowDistance = 1.4
Config.TeleportDistance = 42.0
Config.InteractDistance = 3.0
Config.PetsEnterVehicles = true
Config.AttackPlayers = false
Config.AttackTimeout = 16000

Config.Decay = {
    interval = 60,
    hunger = 1.1,
    thirst = 1.4,
    happiness = 0.45,
    healthWhenStarving = 2.2,
    offlineDecay = true,
    offlineDeath = false,
    maxOfflineSeconds = 86400,
}

Config.Needs = {
    feedAmount = 42,
    waterAmount = 48,
    petHappiness = 14,
    walkHappinessPerTick = 4,
    walkHungerCost = 3,
    walkThirstCost = 4,
    walkTick = 30,
    reviveHealth = 55,
    reviveHunger = 50,
    reviveThirst = 50,
    reviveHappiness = 35,
    bondPet = 4,
    bondFeed = 3,
    bondWalk = 5,
    bondPerLevel = 100,
    maxLevel = 10,
}

Config.Leash = {
    length = 3.6,
    type = 5,
}

Config.Target = {
    useOxTarget = true,
}

Config.Shop = {
    enabled = true,
    name = 'Pet Store',
    ped = `s_m_m_linecook`,
    scenario = 'WORLD_HUMAN_CLIPBOARD',
    coords = vec4(563.18, 2752.93, 42.88, 187.0),
    blip = {
        enabled = true,
        sprite = 273,
        color = 5,
        scale = 0.85,
        label = 'Pet Store',
    },
}

Config.ShopItems = {
    { name = 'pet_rottweiler', price = 8500 },
    { name = 'pet_shepherd', price = 9000 },
    { name = 'pet_husky', price = 8750 },
    { name = 'pet_retriever', price = 8000 },
    { name = 'pet_pug', price = 4500 },
    { name = 'pet_poodle', price = 5200 },
    { name = 'pet_chop', price = 12000 },
    { name = 'pet_cat', price = 3000 },
    { name = 'pet_rabbit', price = 2200 },
    { name = 'pet_pig', price = 3500 },
    { name = 'pet_monkey', price = 15000 },
    { name = 'pet_coyote', price = 11000 },
    { name = 'pet_mtlion', price = 18500 },
    { name = 'pet_food', price = 25 },
    { name = 'pet_water', price = 20 },
    { name = 'pet_collar', price = 150 },
    { name = 'pet_leash', price = 125 },
    { name = 'pet_revive', price = 750 },
}

-- item name -> animal definition
-- canAttack: dogs, monkey, coyote, and mountain lion can be sent after a target
-- dogAnims: Franklin/Chop petting clips (dogs only)
Config.Animals = {
    pet_rottweiler = {
        label = 'Rottweiler',
        model = `a_c_rottweiler`,
        canAttack = true,
        dogAnims = true,
        textures = 0,
        sitScenario = 'WORLD_DOG_SITTING_ROTTWEILER',
        barkScenario = 'WORLD_DOG_BARKING_ROTTWEILER',
        scale = 1.0,
        collar = { bone = 39317, offset = vec3(0.0, 0.0, -0.04), rot = vec3(0.0, 90.0, 0.0) },
    },
    pet_shepherd = {
        label = 'Shepherd',
        model = `a_c_shepherd`,
        canAttack = true,
        dogAnims = true,
        textures = 1,
        sitScenario = 'WORLD_DOG_SITTING_SHEPHERD',
        barkScenario = 'WORLD_DOG_BARKING_SHEPHERD',
        scale = 1.0,
        collar = { bone = 39317, offset = vec3(0.0, 0.0, -0.02), rot = vec3(0.0, 90.0, 0.0) },
    },
    pet_husky = {
        label = 'Husky',
        model = `a_c_husky`,
        canAttack = true,
        dogAnims = true,
        textures = 1,
        sitScenario = 'WORLD_DOG_SITTING_RETRIEVER',
        barkScenario = 'WORLD_DOG_BARKING_RETRIEVER',
        scale = 1.0,
        collar = { bone = 39317, offset = vec3(0.0, 0.0, -0.03), rot = vec3(0.0, 90.0, 0.0) },
    },
    pet_retriever = {
        label = 'Retriever',
        model = `a_c_retriever`,
        canAttack = true,
        dogAnims = true,
        textures = 1,
        sitScenario = 'WORLD_DOG_SITTING_RETRIEVER',
        barkScenario = 'WORLD_DOG_BARKING_RETRIEVER',
        scale = 1.0,
        collar = { bone = 39317, offset = vec3(0.0, 0.0, -0.03), rot = vec3(0.0, 90.0, 0.0) },
    },
    pet_pug = {
        label = 'Pug',
        model = `a_c_pug`,
        canAttack = true,
        dogAnims = true,
        textures = 1,
        sitScenario = 'WORLD_DOG_SITTING_TERRIER',
        barkScenario = 'WORLD_DOG_BARKING_SMALL',
        scale = 1.0,
        collar = { bone = 39317, offset = vec3(0.0, 0.02, -0.02), rot = vec3(0.0, 90.0, 0.0) },
    },
    pet_poodle = {
        label = 'Poodle',
        model = `a_c_poodle`,
        canAttack = true,
        dogAnims = true,
        textures = 0,
        sitScenario = 'WORLD_DOG_SITTING_TERRIER',
        barkScenario = 'WORLD_DOG_BARKING_SMALL',
        scale = 1.0,
        collar = { bone = 39317, offset = vec3(0.0, 0.02, -0.02), rot = vec3(0.0, 90.0, 0.0) },
    },
    pet_chop = {
        label = 'Chop',
        model = `a_c_chop`,
        canAttack = true,
        dogAnims = true,
        textures = 0,
        sitScenario = 'WORLD_DOG_SITTING_ROTTWEILER',
        barkScenario = 'WORLD_DOG_BARKING_ROTTWEILER',
        scale = 1.0,
        collar = { bone = 39317, offset = vec3(0.0, 0.0, -0.04), rot = vec3(0.0, 90.0, 0.0) },
    },
    pet_cat = {
        label = 'Cat',
        model = `a_c_cat_01`,
        canAttack = false,
        textures = 2,
        sitScenario = 'WORLD_CAT_SLEEPING_GROUND',
        barkScenario = nil,
        scale = 1.0,
        collar = { bone = 39317, offset = vec3(0.0, 0.0, -0.02), rot = vec3(0.0, 90.0, 0.0) },
    },
    pet_rabbit = {
        label = 'Rabbit',
        model = `a_c_rabbit_01`,
        canAttack = false,
        textures = 0,
        sitScenario = nil,
        barkScenario = nil,
        scale = 1.0,
        collar = { bone = 39317, offset = vec3(0.0, 0.02, 0.0), rot = vec3(0.0, 90.0, 0.0) },
    },
    pet_pig = {
        label = 'Pig',
        model = `a_c_pig`,
        canAttack = false,
        textures = 1,
        sitScenario = nil,
        barkScenario = nil,
        scale = 1.0,
        collar = { bone = 24818, offset = vec3(0.0, 0.12, 0.0), rot = vec3(0.0, 90.0, 0.0) },
    },
    pet_monkey = {
        label = 'Monkey',
        model = `a_c_chimp`,
        canAttack = true,
        textures = 0,
        sitScenario = nil,
        barkScenario = nil,
        scale = 1.0,
        collar = { bone = 39317, offset = vec3(0.0, 0.02, 0.0), rot = vec3(0.0, 90.0, 0.0) },
    },
    pet_coyote = {
        label = 'Coyote',
        model = `a_c_coyote`,
        canAttack = true,
        textures = 0,
        sitScenario = nil,
        barkScenario = 'WORLD_COYOTE_HOWL',
        scale = 1.0,
        collar = { bone = 39317, offset = vec3(0.0, 0.0, -0.02), rot = vec3(0.0, 90.0, 0.0) },
    },
    pet_mtlion = {
        label = 'Mountain Lion',
        model = `a_c_mtlion`,
        canAttack = true,
        textures = 0,
        sitScenario = 'WORLD_MOUNTAIN_LION_REST',
        barkScenario = nil,
        scale = 1.0,
        collar = { bone = 39317, offset = vec3(0.0, 0.02, -0.04), rot = vec3(0.0, 90.0, 0.0) },
    },
}

Config.SupplyItems = {
    food = 'pet_food',
    water = 'pet_water',
    collar = 'pet_collar',
    leash = 'pet_leash',
    revive = 'pet_revive',
}

Config.Anims = {
    petOwner = { dict = 'creatures@rottweiler@tricks@', clip = 'petting_franklin', duration = 3500 },
    petDog = { dict = 'creatures@rottweiler@tricks@', clip = 'petting_chop', duration = 3500 },
    feedOwner = { dict = 'mp_common', clip = 'givetake1_a', duration = 1800 },
}
