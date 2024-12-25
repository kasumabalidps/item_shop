fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'github.com/kasumabalidps'
description 'Item Shop Resource'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client.lua',
    'targets.lua'
}

server_script 'server.lua'

dependencies {
    'qb-core',
    'ox_lib',
    'ox_target'
}
