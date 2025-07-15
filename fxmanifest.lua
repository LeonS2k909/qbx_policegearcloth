fx_version 'cerulean'
game 'gta5'

author 'Leon2k9'
description 'Assigns gear and clothing on job assignment using Qbox + Ox Inventory + illenium-appearance'
version '1.1.1'

shared_scripts {
    '@ox_lib/init.lua',
    '@qbx_core/modules/lib.lua',
    'config.lua'  -- Config will be loaded first
}

server_scripts {
    'server.lua'
}

client_scripts {
    'client.lua'
}

dependencies {
    'qbx_core',
    'ox_inventory',
    'illenium-appearance',
    'ox_lib'
}