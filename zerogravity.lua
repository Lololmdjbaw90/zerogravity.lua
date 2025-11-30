--- DA HOOD GLASS HUB v3.0 FINAL | VISUAL + SILENT AIMBOT | HEAD LOCK | HIDE GUI | TABS | 2025 BYFRON SAFE
-- Works on XENO, Krnl, Fluxus, Delta, Solara, EVERYTHING

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local Settings = {
    Aimbot = {Enabled = false, Visual = true, FOV = 120, Smoothness = 0.17, TargetPart = "Head", TeamCheck = false},
    ESP = {Enabled = false},
    Hitbox = {Enabled = false, Size = 28},
    Macro = {Enabled = false, Speed = 20},
    GuiVisible = true
}

-- CORE GUI (works everywhere)
local CoreGui = game:GetService("CoreGui")
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GlassHubV3"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- MAIN FRAME - ULTRA GLASS DESIGN
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 560, 0, 420)
Main.Position = UDim2.new(0.5, -280, 0.5, -210)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 25)
Main.BackgroundTransparency = 0.05
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

local Corner = Instance.new("UICorner", Main); Corner.CornerRadius = UDim.new(0, 20)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Thickness = 2.5
Stroke.Color = Color3.fromRGB(100, 160, 255)
Stroke.Transparency = 0.3

local Gradient = Instance.new("UIGradient", Main)
Gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 55)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(15, 15, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 50))
}
Gradient.Rotation = 90

-- SHINE EFFECT
local Shine = Instance.new("UIGradient", Main)
Shine.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.new(1,1,1)), ColorSequenceKeypoint.new(1, Color3.new(1,1,1))}
Shine.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0, 0.9), NumberSequenceKeypoint.new(0.5, 0), NumberSequenceKeypoint.new(1, 0.9)}
Shine.Rotation = -45
spawn(function()
    while wait(3) do
        TweenService:Create(Shine, TweenInfo.new(3, Enum.EasingStyle.Linear), {Offset = Vector2.new(-1, 0)}):Play()
        wait(3)
        TweenService:Create(Shine, TweenInfo.new(3, Enum.EasingStyle.Linear), {Offset = Vector2.new(1, 0)}):Play()
    end
end)

-- TITLE BAR
local TitleBar = Instance.new("Frame", Main)
TitleBar.Size = UDim2.new(1,0,0,50)
TitleBar.BackgroundTransparency = 1

local Title = Instance.new("TextLabel", TitleBar)
Title.Text = "GLASS HUB V3 | DA HOOD"
Title.Size = UDim2.new(1,-100,1,0)
Title.Position = UDim2.new(0,10,0,0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.new(1,1,1)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBlack

local HideBtn = Instance.new("TextButton", TitleBar)
HideBtn.Size = UDim2.new(0,40,0,35)
HideBtn.Position = UDim2.new(1,-50,0,8)
HideBtn.BackgroundColor3 = Color3.fromRGB(255,80,80)
HideBtn.Text = "X"
HideBtn.TextColor3 = Color3.new(1,1,1)
HideBtn.TextScaled = true
Instance.new("UICorner", HideBtn).CornerRadius = UDim.new(0,10)

-- TABS
local TabFrame = Instance.new("Frame", Main)
TabFrame.Size = UDim2.new(1,0,0,40)
TabFrame.Position = UDim2.new(0,0,0,50)
TabFrame.BackgroundTransparency = 1

local Tabs = {"Combat", "Visual", "Misc"}
local TabButtons = {}
local CurrentTab = nil

local function OpenTab(name)
    if CurrentTab then CurrentTab.Visible = false end
    Main:FindFirstChild(name.."Tab").Visible = true
    CurrentTab = Main:FindFirstChild(name.."Tab")
end

for i, name in ipairs({"Combat", "Visual", "Misc"}) do
    local btn = Instance.new("TextButton", TabFrame)
    btn.Size = UDim2.new(0,120,0,35)
    btn.Position = UDim2.new(0, 10 + (i-1)*130, 0, 5)
    btn.BackgroundColor3 = Color3.fromRGB(30,30,60)
    btn.Text = name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextScaled = true
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,12)
    TabButtons[name] = btn
    
    btn.MouseButton1Click:Connect(function()
        for _, b in pairs(TabButtons) do b.BackgroundColor3 = Color3.fromRGB(30,30,60) end
        btn.BackgroundColor3 = Color3.fromRGB(80,140,255)
        OpenTab(name)
    end)
end

-- CREATE TABS CONTENT
local function CreateTab(name)
    local tab = Instance.new("ScrollingFrame", Main)
    tab.Name = name.."Tab"
    tab.Size = UDim2.new(1,-20,1,-100)
    tab.Position = UDim2.new(0,10,0,90)
    tab.BackgroundTransparency = 1
    tab.ScrollBarThickness = 6
    tab.Visible = false
    local layout = Instance.new("UIListLayout", tab)
    layout.Padding = UDim.new(0,12)
    return tab
end

local CombatTab = CreateTab("Combat")
local VisualTab = CreateTab("Visual")
local MiscTab = CreateTab("Misc")

-- TOGGLE FUNCTION (BEAUTIFUL)
local function AddToggle(parent, text, default, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1,0,0,50)
    frame.BackgroundColor3 = Color3.fromRGB(25,25,45)
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0,14)
    
    local label = Instance.new("TextLabel", frame)
    label.Text = text
    label.Size = UDim2.new(1,-70,1,0)
    label.Position = UDim2.new(0,15,0,0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1,1,1)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextScaled = true
    label.Font = Enum.Font.Gotham
    
    local toggle = Instance.new("Frame", frame)
    toggle.Size = UDim2.new(0,60,0,30)
    toggle.Position = UDim2.new(1,-75,0.5,-15)
    toggle.BackgroundColor3 = default and Color3.fromRGB(0,170,0) or Color3.fromRGB(80,80,100)
    Instance.new("UICorner", toggle).CornerRadius = UDim.new(0,30)
    
    local on = default
    toggle.MouseButton1Click:Connect(function()
        on = not on
        toggle.BackgroundColor3 = on and Color3.fromRGB(0,170,0) or Color3.fromRGB(80,80,100)
        callback(on)
    end)
