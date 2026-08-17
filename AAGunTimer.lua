if game.GameId == 1359573625 then

-- Kill previous instance
if _G.AAGunTimer then
    _G.AAGunTimer.running = false
    if _G.AAGunTimer.conn then _G.AAGunTimer.conn:Disconnect() end
    if _G.AAGunTimer.timerText then _G.AAGunTimer.timerText:Remove() end
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local lp = Players.LocalPlayer

local timer = 10
local running = true
local stableFrames = 0
local STABLE_THRESHOLD = 3

local timerText = Drawing.new("Text")
timerText.Size = 28
timerText.Center = true
timerText.Outline = true
timerText.Color = Color3.fromRGB(255, 255, 255)
timerText.Font = 2
    timerText.Position = Vector2.new(Workspace.CurrentCamera.ViewportSize.X / 2, 135)
timerText.Visible = true
timerText.Text = "10.00"

local params = RaycastParams.new()
params.FilterType = Enum.RaycastFilterType.Exclude
params.RespectCanCollide = true

local RAY_DIST = 1.0
local DIRS = {
    Vector3.new(0, -1, 0),
    Vector3.new(0, 1, 0),
    Vector3.new(1, 0, 0),
    Vector3.new(-1, 0, 0),
    Vector3.new(0, 0, 1),
    Vector3.new(0, 0, -1),
}

local function isTouchingAny()
    local char = lp.Character
    if not char then return true end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return true end

    params.FilterDescendantsInstances = {char}

    local origin = root.Position
    for _, dir in ipairs(DIRS) do
        local result = Workspace:Raycast(origin, dir * RAY_DIST, params)
        if result and not result.Instance:IsDescendantOf(char) then
            return true
        end
    end

    local head = char:FindFirstChild("Head")
    if head then
        for _, dir in ipairs(DIRS) do
            local result = Workspace:Raycast(head.Position, dir * RAY_DIST, params)
            if result and not result.Instance:IsDescendantOf(char) then
                return true
            end
        end
    end

    return false
end

local function isGrounded()
    local char = lp.Character
    if not char then return true end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return true end

    params.FilterDescendantsInstances = {char}

    local vel = root.AssemblyLinearVelocity
    if math.abs(vel.Y) > 0.5 then
        stableFrames = 0
        return false
    end

    local origin = root.Position + Vector3.new(0, 0.5, 0)
    local down = Vector3.new(0, -4, 0)
    local result = Workspace:Raycast(origin, down, params)

    if not result or result.Instance:IsDescendantOf(char) then
        stableFrames = 0
        return false
    end

    stableFrames = stableFrames + 1
    return stableFrames >= STABLE_THRESHOLD
end

local conn
conn = RunService.RenderStepped:Connect(function(dt)
    if not running then return end
timerText.Position = Vector2.new(Workspace.CurrentCamera.ViewportSize.X / 2, 135)

    if isGrounded() or isTouchingAny() then
        timer = 10
    else
        timer = timer - dt
    end

    if timer < 0 then timer = 0 end

    timerText.Text = string.format("%.2f", timer)

    if timer <= 3 then
        timerText.Color = Color3.fromRGB(255, 80, 80)
    elseif timer <= 6 then
        timerText.Color = Color3.fromRGB(255, 255, 80)
    else
        timerText.Color = Color3.fromRGB(255, 255, 255)
    end
end)

_G.AAGunTimer = { running = running, conn = conn, timerText = timerText }

print("AAGunTimer loaded. Previous instances killed.")

else
    print("AAGunTimer: Not in Deepwoken. Aborting.")
end
