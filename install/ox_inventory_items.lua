--[[
    ox_inventory items — copy and paste ready

    1. Open ox_inventory/data/items.lua
    2. Paste from PASTE START to PASTE END into the return { } table
    3. Copy install/images/*.png into ox_inventory/web/images/
    4. Restart ox_inventory, then djfivem-pets

    Images must keep these filenames: pet_chop.png, pet_food.png, etc.
    Do not paste the comment markers. Do not wrap this in another return.
]]

    -- ======== PASTE START ========
    -- Police K9
    ['pet_lspd'] = {
        label = 'LSPD K9',
        weight = 4000,
        stack = false,
        close = true,
        consume = 0,
        description = 'LSPD issued K9. Search, guard, and takedown trained.',
        server = { export = 'djfivem-pets.usePet' },
        client = { export = 'djfivem-pets.usePetClient' },
    },

    ['pet_shepherd'] = {
        label = 'German Shepherd',
        weight = 3800,
        stack = false,
        close = true,
        consume = 0,
        description = 'The standard police shepherd. Tracks, holds, and takes a suspect down on command.',
        server = { export = 'djfivem-pets.usePet' },
        client = { export = 'djfivem-pets.usePetClient' },
    },

    ['pet_shepherd_np'] = {
        label = 'Shepherd NP',
        weight = 3800,
        stack = false,
        close = true,
        consume = 0,
        description = 'A sable patrol shepherd. Fast on a track and reliable on a bite command.',
        server = { export = 'djfivem-pets.usePet' },
        client = { export = 'djfivem-pets.usePetClient' },
    },

    ['pet_doberman'] = {
        label = 'Doberman',
        weight = 3700,
        stack = false,
        close = true,
        consume = 0,
        description = 'A patrol Doberman. Search, guard, and takedown certified.',
        server = { export = 'djfivem-pets.usePet' },
        client = { export = 'djfivem-pets.usePetClient' },
    },

    ['pet_dusa_doberman'] = {
        label = 'Dusa Doberman',
        weight = 3700,
        stack = false,
        close = true,
        consume = 0,
        description = 'A protection-line Doberman used for patrol and suspect apprehension.',
        server = { export = 'djfivem-pets.usePet' },
        client = { export = 'djfivem-pets.usePetClient' },
    },

    ['pet_cane'] = {
        label = 'Cane Corso',
        weight = 4500,
        stack = false,
        close = true,
        consume = 0,
        description = 'A heavy K9 mastiff. Holds ground, guards a perimeter, and does not back down.',
        server = { export = 'djfivem-pets.usePet' },
        client = { export = 'djfivem-pets.usePetClient' },
    },

    ['pet_pit'] = {
        label = 'Pit Bull',
        weight = 3500,
        stack = false,
        close = true,
        consume = 0,
        description = 'A patrol pit used for holds and close-quarters takedowns.',
        server = { export = 'djfivem-pets.usePet' },
        client = { export = 'djfivem-pets.usePetClient' },
    },

    ['pet_chop'] = {
        label = 'Chop',
        weight = 4200,
        stack = false,
        close = true,
        consume = 0,
        description = 'A department-grade rottweiler. Bite work first, loyalty always.',
        server = { export = 'djfivem-pets.usePet' },
        client = { export = 'djfivem-pets.usePetClient' },
    },

    ['pet_retriever_np'] = {
        label = 'Retriever NP',
        weight = 3400,
        stack = false,
        close = true,
        consume = 0,
        description = 'A detection retriever. Used for searches, articles, and suspect tracking.',
        server = { export = 'djfivem-pets.usePet' },
        client = { export = 'djfivem-pets.usePetClient' },
    },

    ['pet_husky_np'] = {
        label = 'Husky NP',
        weight = 3600,
        stack = false,
        close = true,
        consume = 0,
        description = 'A working husky used for tracking and cold-weather patrols.',
        server = { export = 'djfivem-pets.usePet' },
        client = { export = 'djfivem-pets.usePetClient' },
    },

    -- Companion dogs
    ['pet_husky'] = {
        label = 'Husky',
        weight = 3600,
        stack = false,
        close = true,
        consume = 0,
        description = 'A thick-coated northern working dog that never tires of a long walk.',
        server = { export = 'djfivem-pets.usePet' },
        client = { export = 'djfivem-pets.usePetClient' },
    },

    ['pet_retriever'] = {
        label = 'Retriever',
        weight = 3400,
        stack = false,
        close = true,
        consume = 0,
        description = 'A golden-hearted gundog. Soft mouth, softer personality.',
        server = { export = 'djfivem-pets.usePet' },
        client = { export = 'djfivem-pets.usePetClient' },
    },

    ['pet_westy'] = {
        label = 'West Highland Terrier',
        weight = 1400,
        stack = false,
        close = true,
        consume = 0,
        description = 'A compact white terrier with a huge personality and a bigger bark.',
        server = { export = 'djfivem-pets.usePet' },
        client = { export = 'djfivem-pets.usePetClient' },
    },

    ['pet_poodle'] = {
        label = 'Poodle',
        weight = 1800,
        stack = false,
        close = true,
        consume = 0,
        description = 'An elegant companion with a cloud of curls and a clever streak.',
        server = { export = 'djfivem-pets.usePet' },
        client = { export = 'djfivem-pets.usePetClient' },
    },

    ['pet_bulldog'] = {
        label = 'English Bulldog',
        weight = 3200,
        stack = false,
        close = true,
        consume = 0,
        description = 'Wrinkled, stubborn, and unexpectedly charming on a short walk.',
        server = { export = 'djfivem-pets.usePet' },
        client = { export = 'djfivem-pets.usePetClient' },
    },

    ['pet_dalmatian'] = {
        label = 'Dalmatian',
        weight = 3300,
        stack = false,
        close = true,
        consume = 0,
        description = 'Spotted, athletic, and born to ride shotgun with the fire crew.',
        server = { export = 'djfivem-pets.usePet' },
        client = { export = 'djfivem-pets.usePetClient' },
    },

    ['pet_chowchow'] = {
        label = 'Chow Chow',
        weight = 3100,
        stack = false,
        close = true,
        consume = 0,
        description = 'A lion-maned aristocrat with a blue-black tongue and a serious face.',
        server = { export = 'djfivem-pets.usePet' },
        client = { export = 'djfivem-pets.usePetClient' },
    },

    ['pet_dachshund'] = {
        label = 'Longhair Dachshund',
        weight = 1400,
        stack = false,
        close = true,
        consume = 0,
        description = 'A silky hot-dog with the heart of a hunter and the legs of a commuter.',
        server = { export = 'djfivem-pets.usePet' },
        client = { export = 'djfivem-pets.usePetClient' },
    },

    -- Puppies
    ['pet_aussiepup'] = {
        label = 'Aussie Puppy',
        weight = 1200,
        stack = false,
        close = true,
        consume = 0,
        description = 'A merle-coated ball of energy that will herd anything that moves.',
        server = { export = 'djfivem-pets.usePet' },
        client = { export = 'djfivem-pets.usePetClient' },
    },

    ['pet_fdpuppy'] = {
        label = 'Frenchie Puppy',
        weight = 1100,
        stack = false,
        close = true,
        consume = 0,
        description = 'A snorty little bat-ear with more attitude than body weight.',
        server = { export = 'djfivem-pets.usePet' },
        client = { export = 'djfivem-pets.usePetClient' },
    },

    ['pet_pitpup'] = {
        label = 'Pit Bull Puppy',
        weight = 1300,
        stack = false,
        close = true,
        consume = 0,
        description = 'A pocket tank with wrinkles, wiggles, and a lot of love to give.',
        server = { export = 'djfivem-pets.usePet' },
        client = { export = 'djfivem-pets.usePetClient' },
    },

    ['pet_rotpuppy'] = {
        label = 'Rottweiler Puppy',
        weight = 1500,
        stack = false,
        close = true,
        consume = 0,
        description = 'A chubby rust-and-black pup that will grow into a serious guardian.',
        server = { export = 'djfivem-pets.usePet' },
        client = { export = 'djfivem-pets.usePetClient' },
    },

    ['pet_bostonpup'] = {
        label = 'Boston Terrier Puppy',
        weight = 1000,
        stack = false,
        close = true,
        consume = 0,
        description = 'A tuxedo-clad spark plug. Small, tuxedoed, and always ready to play.',
        server = { export = 'djfivem-pets.usePet' },
        client = { export = 'djfivem-pets.usePetClient' },
    },

    ['pet_boxerpup'] = {
        label = 'Boxer Puppy',
        weight = 1200,
        stack = false,
        close = true,
        consume = 0,
        description = 'A wrinkly acrobat with spring-loaded hind legs and a goofy grin.',
        server = { export = 'djfivem-pets.usePet' },
        client = { export = 'djfivem-pets.usePetClient' },
    },

    ['pet_dalpup'] = {
        label = 'Dalmatian Puppy',
        weight = 1100,
        stack = false,
        close = true,
        consume = 0,
        description = 'A spotted spark. Fast, curious, and already practicing the firehouse pose.',
        server = { export = 'djfivem-pets.usePet' },
        client = { export = 'djfivem-pets.usePetClient' },
    },

    ['pet_yorkie'] = {
        label = 'Yorkshire Terrier Puppy',
        weight = 700,
        stack = false,
        close = true,
        consume = 0,
        description = 'A silk-haired scrap of confidence that believes it owns the block.',
        server = { export = 'djfivem-pets.usePet' },
        client = { export = 'djfivem-pets.usePetClient' },
    },

    -- Cats
    ['pet_sphynx'] = {
        label = 'Sphynx',
        weight = 800,
        stack = false,
        close = true,
        consume = 0,
        description = 'Hairless, warm, and wildly affectionate. A living velvet statue.',
        server = { export = 'djfivem-pets.usePet' },
        client = { export = 'djfivem-pets.usePetClient' },
    },

    -- Farm
    ['pet_piglet'] = {
        label = 'Piglet',
        weight = 1800,
        stack = false,
        close = true,
        consume = 0,
        description = 'A tiny pink tank that will follow you for treats and belly rubs.',
        server = { export = 'djfivem-pets.usePet' },
        client = { export = 'djfivem-pets.usePetClient' },
    },

    ['pet_donkey'] = {
        label = 'Donkey',
        weight = 7000,
        stack = false,
        close = true,
        consume = 0,
        description = 'Stubborn, sure-footed, and surprisingly affectionate once it trusts you.',
        server = { export = 'djfivem-pets.usePet' },
        client = { export = 'djfivem-pets.usePetClient' },
    },

    ['pet_goat'] = {
        label = 'Goat',
        weight = 4000,
        stack = false,
        close = true,
        consume = 0,
        description = 'A professional climber and amateur demolition expert. Watch your plants.',
        server = { export = 'djfivem-pets.usePet' },
        client = { export = 'djfivem-pets.usePetClient' },
    },

    ['pet_pig'] = {
        label = 'Pig',
        weight = 5000,
        stack = false,
        close = true,
        consume = 0,
        description = 'A full-grown farm hog. Smart, hungry, and excellent at finding snacks.',
        server = { export = 'djfivem-pets.usePet' },
        client = { export = 'djfivem-pets.usePetClient' },
    },

    ['pet_turkey'] = {
        label = 'Turkey',
        weight = 1600,
        stack = false,
        close = true,
        consume = 0,
        description = 'A gobbling parade float. Surprisingly proud for a bird that cannot fly far.',
        server = { export = 'djfivem-pets.usePet' },
        client = { export = 'djfivem-pets.usePetClient' },
    },

    -- Exotic
    ['pet_dodo'] = {
        label = 'Dodo',
        weight = 2200,
        stack = false,
        close = true,
        consume = 0,
        description = 'A plump, flightless relic. Slow, curious, and completely unbothered.',
        server = { export = 'djfivem-pets.usePet' },
        client = { export = 'djfivem-pets.usePetClient' },
    },

    ['pet_raccoon'] = {
        label = 'Raccoon',
        weight = 900,
        stack = false,
        close = true,
        consume = 0,
        description = 'A masked bandit that will steal snacks, hearts, and unattended tacos.',
        server = { export = 'djfivem-pets.usePet' },
        client = { export = 'djfivem-pets.usePetClient' },
    },

    ['pet_capybara'] = {
        label = 'Capybara',
        weight = 5500,
        stack = false,
        close = true,
        consume = 0,
        description = 'The world\'s most relaxed roommate. Semi-aquatic and endlessly chill.',
        server = { export = 'djfivem-pets.usePet' },
        client = { export = 'djfivem-pets.usePetClient' },
    },

    ['pet_skunk'] = {
        label = 'Skunk',
        weight = 700,
        stack = false,
        close = true,
        consume = 0,
        description = 'Striped, sweet, and best enjoyed from a polite distance.',
        server = { export = 'djfivem-pets.usePet' },
        client = { export = 'djfivem-pets.usePetClient' },
    },

    ['pet_reindeer'] = {
        label = 'Reindeer',
        weight = 7500,
        stack = false,
        close = true,
        consume = 0,
        description = 'Antlers, winter coat, and a calm that belongs on a holiday card.',
        server = { export = 'djfivem-pets.usePet' },
        client = { export = 'djfivem-pets.usePetClient' },
    },

    -- Wild
    ['pet_blackbear'] = {
        label = 'Black Bear',
        weight = 8000,
        stack = false,
        close = true,
        consume = 0,
        description = 'A forest heavyweight. Keep it fed, keep it happy, keep it leashed.',
        server = { export = 'djfivem-pets.usePet' },
        client = { export = 'djfivem-pets.usePetClient' },
    },

    ['pet_honeybadger'] = {
        label = 'Honey Badger',
        weight = 1800,
        stack = false,
        close = true,
        consume = 0,
        description = 'Fearless, stocky, and allergic to backing down. Give it space.',
        server = { export = 'djfivem-pets.usePet' },
        client = { export = 'djfivem-pets.usePetClient' },
    },

    ['pet_wolf'] = {
        label = 'Wolf',
        weight = 4200,
        stack = false,
        close = true,
        consume = 0,
        description = 'A timber wolf with a low howl and a stare that means business.',
        server = { export = 'djfivem-pets.usePet' },
        client = { export = 'djfivem-pets.usePetClient' },
    },

    -- Special
    ['pet_robot'] = {
        label = 'Zathura',
        weight = 3000,
        stack = false,
        close = true,
        consume = 0,
        description = 'A compact companion automaton. No kibble required. Attitude optional.',
        server = { export = 'djfivem-pets.usePet' },
        client = { export = 'djfivem-pets.usePetClient' },
    },

    -- Supplies
    ['pet_food'] = {
        label = 'Premium Kibble',
        weight = 200,
        stack = true,
        close = true,
        consume = 0,
        description = 'Slow-baked kibble that fills the bowl and the bond meter.',
        server = { export = 'djfivem-pets.useFood' },
    },

    ['pet_water'] = {
        label = 'Fresh Water',
        weight = 200,
        stack = true,
        close = true,
        consume = 0,
        description = 'Clean drinking water. Keep a few bottles on you for long walks.',
        server = { export = 'djfivem-pets.useWater' },
    },

    ['pet_collar'] = {
        label = 'Leather Collar',
        weight = 80,
        stack = true,
        close = true,
        consume = 0,
        description = 'A fitted collar. Required before you can clip on a leash.',
        server = { export = 'djfivem-pets.useCollar' },
    },

    ['pet_leash'] = {
        label = 'Walking Leash',
        weight = 120,
        stack = false,
        close = true,
        consume = 0,
        description = 'Keep this in your inventory to walk a collared companion.',
        server = { export = 'djfivem-pets.useLeash' },
    },

    ['pet_revive'] = {
        label = 'Revive Kit',
        weight = 250,
        stack = true,
        close = true,
        consume = 0,
        description = 'Field medicine for a companion that collapsed from injury or neglect.',
        server = { export = 'djfivem-pets.useRevive' },
    },
    -- ======== PASTE END ========
