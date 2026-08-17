if game.GameId == 1359573625 then


--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

--// Local Player
local LocalPlayer = Players.LocalPlayer

--// Settings
local MAX_DISTANCE = 6500
local CLOSE_DISTANCE = 1250
local CLOSER_DISTANCE = 865
local CLOSEST_DISTANCE = 250

local GUI_WIDTH = 240
local GUI_PADDING = 10
local TEXT_SIZE = 18
local LINE_HEIGHT = 20
local BASE_HEIGHT = 40

local UPDATE_DELAY = 0.05
local Y_OFFSET = 0

--// Ignore list
local IGNORE = {
    ["rsgRGrtg"] = true,
    ["sugeyeaya"] = true,
    ["snapsnot019"] = true,
    ["spooooooo0okyy"] = true,
    ["ThisRandomGuy0"] = true,
    ["inatede"] = true,
    ["petitecheerIeader"] = true,
    ["BlueLeaver"] = true,
    ["sethilations"] = true,
    ["sniperassassin2001"] = true,
    ["vluwk"] = true,
    ["alrseebas"] = true,
    ["Aceisbuns12"] = true,
    ["oda1ba"] = true,
    ["xavic_09"] = true,
    ["gsgavsaf"] = true,
    ["Fozzy_O6"] = true,
    ["KELISCOLD"] = true,
    ["ChickidyDoodleFoodle"] = true,
    ["Aetherial_Light"] = true,
    ["0_0ksv"] = true,
    ["Snapshot_1219"] = true,
    ["veilishot"] = true,
}

--// Drawing Objects
local Background = Drawing.new("Square")
Background.Visible = true
Background.Filled = true
Background.Color = Color3.fromRGB(15, 15, 15)
Background.Thickness = 1

local Outline = Drawing.new("Square")
Outline.Visible = true
Outline.Filled = false
Outline.Thickness = 3
Outline.Color = Color3.fromRGB(0, 0, 0)

local Text = Drawing.new("Text")
Text.Visible = true
Text.Center = false
Text.Outline = true
Text.Font = 2
Text.Size = TEXT_SIZE
Text.Color = Color3.fromRGB(255, 255, 255)

--// Functions
local function getCharacterPosition(player)
    local character = player.Character

    if character and character:FindFirstChild("HumanoidRootPart") then
        return character.HumanoidRootPart.Position
    end

    return nil
end

local function getDistance(a, b)
    return (a - b).Magnitude
end

local function updateESP()
    local localPos = getCharacterPosition(LocalPlayer)

    if not localPos then
        Text.Text = "Loading..."
        return
    end

    local playerTable = {}
    local closestDistance = math.huge

    for _, player in ipairs(Players:GetPlayers()) do
        if not IGNORE[player.Name] then
            local pos = getCharacterPosition(player)

            if pos then
                local dist = getDistance(localPos, pos)

                if dist <= MAX_DISTANCE then
                    table.insert(playerTable, {
                        Name = player.Name,
                        Distance = math.floor(dist)
                    })

                    if dist < closestDistance then
                        closestDistance = dist
                    end
                end
            end
        end
    end

    -- Sort closest -> farthest
    table.sort(playerTable, function(a, b)
        return a.Distance < b.Distance
    end)

    -- Build text
    local lines = {}

    for _, data in ipairs(playerTable) do
        table.insert(lines,
            string.format("[%d] %s", data.Distance, data.Name)
        )
    end

    Text.Text = table.concat(lines, "\n")

    -- Dynamic height
    local totalHeight = math.max(
        BASE_HEIGHT,
        (#lines * LINE_HEIGHT) + (GUI_PADDING * 2)
    )

    -- Position
    local viewport = Camera.ViewportSize

    local posX = viewport.X - GUI_WIDTH - 20
    local posY = viewport.Y - totalHeight - 125 + Y_OFFSET

    -- Background
    Background.Size = Vector2.new(GUI_WIDTH, totalHeight)
    Background.Position = Vector2.new(posX, posY)

    -- Outline
    Outline.Size = Vector2.new(GUI_WIDTH + 4, totalHeight + 4)
    Outline.Position = Vector2.new(posX - 2, posY - 2)

    -- Text
    Text.Position = Vector2.new(
        posX + GUI_PADDING,
        posY + GUI_PADDING
    )

    -- Border Color
if closestDistance <= CLOSEST_DISTANCE then
    Outline.Color = Color3.fromRGB(51, 0, 225) -- purple (closest)

elseif closestDistance <= CLOSER_DISTANCE then
    Outline.Color = Color3.fromRGB(255, 69, 69) -- RED (very close)

elseif closestDistance <= CLOSE_DISTANCE then
    Outline.Color = Color3.fromRGB(237, 255, 59) -- YELLOW (medium)

else
    Outline.Color = Color3.fromRGB(0, 0, 0) -- default
	end
end

--// Loop
task.spawn(function()
    while true do
        pcall(updateESP)
        task.wait(UPDATE_DELAY)
    end
end)

else
    print("AAGunTimer: Not in Deepwoken. Aborting.")
end