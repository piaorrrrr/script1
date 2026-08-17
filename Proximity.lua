if game.GameId == 1359573625 then

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer

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

if _G._proxCleanup then
    _G._proxCleanup()
end

local RANGE = 2500
local running = true
local closestName = nil
local closestDist = nil

local display = Drawing.new("Text")
display.Size = 20
display.Center = true
display.Outline = true
display.Font = 2
display.Visible = true

local distDisplay = Drawing.new("Text")
distDisplay.Size = 20
distDisplay.Center = false
distDisplay.Outline = true
distDisplay.Font = 2
distDisplay.Visible = true

local conn
conn = RunService.RenderStepped:Connect(function()
    local cam = workspace.CurrentCamera
    local vp = cam and cam.ViewportSize or Vector2.new(960, 540)

    if closestName and closestDist then
        display.Center = false
        display.Text = closestName .. " is nearby! "
        display.Color = Color3.fromRGB(255, 105, 180)
        distDisplay.Center = false
        distDisplay.Text = "[" .. tostring(math.floor(closestDist)) .. "]"
        distDisplay.Color = Color3.fromRGB(255, 255, 255)
        distDisplay.Visible = true

        local w1 = display.TextBounds.X
        local w2 = distDisplay.TextBounds.X
        local totalW = w1 + w2 + 15
        local startX = vp.X / 2 - totalW / 2
        display.Position = Vector2.new(startX, 90)
        distDisplay.Position = Vector2.new(startX + w1 + 15, 90)
    else
        display.Center = false
        display.Text = "Nobody is nearby!"
        display.Color = Color3.fromRGB(200, 200, 200)
        local w = display.TextBounds.X
        display.Position = Vector2.new(vp.X / 2 - w / 2, 90)
        distDisplay.Visible = false
    end
end)

task.spawn(function()
    while running do
        local myChar = lp.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")

        if myRoot then
            local myPos = myRoot.Position
            local bestName = nil
            local bestDist = RANGE + 1

            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= lp and not IGNORE[plr.Name] then
                    local char = plr.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    if root then
                        local d = (root.Position - myPos).Magnitude
                        if d <= RANGE and d < bestDist then
                            bestDist = d
                            bestName = plr.Name
                        end
                    end
                end
            end

            closestName = bestName
            closestDist = bestDist
        else
            closestName = nil
            closestDist = nil
        end

        task.wait(0.05)
    end
end)

_G._proxCleanup = function()
    running = false
    conn:Disconnect()
    display:Remove()
    distDisplay:Remove()
    _G._proxCleanup = nil
end

print("Proximity detector running!")

else
    print("Proximity: Not in Deepwoken. Aborting.")
end
