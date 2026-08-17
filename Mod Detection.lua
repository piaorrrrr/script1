-- Configuration
local trackedUsers = {
	"cruxbeard",
	"melonbeard",
	"Naktigonis",
	"EttheKing",
	"Kustarii",
	"astro_train",
	"Auchura",
	"Narutorobert",
	"elkheng",
	"uninvert",
	"detestdoot",
	"eIkhang",
	"Ragoozer",
	"Arch_Mage",
	"Agamatsu",
	"Lawtamos",
	"Zartania",
	"AfroDs",
	"rJeneration",
	"KAHAEL",
	"Hautdesert",
	"EstheKing",
	"Nuttoons",
	"Corylus_Avellana",
	"K1LLUAA",
	"yayafino",
	"SnakeWor1",
	"Dexerius",
	"Melon_Sensei",
	"Zaruthax",
	"Snaliel",
	"elijahbutter",
	"Zintenka",
	"Konrekhelm",
	"minkle",
	"Chicken_Man",
	"alphstrich",
	"adjns",
	"toast80e",
	"kampopball",
	"guslouzada",
	"TheCoolerFlashFire20",
	"Rhimirim",
	"hummelbua",
	"theburns23",
	"killer67564564643",
	"TheRealPunchee",
	"vezplaw",
	"HorrorTM",
	"DeadNotBigSurprise",
	"s1eepster",
	"0OAmnesiaO0",
	"WateryDragonLord",
	"VlZYRA",
	"FidgetyBacchus",
	"Po_lter",
	"Jonekkj",
	"NightSurge",
	"ViolentlyAmmy",
	"VampyreUnicorn",
	"Metapoly",
	"3pyro2",
	"Kearlyu",
	"joshuared",
	"iArteria",
	"dabbytoast",
	"TheTrueWeird",
	"Pureceus",
	"Firranos",
	"jamestheboss234567",
	"KeelerBot",
	"hio3600",
	"WorkyClock",
	"Voidsealer",
	"sploinkst",
	"katomized",
	"Kohai_Kodoku",
	"Noble919",
	"v_sheep",
	"crazywealth",
	"Torrera",
	"Solvanor",
	"Kark1n0s",
	"Shinomelia",
	"FernOfTheHalls",
	"gui2000z3",
	"VermillionSpy",
	"Xelskii",
	"UnderscoreBOX_BOX",
	"dolecly",
	"grasslord24",
	"Divinos",
	"larshdcraft",
	"hahamike6",
	"nakyounie",
	"Will10188",
	"pu_ck",
	"b_rownee",
	"BrabTeal",
	"HordeOne",
	"portskydiver",
	"Anflare",
	"NatPLAY2005",
	"OraOraAltener",
	"P0roKun",
	"micuuh",
	"Wormcaved",
	"Nogora22",
	"RTFalleN",
	"ValekisYT",
	"s_supaa",
	"Reaconteur_Real",
	"NanoProdigy",
	"TheRealPunchee",
	"ilyDex",
	"Infernasu",
	"Raguza",
	"Dolphince",
	"deepwoken",
	"zakotb_youtube",
}

-- Ensure Drawing API is available
if not Drawing then
    error("Matcha Drawing API not found.")
end

-- Create the Persistent UI
local ui = Drawing.new("Text")
ui.Visible = true
ui.Size = 22
ui.Color = Color3.fromRGB(255, 255, 255)
ui.Outline = true
ui.Position = Vector2.new(20, 60)
ui.Text = "Matcha Tracker: Scanning..."

local Players = game:GetService("Players")

-- Convert target list to lowercase for faster/safer comparison
local targets = {}
for _, name in ipairs(trackedUsers) do
    table.insert(targets, string.lower(name))
end

-- This loop runs forever every 1 second
task.spawn(function()
    while true do
        local foundNames = {}
        local currentPlayerList = Players:GetPlayers()

        for _, player in ipairs(currentPlayerList) do
            -- Safety check for Matcha's environment
            if player and player.Name then
                local pName = string.lower(player.Name)
                local dName = player.DisplayName and string.lower(player.DisplayName) or ""

                -- Check if this player is a target
                for _, target in ipairs(targets) do
                    if pName == target or dName == target then
                        table.insert(foundNames, player.Name)
                        break
                    end
                end
            end
        end

        -- Update the UI based on the scan result
        if #foundNames > 0 then
            ui.Text = "[[[[[DETECTED]]]]]: " .. table.concat(foundNames, ", ")
            ui.Color = Color3.fromRGB(255, 50, 50) -- Red when targets are here
        else
            ui.Text = "<3 no one detected :3"
            ui.Color = Color3.fromRGB(255, 105, 180) -- Pink when clear
        end

        task.wait(1) -- Scan once per second
    end
end)