fx_version 'cerulean'
lua54 'yes'
game 'gta5'
name 'lokka_restaurants'
author 'lokka'
version '1.0.0'
repository 'https://github.com/lokka/lokka_restaurants'
description 'All-in-one restaurant manager for ox_core.'

dependencies { 'ox_core', 'ox_lib', 'ox_target' }

client_scripts { 'client/*.lua' }
server_scripts { 'server/*.lua' }
shared_scripts { '@ox_lib/init.lua', '@ox_core/lib/init.lua' }
files { 'config/*.lua' }