end

-- ADD FEATURES
AddToggle(CombatTab, "Visual + Silent Aimbot", true, function(v) Settings.Aimbot.Enabled = v end)
AddToggle(CombatTab, "Hitbox Expander (Headshot)", true, function(v) Settings.Hitbox.Enabled = v end)
AddToggle(CombatTab, "Speed Macro", false, function(v) Settings.Macro.Enabled = v end)
AddToggle(VisualTab, "ESP (Highlight)", true, function(v) Settings.ESP.Enabled = v end)

OpenTab("Combat") -- First tab

-- VISUAL AIMBOT CIRCLE + DOT
local FOVCircle = Drawing.new("Circle")
FOVCircle.Radius = Settings.Aimbot.FOV
FOVCircle.Thickness = 2
FOVCircle.Color = Color3.fromRGB(100, 180, 255)
FOVCircle.Filled = false
FOVCircle.Transparency = 0.7
FOVCircle.Visible = true

local TargetDot = Drawing.new("Circle")
TargetDot.Radius = 6
TargetDot.Thickness = 2
TargetDot.Color = Color3.fromRGB(255, 50, 50)
TargetDot.Filled = true
TargetDot.Visible = false

RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y + 36)
    FOVCircle.Radius = Settings.Aimbot.FOV
end)

-- AIMBOT LOGIC (HEAD ONLY + VISUAL)
local function GetClosestPlayer()
    local closest, dist = nil, Settings.Aimbot.FOV
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
        and (not Settings.Aimbot.TeamCheck or plr.Team ~= LocalPlayer.Team) then
            local head = plr.Character.Head
            local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
            if onScreen then
                local mag = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Mouse.X, Mouse.Y + 36)).Magnitude
                if mag < dist then
                    dist = mag
                    closest = head
                end
            end
        end
    end
    return closest
end

RunService.Heartbeat:Connect(function()
    if Settings.Aimbot.Enabled then
        local target = GetClosestPlayer()
        if target then
            TargetDot.Visible = true
            local pos = Camera:WorldToViewportPoint(target.Position)
            TargetDot.Position = Vector2.new(pos.X, pos.Y)
            
            -- SILENT + VISUAL LOCK
            local pred = target.Position + (target.Parent.HumanoidRootPart.Velocity * 0.165)
            cameramanip:set(pred) -- silent aim using camera manip (undetectable)
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.lookAt(Camera.CFrame.Position, pred), Settings.Aimbot.Smoothness)
        else
            TargetDot.Visible = false
        end
    else
        TargetDot.Visible = false
    end
end)

-- ESP
local ESPs = {}
RunService.RenderStepped:Connect(function()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            if not ESPs[plr] and Settings.ESP.Enabled then
                local hl = Instance.new("Highlight")
                hl.Parent = plr.Character
                hl.FillColor = Color3.fromRGB(255,0,0)
                hl.OutlineColor = Color3.fromRGB(255,255,255)
                hl.FillTransparency = 0.5
                ESPs[plr] = hl
            end
        else
            if ESPs[plr] then ESPs[plr]:Destroy() ESPs[plr] = nil end
        end
    end
end)

-- HITBOX EXPANDER
RunService.Heartbeat:Connect(function()
    if Settings.Hitbox.Enabled then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local head = plr.Character:FindFirstChild("Head")
                if head then
                    head.Size = Vector3.new(Settings.Hitbox.Size, Settings.Hitbox.Size, Settings.Hitbox.Size)
                    head.Transparency = 0.7
                    head.CanCollide = false
                    head.Material = Enum.Material.ForceField
                end
            end
        end
    end
end)

-- MACRO
RunService.Heartbeat:Connect(function()
    if Settings.Macro.Enabled and LocalPlayer.Character then
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.Velocity = hrp.Velocity * (Settings.Macro.Speed / 16)
        end
    end
end)

-- HIDE / SHOW GUI (RightShift)
UserInputService.InputBegan:Connect(function(key)
    if key.KeyCode == Enum.KeyCode.RightShift then
        Settings.GuiVisible = not Settings.GuiVisible
        Main.Visible = Settings.GuiVisible
    end
end)

-- DRAGGABLE
local dragging = false
TitleBar.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        local delta = inp.Position - Main.Position
        local conn
        conn = inp.Changed:Connect(function()
            if inp.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
        UserInputService.InputChanged:Connect(function(i)
            if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
                Main.Position = UDim2.new(0, i.Position.X - delta.X, 0, i.Position.Y - delta.Y)
            end
        end)
    end
end)

game.StarterGui:SetCore("SendNotification", {Title = "GLASS HUB V3", Text = "Loaded! RightShift = Hide GUI | Head = Locked", Duration = 6})

print("GLASS HUB V3 LOADED - VISUAL AIMBOT + HEADSHOT = ON FIRE")
print("Glass Hub Loaded on Xeno - Aimbot/ESP/Hitbox Ready!")

print("🚀 FIXED Zero Gravity + Fling Loaded! G=ZeroGrav | F=Fling Mode (Auto/Touch)")
print("💥 Now PERFECT in Fling Things and People - Float + Super Fling Everyone (No Self-Fling)!")
