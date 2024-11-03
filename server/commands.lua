local RSGCore = exports['rsg-core']:GetCoreObject()

local canAdvertise = true
local reportCooldown = {}

-------------------
-- send To Discord
-------------------

local function sendToDiscord(color, name, message, footer, type)
    local embed = {{   
        ["color"] = color,
        ["title"] = "**".. name .."**",
        ["description"] = message,
        ["footer"] = {
            ["text"] = footer
        }
    }}
    if type == "chatreport" then
        PerformHttpRequest(Config['Webhooks']['chatreport'], function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' })
    elseif type == "chatooc" then
        PerformHttpRequest(Config['Webhooks']['chatooc'], function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' })
    elseif type == "chatme" then
        PerformHttpRequest(Config['Webhooks']['chatme'], function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' })
    elseif type == "chatdo" then
        PerformHttpRequest(Config['Webhooks']['chatdo'], function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' })
    elseif type == "chatrumor" then
        PerformHttpRequest(Config['Webhooks']['chatrumor'], function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' })
    elseif type == "chatrumoric" then
        PerformHttpRequest(Config['Webhooks']['chatrumoric'], function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' })
    end
end

if Config.AllowPlayersToClearTheirChat then
    RegisterCommand(Config.ClearChatCommand, function(source, args, rawCommand)
        TriggerClientEvent('chat:client:ClearChat', source)
    end, false)
end

if Config.AllowStaffsToClearEveryonesChat then
    RegisterCommand(Config.ClearEveryonesChatCommand, function(source, args, rawCommand)
        local Player = RSGCore.Functions.GetPlayer(source)
        local time = os.date(Config.DateFormat)
        local src = source

        if RSGCore.Functions.HasPermission(src, 'admin') or IsPlayerAceAllowed(src, 'command') then
            TriggerClientEvent('chat:client:ClearChat', -1)
            TriggerClientEvent('chat:addMessage', -1, {
                template = '<div class="chat-message system"><i class="fas fa-cog"></i> <b><span style="color: #df7b00">SYSTEM</span>&nbsp;<span style="font-size: 14px; color: #e1e1e1;">{0}</span></b><div style="margin-top: 5px; font-weight: 300;">The chat has been cleared!</div></div>',
                args = { time }
            })
        end
    end, false)
end

if Config.EnableStaffCommand then
    RegisterCommand(Config.StaffCommand, function(source, args, rawCommand)
        local Player = RSGCore.Functions.GetPlayer(source)
        local length = string.len(Config.StaffCommand)
        local message = rawCommand:sub(length + 1)
        local time = os.date(Config.DateFormat)
        playerName = Player.PlayerData.name
        local src = source
        if #args < 1 then
            TriggerClientEvent('ox_lib:notify', source, {title = 'Staff Command', description = 'Usage: /'..Config.StaffCommand..' [message]', type = 'error', duration = 5000 })
            return
        end
        if RSGCore.Functions.HasPermission(src, 'admin') or IsPlayerAceAllowed(src, 'command') then
            TriggerClientEvent('chat:addMessage', -1, {
                template = '<div class="chat-message staff"><i class="fas fa-shield-alt"></i> <b><span style="color: #1ebc62">[ANNOUNCEMENT]</span>&nbsp;<span style="font-size: 14px; color: #e1e1e1;">{1}</span></b><div style="margin-top: 5px; font-weight: 300;">{0}</div></div>',
                args = { message, time }
            })
        end
    end, false)
end

if Config.EnableStaffOnlyCommand then
    RegisterCommand(Config.StaffOnlyCommand, function(source, args, rawCommand)
        local Player = RSGCore.Functions.GetPlayer(source)
        local length = string.len(Config.StaffOnlyCommand)
        local message = rawCommand:sub(length + 2)
        local time = os.date(Config.DateFormat)
        local playerName = Player.PlayerData.name
        local src = source
        if #args < 1 then
            TriggerClientEvent('ox_lib:notify', source, {title = 'Admin Chat', description = 'Usage: /'..Config.StaffOnlyCommand..' [message]', type = 'error', duration = 5000 })
            return
        end
        if RSGCore.Functions.HasPermission(src, 'admin') or IsPlayerAceAllowed(src, 'command') then
            local players = getPlayersWithStaffRoles()
            for k, v in ipairs(players) do
                TriggerClientEvent('chat:addMessage', v, {
                    template = '<div class="chat-message staffonly"><i class="fas fa-eye-slash"></i> <b><span style="color: #1ebc62">[ADMIN] {0}</span>&nbsp;<span style="font-size: 14px; color: #e1e1e1;">{2}</span></b><div style="margin-top: 5px; font-weight: 300;">{1}</div></div>',
                    args = { playerName, message, time }
                })
            end
            TriggerClientEvent('chat:addMessage', src, {
                template = '<div class="chat-message staffonly"><i class="fas fa-eye-slash"></i> <b><span style="color: #1ebc62">[ADMIN] {0}</span>&nbsp;<span style="font-size: 14px; color: #e1e1e1;">{2}</span></b><div style="margin-top: 5px; font-weight: 300;">{1}</div></div>',
                args = { playerName, message, time }
            })
        end
    end, false)
end

if Config.EnableAdvertisementCommand then
    RegisterCommand(Config.AdvertisementCommand, function(source, args, rawCommand)
        local Player = RSGCore.Functions.GetPlayer(source)
        local length = string.len(Config.AdvertisementCommand)
        local message = rawCommand:sub(length + 1)
        local time = os.date(Config.DateFormat)
        local PlayerData = Player.PlayerData
        local firstname = PlayerData.charinfo.firstname
        local lastname = PlayerData.charinfo.lastname
        local playerName = firstname .. ' ' .. lastname
        local bankMoney = PlayerData.money.bank
        if #args < 1 then
            TriggerClientEvent('ox_lib:notify', source, {title = 'Advertisement', description = 'Usage: /'..Config.AdvertisementCommand..' [message]', type = 'error', duration = 5000 })
            return
        end
        if canAdvertise then
            if bankMoney >= Config.AdvertisementPrice then
                Player.Functions.RemoveMoney('bank', Config.AdvertisementPrice)
                TriggerClientEvent('chat:addMessage', -1, {
                    template = '<div class="chat-message advertisement"><i class="fas fa-ad"></i> <b><span style="color: #81db44">{0}</span>&nbsp;<span style="font-size: 14px; color: #e1e1e1;">{2}</span></b><div style="margin-top: 5px; font-weight: 300;">{1}</div></div>',
                    args = { playerName, message, time }
                })
                TriggerClientEvent('ox_lib:notify', source, {title = "Advertisement successfully made for "..Config.AdvertisementPrice..'$', type = 'inform', duration = 5000 })

                local time = Config.AdvertisementCooldown * 60
                local pastTime = 0
                canAdvertise = false

                while (time > pastTime) do
                    Citizen.Wait(1000)
                    pastTime = pastTime + 1
                    timeLeft = time - pastTime
                end
                canAdvertise = true
            else
                TriggerClientEvent('ox_lib:notify', source, {title = "You don\'t have enough money to make an advertisement", type = 'error', duration = 5000 })
                
            end
        else
            TriggerClientEvent('ox_lib:notify', source, {title = Config.AdvertisementCooldown.." minutes.", description = "You can only advertise once every ", type = 'error', duration = 5000 })
        end
    end, false)
end

if Config.EnableValentineCommand then
    RegisterCommand(Config.ValentineCommand, function(source, args, rawCommand)
        local xPlayer = RSGCore.Functions.GetPlayer(source)
        local length = string.len(Config.ValentineCommand)
        local message = rawCommand:sub(length + 1)
        local time = os.date(Config.DateFormat)
        playerName = xPlayer.PlayerData.name
        local job = xPlayer.PlayerData.job.name
        if #args < 1 then
            TriggerClientEvent('ox_lib:notify', source, {title = 'Valentine', description = 'Usage: /'..Config.ValentineCommand..' [message]', type = 'error', duration = 5000 })
            return
        end
        if job == Config.ValentineJobName then
            TriggerClientEvent('chat:addMessage', -1, {
                template = '<div class="chat-message valentine"><i class="fas fa-cog"></i> <b><span style="color: #595858">[VALENTINE] {0}</span>&nbsp;<span style="font-size: 14px; color: #fcf7f5;">{1}</div></b><div style="margin-top: 5px; font-weight: 300;"</div>',
                args = { message, time }
            })
        end
    end, false)
end

if Config.EnableRhodesCommand then
    RegisterCommand(Config.RhodesCommand, function(source, args, rawCommand)
        local xPlayer = RSGCore.Functions.GetPlayer(source)
        local length = string.len(Config.RhodesCommand)
        local message = rawCommand:sub(length + 1)
        local time = os.date(Config.DateFormat)
        local job = xPlayer.PlayerData.job.name
        if #args < 1 then
            TriggerClientEvent('ox_lib:notify', source, {title = 'Rhodes', description = 'Usage: /'..Config.RhodesCommand..' [message]', type = 'error', duration = 5000 })
            return
        end
        if job == Config.RhodesJobName then
            TriggerClientEvent('chat:addMessage', -1, {
                template = '<div class="chat-message rhodes"><i class="fas fa-cog"></i> <b><span style="color: #32406e">[RHODES] {0}</span>&nbsp;<span style="font-size: 14px; color: #62a2f5;">{1}</div></b><div style="margin-top: 5px; font-weight: 300;"</div>',
                args = { message, time }
            })
        end
    end, false)
end

if Config.EnableReportCommand then
    RegisterCommand(Config.ReportCommand, function(source, args, rawCommand)
        local src = source
        local msg = table.concat(args, ' ')
        local Player = RSGCore.Functions.GetPlayer(src)

        if #args < 1 then
            TriggerClientEvent('ox_lib:notify', source, {title = 'Report', description = 'Usage: /'..Config.ReportCommand..' [message]', type = 'error', duration = 5000 })
            return
        end
        TriggerClientEvent('rsg-chat:client:SendReport', -1, GetPlayerName(src), src, msg)
        local discordMessage = string.format(
                "Citizenid:** %s\n**Ingame ID:** %d\n**Name:** %s %s\n**Report:** %s**",
                Player.PlayerData.citizenid,
                Player.PlayerData.cid,
                Player.PlayerData.charinfo.firstname,
                Player.PlayerData.charinfo.lastname,
                msg
            )
        sendToDiscord(16753920,	"chat | REPORT", discordMessage, "Chating for RSG Framework", "chatreport")
        -- TriggerEvent('rsg-log:server:CreateLog', 'report', 'Report', 'green', '**' .. GetPlayerName(src) ..' (' .. GetPlayerIdentifier(src) .. ') ** (CitizenID: ' .. Player.PlayerData.citizenid .. ' | ID: ' .. src .. ') **Report:** ' .. msg, false)
    end, false)
end

RegisterNetEvent('rsg-chat:server:SendReport', function(name, targetSrc, msg)
	local src = source
	if RSGCore.Functions.HasPermission(src, 'admin') or IsPlayerAceAllowed(src, 'command') then
		TriggerClientEvent('chat:addMessage', src, {
			template =
			'<div class="chat-message report"><i class="fas fa-comment"></i> <b><span style="color: #e1e1e1">[REPORT] {0}</span>&nbsp;<span style="font-size: 14px; color: #e1e1e1;">{1}</span></b><div style="margin-top: 5px; font-weight: 300;">{2}</div></div>',
			args = { name, targetSrc, msg }
		})
	end
end)

if Config.EnablereplyCommand then
    RegisterCommand(Config.replyCommand, function(source, args, rawCommand)
        local player = RSGCore.Functions.GetPlayer(source)
        local playerName = player.PlayerData.name
        local message = table.concat(args, ' ')
        local time = os.date(Config.DateFormat)
        local src = source

        if RSGCore.Functions.HasPermission(src, 'admin') or IsPlayerAceAllowed(src, 'command') then
            -- Check if the user provided an ID and a message
            if #args < 2 then
                TriggerClientEvent('ox_lib:notify', source, {title = 'Usage: /reply [report ID] [message]', type = 'error', duration = 5000 })
                return
            end
            
            -- Get the report ID and message
            local reportId = tonumber(args[1])
            local replyMessage = table.concat(args, ' ', 2)
            
            -- Get the report from the ID
            local report = reportCooldown[reportId]
            if not report then
                TriggerClientEvent('ox_lib:notify', source, {title = 'Invalid report ID.', type = 'error', duration = 5000 })
                return
            end
            
            -- Get the player who made the report
            local reportedPlayer = RSGCore.Functions.GetPlayer(report.reporter)
            if not reportedPlayer then
                TriggerClientEvent('ox_lib:notify', source, {title = 'Reported player is not online.', type = 'error', duration = 5000 })
                return
            end
            
            -- Send the reply message to the player who made the report
            TriggerClientEvent('chat:addMessage', reportedPlayer.PlayerData.source, {
                template = '<div class="chat-message report-reply"><i class="fas fa-comment"></i> <b><span style="color: #feca57">[REPORT REPLY] {0}</span>&nbsp;<span style="font-size: 14px; color: #e1e1e1;">{1}</span></b><div style="margin-top: 5px; font-weight: 300;">{2}</div></div>',
                args = { playerName, replyMessage, time }
            })
            
            -- Notify the admin that the message was sent
            TriggerClientEvent('ox_lib:notify', source, {title = string.format('Your message was sent to %s.', reportedPlayer.PlayerData.name), type = 'error', duration = 5000 })
            -- player.Functions.Notify(string.format('Your message was sent to %s.', reportedPlayer.PlayerData.name))
            
            -- Add the reply message to the report log
            table.insert(report.log, {
                author = playerName,
                message = replyMessage,
                time = os.date(Config.DateFormat)
            })
        end
    end, false)
end

if Config.EnablegossipCommand then
    RegisterCommand(Config.gossipCommand, function(source, args, rawCommand)
        local message = table.concat(args, ' ')
        local time = os.date(Config.DateFormat)
        if #args < 1 then
            TriggerClientEvent('ox_lib:notify', source, {title = 'Gossip', description = 'Usage: /'..Config.gossipCommand..' [message]', type = 'error', duration = 5000 })
            return
        end
        TriggerClientEvent('chat:addMessage', -1, {
            template = '<div class="chat-message gossip"><i class="fas fa-comment"></i> <b><span style="color: #ffc107">[GOSSIP]</span>&nbsp;<span style="font-size: 14px; color: #e1e1e1;">{1}</span></b><div style="margin-top: 5px; font-weight: 300;">{0}</div></div>',
            args = { message, time }
        })
    end, false)
end

if Config.EnableauxilioCommand then
    local activeAuxilio = {}  -- Table to store active auxilio requests

    RegisterCommand(Config.auxilioCommand, function(source, args, rawCommand)
        local Player = RSGCore.Functions.GetPlayer(source)
        local message = table.concat(args, ' ')
        local time = os.date(Config.DateFormat)
        local PlayerData = Player.PlayerData
        local firstname = PlayerData.charinfo.firstname
        local lastname = PlayerData.charinfo.lastname
        local playerName = firstname .. ' ' .. lastname

        local players = RSGCore.Functions.GetRSGPlayers()

        for _, targetPlayer in pairs(players) do
            -- Enviar el mensaje solo a los jugadores que tienen el trabajo de "medic"
            if targetPlayer.PlayerData.job and targetPlayer.PlayerData.job.name == 'medic' then
                local alertMessage = message
                TriggerClientEvent('chat:addMessage', targetPlayer.PlayerData.source, {
                    template = '<div class="msg auxilio"><i class="fas fa-comment"></i> <b><span style="color: #dc3545; font-size: 20px;">[AUXILIO] {0}</span>&nbsp;<span style="font-size: 18px; color: #e1e1e1;">{1}</span></b><div style="margin-top: 2px; font-weight: 300;">',
                    args = {time, alertMessage}
                })

                -- Store the active auxilio request
                table.insert(activeAuxilio, {
                    sender = source,
                    recipient = targetPlayer.PlayerData.source,
                    message = message
                })
            end
        end
    end, false)
end

if Config.EnablerespuestaCommand then
    -- Add a response command for medics to acknowledge the auxilio request
    RegisterCommand(Config.respuestaCommand, function(source, args, rawCommand)
        local Player = RSGCore.Functions.GetPlayer(source)
        local time = os.date(Config.DateFormat)
        local responseMessage = table.concat(args, ' ')

        -- Check if there are active auxilio requests
        if #activeAuxilio > 0 then
            local auxilioRequest = table.remove(activeAuxilio, 1)
            local sender = RSGCore.Functions.GetPlayer(auxilioRequest.sender)

            -- Send a response message to the sender
            TriggerClientEvent('chat:addMessage', sender.PlayerData.source, {
                template = '<div class="msg auxilio-response"><i class="fas fa-comment"></i> <b><span style="color: #28a745; font-size: 20px;">[Auxilio Response] {0}</span>&nbsp;<span style="font-size: 17px; color: #e1e1e1;">{1}</span></b><div style="margin-top: 2px; font-weight: 300;">',
                args = {time, responseMessage}
            })
        end
    end, false)
end

if Config.EnabletestigoCommand then
    RegisterCommand(Config.testigoCommand, function(source, args, rawCommand)
        local Player = RSGCore.Functions.GetPlayer(source)
        local message = table.concat(args, ' ')
        local time = os.date(Config.DateFormat)
        local PlayerData = Player.PlayerData
        local firstname = PlayerData.charinfo.firstname
        local lastname = PlayerData.charinfo.lastname
        local playerName = firstname .. ' ' .. lastname

        local players = RSGCore.Functions.GetRSGPlayers()
        if #args < 1 then
            TriggerClientEvent('ox_lib:notify', source, {title = 'TESTIGO', description = 'Usage: /'.. Config.testigoCommand ..' [message]', type = 'error', duration = 5000 })
            return
        end
        for _, targetPlayer in pairs(players) do
            -- Enviar el mensaje solo a los jugadores que tienen el trabajo de "police"
            local leo = {'vallaw', 'rholaw', 'blklaw', 'strlaw', 'stdenlawoffice'}
            if targetPlayer.PlayerData.job and targetPlayer.PlayerData.job.name == leo then
                local alertMessage = message
                TriggerClientEvent('chat:addMessage', targetPlayer.PlayerData.source, {
                    template = '<div class="msg testigo" style="max-height: 300px; margin-bottom: 5px;"><i class="fas fa-comment"></i> <b><span style="color: #dc3545; font-size: 19px;">[TESTIGO] {0}</span>&nbsp;<span style="font-size: 16px; color: #e1e1e1;">{1}</span></b><div style="margin-top: 2px; font-weight: 300;">',
                    args = {time, alertMessage}
                })

                -- Verificar si el jugador está dentro de un radio de 50 unidades del testigo
                local playerCoords = GetEntityCoords(GetPlayerPed(targetPlayer.PlayerData.source))
                local witnessCoords = GetEntityCoords(GetPlayerPed(source))
                local distance = #(playerCoords - witnessCoords)

                if distance <= 50.0 then
                    -- Mostrar notificación en lugar de un mensaje en el chat
                    TriggerClientEvent('ox_lib:notify', targetPlayer.PlayerData.source, {title = 'Un testigo ha enviado un mensaje cerca de ti!', type = 'inform', duration = 5000 })
                end
            end
        end
    end, false)
end

if Config.EnablerumorCommand then
    RegisterCommand(Config.rumorCommand, function(source, args, rawCommand)

        local Player = RSGCore.Functions.GetPlayer(source)
        local message = table.concat(args, ' ')
        local time = os.date(Config.DateFormat)
        local PlayerData = Player.PlayerData
        local firstname = PlayerData.charinfo.firstname
        local lastname = PlayerData.charinfo.lastname
        local playerName = firstname .. ' ' .. lastname
        
        if #args < 1 then
            TriggerClientEvent('ox_lib:notify', source, {title = 'RUMOR', description = 'Usage: /' .. Config.rumorCommand .. ' [message]', type = 'error', duration = 5000 })
            return
        end

        TriggerClientEvent('chat:addMessage', -1, {
            template = '<div class="msg rumor"><i class="fas fa-comment"></i> <b><span style="color: #ffc107">[RUMOR] {0}</span>&nbsp;<span style="font-size: 17px; color: #e1e1e1;">{1}</span></b><div style="margin-top: 2px; font-weight: 300;">',
            args = {time, message}
        })

        local discordMessage = string.format(
            "Citizenid:** %s\n**Ingame ID:** %d\n**Name:** %s %s\n**Message::** %s**",
            Player.PlayerData.citizenid,
            Player.PlayerData.cid,
            firstname,
            lastname,
            message
        )
        sendToDiscord(16753920, "chat | RUMOR", discordMessage, "Chating for RSG Framework", "chatrumor")

        local discordMessage2 = string.format(
            "Message:** %s**",
            message
        )
        sendToDiscord(16753920, "info | RUMOR", discordMessage2, "Chating for RSG Framework", "chatrumoric")
        
        -- TriggerEvent('rsg-log:server:CreateLog', 'rumor', 'RUMOR', 'white', '' .. GetPlayerName(source) .. ' (CitizenID: ' .. Player.PlayerData.citizenid .. ' | ID: ' .. source .. ') Message: ' .. message, false)
    end, false)
end


if Config.EnablempCommand then
    RegisterCommand(Config.mpCommand, function(source, args, rawCommand)
        local playerId = tonumber(args[1])
        local message = table.concat(args, ' ', 2)

        -- Validar que se proporcionó un ID de jugador y un mensaje
        if playerId and message and message ~= '' then
            local sender = RSGCore.Functions.GetPlayer(source)
            local receiver = RSGCore.Functions.GetPlayer(playerId)

            -- Verificar que el jugador receptor existe y está en línea
            if receiver and receiver.PlayerData.source then
                local time = os.date(Config.DateFormat)

                -- Obtener el nombre completo del remitente dentro del juego
                local senderName = sender and sender.PlayerData and sender.PlayerData.charinfo and (sender.PlayerData.charinfo.firstname .. " " .. sender.PlayerData.charinfo.lastname) or "Unknown"

                -- Obtener el nombre completo del receptor dentro del juego
                local receiverName = receiver and receiver.PlayerData and receiver.PlayerData.charinfo and (receiver.PlayerData.charinfo.firstname .. " " .. receiver.PlayerData.charinfo.lastname) or "Unknown"

                -- Enviar el mensaje al jugador receptor
                TriggerClientEvent('chat:addMessage', receiver.PlayerData.source, {
                    template = '<div class="chat-message private-message"><i class="fas fa-envelope"></i> <strong>MP {0} (ID: {1})</strong>&nbsp;<span style="font-size: 20px; color: #e1e1e1;">{2}</span><div style="margin-top: 2px; font-weight: 300;">',
                    args = {senderName, source, message}
                })

                -- Enviar confirmación al remitente
                TriggerClientEvent('chat:addMessage', sender.PlayerData.source, {
                    template = '<div class="chat-message private-message"><i class="fas fa-envelope"></i> <strong>MP {0} (ID: {1})</strong>&nbsp;<span style="font-size: 20px; color: #e1e1e1;">{2}</span><div style="margin-top: 2px; font-weight: 300;">',
                    args = {receiverName, playerId, message}
                })
            else
                -- Mensaje de error si el jugador receptor no está en línea
                TriggerClientEvent('chat:addMessage', source, {
                    template = '<div class="chat-message error-message"><i class="fas fa-exclamation-circle"></i> <strong>Error</strong>&nbsp;<span style="font-size: 20px; color: #e1e1e1;">Jugador no encontrado o no está en línea.</span><div style="margin-top: 2px; font-weight: 300;">',
                    args = {}
                })
            end
        else
            -- Mensaje de error si no se proporciona un ID de jugador o mensaje
            TriggerClientEvent('chat:addMessage', source, {
                template = '<div class="chat-message error-message"><i class="fas fa-exclamation-circle"></i> <strong>Error</strong>&nbsp;<span style="font-size: 20px; color: #e1e1e1;">Uso inválido. /mp <playerId> <message></span><div style="margin-top: 2px; font-weight: 300;">',
                args = {}
            })
        end
    end, false)
end

if Config.EnableWhisperCommand then
    RegisterCommand(Config.WhisperCommand, function(source, args, rawCommand)
        local xPlayer = RSGCore.Functions.GetPlayer(source)
        local length = string.len(Config.WhisperCommand)
        local message = rawCommand:sub(length + 1)
        local time = os.date(Config.DateFormat)
        playerName = xPlayer.PlayerData.name
        if #args < 1 then
            TriggerClientEvent('ox_lib:notify', source, {title = 'Whisper', description = 'Usage: /'.. Config.WhisperCommand ..' [message]', type = 'error', duration = 5000 })
            return
        end
        TriggerClientEvent('chat:whisper', -1, source, playerName, message, time)
    end)
end

RegisterCommand('ooc', function(source, args, rawCommand)
    
    local Player = RSGCore.Functions.GetPlayer(source)
    local message = table.concat(args, ' ')
    local time = os.date(Config.DateFormat)
    local PlayerData = Player.PlayerData
    local firstname = PlayerData.charinfo.firstname
    local lastname = PlayerData.charinfo.lastname
    local playerName = firstname .. ' ' .. lastname
    if #args < 1 then
        TriggerClientEvent('ox_lib:notify', source, {title = 'OOC', description = 'Usage: /ooc [message]', type = 'error', duration = 5000 })
        return
    end

    TriggerClientEvent('chat:addMessage', -1, {
        template = '<div class="chat-message ooc"><i class="fas fa-comment"></i> <b><span style="color: #ffc107">[OOC] {0}</span>&nbsp;<span style="font-size: 14px; color: #e1e1e1;">{1}</span></b><div style="margin-top: 5px; font-weight: 300;">{2}</div></div>',
        args = {playerName, time, message}
    })
    
    local discordMessage = string.format(
            "Citizenid:** %s\n**Ingame ID:** %d\n**Name:** %s %s\n**Message::** %s**",
            Player.PlayerData.citizenid,
            Player.PlayerData.cid,
            Player.PlayerData.charinfo.firstname,
            Player.PlayerData.charinfo.lastname,
            message
        )
    sendToDiscord(16753920,	"chat | OOC", discordMessage, "Chating for RSG Framework", "chatooc")
    -- TriggerEvent('rsg-log:server:CreateLog', 'ooc', 'OOC', 'white', '**' .. GetPlayerName(source) .. '** (CitizenID: ' .. Player.PlayerData.citizenid .. ' | ID: ' .. source .. ') **Message:** ' .. message, false)
end, false)

RegisterCommand('me', function(source, args, rawCommand)
    local Player = RSGCore.Functions.GetPlayer(source)
    local message = table.concat(args, ' ')
    local time = os.date(Config.DateFormat)
    local PlayerData = Player.PlayerData
    local firstname = PlayerData.charinfo.firstname
    local lastname = PlayerData.charinfo.lastname
    local playerName = firstname .. ' ' .. lastname
    local playerPos = GetEntityCoords(GetPlayerPed(source))
    local radioRange = 5.0  
    if #args < 1 then
        TriggerClientEvent('ox_lib:notify', source, {title = 'ME', description = 'Usage: /me [message]', type = 'error', duration = 5000 })
        return
    end
    -- Itera sobre todos los jugadores para enviar el mensaje solo a los cercanos
    for _, targetPlayer in ipairs(GetPlayers()) do
        local targetPos = GetEntityCoords(GetPlayerPed(targetPlayer))
        local distance = #(playerPos - targetPos)

        if distance <= radioRange then
            TriggerClientEvent('chat:addMessage', targetPlayer, {
                template = '<div class="msg me"><i class="fas fa-comment"></i> <b><span style="color: #9c70de; font-size: 19px;">[ME] {0}</span>&nbsp;<span style="font-size: 17px; color: #9c70de;">{1}</span></b><div style="margin-top: 2px; font-weight: 300;">',
                args = {playerName, message}
            })
        end
    end

    -- Registra el mensaje en el servidor de registro
    local discordMessage = string.format(
            "Citizenid:** %s\n**Ingame ID:** %d\n**Name:** %s %s\n**Message::** %s**",
            Player.PlayerData.citizenid,
            Player.PlayerData.cid,
            Player.PlayerData.charinfo.firstname,
            Player.PlayerData.charinfo.lastname,
            message
        )
    sendToDiscord(16753920,	"chat | ME", discordMessage, "Chating for RSG Framework", "chatme")
    -- TriggerEvent('rsg-log:server:CreateLog', 'me', 'me', 'white', '' .. GetPlayerName(source) .. ' (CitizenID: ' .. Player.PlayerData.citizenid .. ' | ID: ' .. source .. ') Message: ' .. message, false)
end, false)

RegisterCommand('do', function(source, args, rawCommand)

    local Player = RSGCore.Functions.GetPlayer(source)
    local message = table.concat(args, ' ')
    local time = os.date(Config.DateFormat)
    local PlayerData = Player.PlayerData
    local firstname = PlayerData.charinfo.firstname
    local lastname = PlayerData.charinfo.lastname
    local playerName = firstname .. ' ' .. lastname
    local playerPos = GetEntityCoords(GetPlayerPed(source))
    local radioRange = 5.0  
    if #args < 1 then
        TriggerClientEvent('ox_lib:notify', source, {title = 'DO', description = 'Usage: /do [message]', type = 'error', duration = 5000 })
        return
    end
    -- Itera sobre todos los jugadores para enviar el mensaje solo a los cercanos
    for _, targetPlayer in ipairs(GetPlayers()) do
        local targetPos = GetEntityCoords(GetPlayerPed(targetPlayer))
        local distance = #(playerPos - targetPos)

        if distance <= radioRange then
            TriggerClientEvent('chat:addMessage', targetPlayer, {
                template = '<div class="msg do"><i class="fas fa-comment"></i> <b><span style="color: #ffc107; font-size: 19px;">[DO] {0}</span>&nbsp;<span style="color: #e3a71b; font-size: 17px;">{1}</span></b><div style="margin-top: 2px; font-weight: 300;">',
                args = {playerName, message}
            })
        end
    end

    -- Registra el mensaje en el servidor de registro
    
    local discordMessage = string.format(
            "Citizenid:** %s\n**Ingame ID:** %d\n**Name:** %s %s\n**Message::** %s**",
            Player.PlayerData.citizenid,
            Player.PlayerData.cid,
            Player.PlayerData.charinfo.firstname,
            Player.PlayerData.charinfo.lastname,
            msg
        )
    sendToDiscord(16753920,	"chat | DO", discordMessage, "Chating for RSG Framework", "chatme")
    -- TriggerEvent('rsg-log:server:CreateLog', 'do', 'do', 'white', '' .. GetPlayerName(source) .. ' (CitizenID: ' .. Player.PlayerData.citizenid .. ' | ID: ' .. source .. ') Message: ' .. message, false)
end, false)

--restart announcement

local times = {
    [1800] = '30 minutes',
    [900] = '15 minutes',
    [600] = '10 minutes',
    [300] = '5 minutes',
    [240] = '4 minutes',
    [180] = '3 minutes',
    [120] = '2 minutes',
    [60] = '1 minute. Please disconnect now.',
}

AddEventHandler('txAdmin:events:announcement', function(data)
	local time = os.date(Config.DateFormat)
    TriggerClientEvent('chat:addMessage', -1, {
        template = '<div class="chat-message staff"><i class="fa-solid fa-desktop"></i> <b><span style="color: #1ebc62">[ANNOUNCEMENT]</span>&nbsp;<span style="font-size: 14px; color: #e1e1e1;">{1}</span></b><div style="margin-top: 5px; font-weight: 300;">{0}</div></div>',
        args = { data.message, time }
    })
end)

AddEventHandler('txAdmin:events:scheduledRestart', function(data)
	local time = os.date(Config.DateFormat)
    TriggerClientEvent('chat:addMessage', -1, {
        template = '<div class="chat-message staff"><i class="fa-solid fa-desktop"></i> <b><span style="color: #1ebc62">[ANNOUNCEMENT]</span>&nbsp;<span style="font-size: 14px; color: #e1e1e1;">{1}</span></b><div style="margin-top: 5px; font-weight: 300;">{0}</div></div>',
        args = { 'This server is scheduled to restart in ' .. times[data.secondsRemaining], time }
    })
end)

function getPlayersWithStaffRoles()
    local players = {}
    for k, v in ipairs(RSGCore.Functions.GetPlayers()) do
        for k, x in ipairs(Config.StaffGroups) do
            if RSGCore.Functions.GetPermission(v) == x then
                table.insert(players, v)
                break
            end
        end
    end

    return players
end
