fx_version 'cerulean'
game 'gta5'

version '1.2.0'

shared_script 'config.lua'

client_scripts {
  'client.lua',
  'megaphone.lua',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',  
  'server.lua'
}

ui_page('html/ui.html')

files {
  'html/ui.html',
  'html/js/script.js',
  'html/css/style.css',
  'html/img/cursor.png',
  'html/img/radio.png'
}

lua54 'yes'
