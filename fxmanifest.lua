fx_version 'cerulean'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
game 'rdr3'


description 'rsg-chat'
version "1.0"

ui_page 'web/ui.html'

files {
    'web/*.*',
}

shared_script 'config.lua'

client_scripts {
    'client/client.lua',
    'client/whisper.lua',
}

server_scripts {
    'server/server.lua',
    'server/commands.lua',
    'server/versionchecker.lua',
}

dependency 'rsg-core'
