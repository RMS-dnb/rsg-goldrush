fx_version 'cerulean'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
game 'rdr3'



client_scripts {
	'client/client.lua',
	'client/smelterclient.lua',
	'client/sellclient.lua',
	'client/client.js',
}

exports {
	'DisplayLeftNotification',
	'DisplayNotification',
	'DisplayLocationNotification',
}

server_scripts {
	'server/server.lua',
	'server/smelterserver.lua',
	'server/sellserver.lua',
}

files {

	'client/*.js',

}


shared_scripts {
	'config.lua',
	'locales/en.lua',
}

dependency 'rsg-core'

this_is_a_map 'yes'

lua54 'yes'


