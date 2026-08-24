fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'djfivem-pets'
author 'DieselJones21'
description 'Interactable GTA animal pets with ox_inventory items, needs, walks, and a pet menu'
version '1.0.0'

ox_lib 'locale'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
    'shared/utils.lua',
}

client_scripts {
    'client/main.lua',
    'client/leash.lua',
    'client/target.lua',
    'client/nui.lua',
    'client/shop.lua',
}

server_scripts {
    'server/main.lua',
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/app.js',
    'locales/*.json',
}

dependencies {
    'ox_lib',
    'ox_inventory',
}
