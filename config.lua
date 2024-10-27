Config = {}
--------------------------------
-- [Date Format]

Config.DateFormat = '%H:%M' -- To change the date format check this website - https://www.lua.org/pil/22.1.html

-- [Staff Groups]

Config.StaffGroups = {
    'god',
    'admin'
}

Config.EnableReportCommand = true
Config.ReportCommand = 'report'

-- [Clear Player Chat]
Config.AllowPlayersToClearTheirChat = true
Config.ClearChatCommand = 'clear'

-- [Staff]
Config.EnableStaffCommand = true
Config.StaffCommand = 'announce'
Config.AllowStaffsToClearEveryonesChat = true
Config.ClearEveryonesChatCommand = 'clearall'

-- [Staff Only Chat]
Config.EnableStaffOnlyCommand = true
Config.StaffOnlyCommand = 'adminchat'

-- [Advertisements]
Config.EnableAdvertisementCommand = true
Config.AdvertisementCommand = 'advert'
Config.AdvertisementPrice = 5
Config.AdvertisementCooldown = 5 -- in minutes

-- [valentine]
Config.EnableValentineCommand = false
Config.ValentineCommand = 'valentine'
Config.ValentineJobName = 'valentine'

-- [Rhodes]
Config.EnableRhodesCommand = false
Config.RhodesCommand = 'rhodes'
Config.RhodesJobName = 'rhodes'

-- [reply]
Config.EnablereplyCommand = true
Config.replyCommand = 'reply'

-- [gossip]
Config.EnablegossipCommand = true
Config.gossipCommand = 'gossip'

-- [auxilio]
Config.EnableauxilioCommand = true
Config.auxilioCommand = 'auxilio'

-- [respuesta]
Config.EnablrespuestaCommand = true
Config.respuestaCommand = 'respuesta'

-- [testigo]
Config.EnabletestigoCommand = true
Config.testigoCommand = 'testigo'

-- [rumor]
Config.EnablerumorCommand = true
Config.rumorCommand = 'rumor'

-- [mp]
Config.EnablempCommand = true
Config.mpCommand = 'mp'

-------------------------
-- EXTRA Webhooks / RANKING
-----------------------
Config.Webhooks = {
    ["chatreport"] = "https://discord.com/api/webhooks/1260635717483233310/JsHUhvjyWoJOLgTnPATvM-Gl7p7kYZnbdsF48VNjZ2i6OuS81RxqIDgZ1G2_GUq3QtBN",
    ["chatooc"] = "https://discord.com/api/webhooks/1260635625137115227/8cwmcP9DQEllBaTix2ulkz8Z_XOnp1af0JZMPyw1cH2IQZ4PRoekWmgn9520R7Tn-S-m",
    ["chatme"] = "https://discord.com/api/webhooks/1260635797539786834/r0QnbzAeFLRhVtW9Xy4F3DxRYbQTeznIykgA2qD7NJS5cV_rCKHdZLSek6xvF7jJrjsR",
    ["chatdo"] = "https://discord.com/api/webhooks/1260635881979510945/QmA_nM075Na8CAw-_z5bChmc65wXtNK9ihe_Jganz5iWeqCwSo8PrzFfHhY3UADf6p2f",
    ["chatrumor"] = "https://discord.com/api/webhooks/1260635955874762803/F9SI-BK0FpVg29WTnR7wTzjXMb5W9oZGzaWPur-m8sWGfC9hc8HhNWiLgLv70tx7b-jo",
    ["chatrumoric"] = "https://discord.com/api/webhooks/1257638072858968105/Wzog2bgrEApeLvXnAenhGRE9a26x80V5OuAL-aamlNnuCbuAvBqlZ1b-KgrZuV5esJ9W",
}