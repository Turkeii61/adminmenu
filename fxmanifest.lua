fx_version 'cerulean'
games { 'gta5' }
author 'Türkeii'
lua54 'yes'

shared_scripts {
  'configs/shared/**',
}

client_scripts {
  'client/**',
}

server_scripts {
  "@oxmysql/lib/MySQL.lua",
  'server/**',
  'configs/server/**',
}

ui_page 'web/dist/index.html'


files {
  'web/dist/index.html',
  'web/dist/**'
}
