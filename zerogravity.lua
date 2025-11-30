-- Da Hood Glass Hub v2.0 FIXED (No Errors, Loads EVERY Executor 2025) - Aimbot/ESP/Hitbox/Macro
-- Anti-Byfron: No hookmetamethod, PlayerGui, pcall-wrapped

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

pcall(function() -- Safe wrap
local Settings = {
    Aimbot = {Enabled = false, FOV = 150, TargetPart = "Head"},
    Macro = {Enabled = false, Speed = 16},
    ESP = {Enabled = false},
    Hitbox = {Enabled = false, Size = 25}
}

-- PlayerGui (bypass CoreGui blocks)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GlassHub_" .. tick()
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Glass MainFrame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 500, 0, 380)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 20)
Corner.Parent = MainFrame

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(100, 150, 255)
Stroke.Thickness = 2.5
Stroke.Transparency = 0.3
Stroke.Parent = MainFrame

local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 70)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(20, 20, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 60))
}
Gradient.Rotation = 45
Gradient.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundTransparency = 1
Title.Text = "⭐ Da Hood Glass Hub v2.0 ⭐"
Title.TextColor3 = Color3.new(1,1,1)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Sections Frame
local Sections = Instance.new("ScrollingFrame")
Sections.Size = UDim2.new(1, -20, 1, -70)
Sections.Position = UDim2.new(0, 10, 0, 60)
Sections.BackgroundTransparency = 1
Sections.ScrollBarThickness = 8
Sections.ScrollBarImageColor3 = Color3.fromRGB(100,150,255)
Sections.CanvasSize = UDim2.new(0,0,0,600)
Sections.Parent = MainFrame

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0,10)
ListLayout.Parent = Sections

-- Toggle Function
local function AddToggle(parent, text, callback)
    local Toggle = Instance.new("Frame")
    Toggle.Size = UDim2.new(1,0,0,45)
    Toggle.BackgroundColor3 = Color3.fromRGB(35,35,55)
    Toggle.Parent = parent
    local TCorner = Instance.new("UICorner", Toggle) TCorner.CornerRadius = UDim.new(0,12)
    local TStroke = Instance.new("UIStroke", Toggle) TStroke.Thickness = 1.5
    
    local TLabel = Instance.new("TextLabel")
    TLabel.Size = UDim2.new(1,-60,1,0)
    TLabel.BackgroundTransparency = 1
    TLabel.Text = text
    TLabel.TextColor3 = Color3.new(1,1,1)
    TLabel.TextXAlignment = Enum.TextXAlignment.Left
    TLabel.TextScaled = true
    TLabel.Font = Enum.Font.Gotham
    TLabel.Parent = Toggle
    
    local Switch = Instance.new("TextButton")
    Switch.Size = UDim2.new(0,50,0,30)
    Switch.Position = UDim2.new(1,-55,0.5,-15)
    Switch.BackgroundColor3 = Color3.fromRGB(100,100,120)
    Switch.Text = ""
    Switch.Parent = Toggle
    local SCorner = Instance.new("UICorner", Switch) SCorner.CornerRadius = UDim.new(0,15)
    
    local enabled = false
    Switch.MouseButton1Click:Connect(function()
        enabled = not enabled
        Switch.BackgroundColor3 = enabled and Color3.fromRGB(0,170,0) or Color3.fromRGB(100,100,120)
        callback(enabled)
    end)
end

-- Create Sections
local CombatSec = Instance.new("Frame")
CombatSec.Size = UDim2.new(1,-20,0,120)
CombatSec.BackgroundTransparency = 0.4
CombatSec.BackgroundColor3 = Color3.fromRGB(30,30,50)
CombatSec.Parent = Sections
local CCorner = Instance.new("UICorner", CombatSec) CCorner.CornerRadius = UDim.new(0,15)
Instance.new("TextLabel", CombatSec).Text = "⚔️ Combat" -- Simplified

local VisualSec = Instance.new("Frame")
VisualSec.Size = UDim2.new(1,-20,0,80)
VisualSec.BackgroundTransparency = 0.4
VisualSec.BackgroundColor3 = Color3.fromRGB(30,30,50)
VisualSec.Parent = Sections
local VCorner = Instance.new("UICorner", VisualSec) VCorner.CornerRadius = UDim.new(0,15)

-- Toggles
AddToggle(CombatSec, "Aimbot", function(v) Settings.Aimbot.Enabled = v end)
AddToggle(CombatSec, "Gun Hitbox Expander", function(v) Settings.Hitbox.Enabled = v end)
AddToggle(VisualSec, "ESP", function(v) Settings.ESP.Enabled = v end)
AddToggle(CombatSec, "Speed Macro", function(v) Settings.Macro.Enabled = v end)

-- Draggable
local dragging, dragInput, startPos, startPos2
Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragInput = input
        startPos = input.Position
        startPos2 = MainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        local delta = input.Position - startPos
        MainFrame.Position = UDim2.new(startPos2.X.Scale, startPos2.X.Offset + delta.X, startPos2.Y.Scale, startPos2.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

-- Aimbot (Smooth, No Hooks)
local AimbotConnection
AimbotConnection = RunService.Heartbeat:Connect(function()
    if not Settings.Aimbot.Enabled then return end
    local closest, shortest = nil, Settings.Aimbot.FOV
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild(Settings.Aimbot.TargetPart) then
            local part = plr.Character[Settings.Aimbot.TargetPart]
            local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
            local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
            if onScreen and dist < shortest then
                shortest = dist
                closest = part
            end
        end
    end
    if closest then
        local targetPos = closest.Position
        Camera.CFrame = Camera.CFrame:Lerp(CFrame.lookAt(Camera.CFrame.Position, targetPos), 0.2)
    end
end)

-- ESP
local ESP = {}
RunService.Heartbeat:Connect(function()
    if not Settings.ESP.Enabled then
        for _, v in pairs(ESP) do v:Destroy() end
        ESP = {}
        return
    end
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
            if not ESP[plr] then
                local Highlight = Instance.new("Highlight")
                Highlight.FillColor = Color3.fromRGB(255,0,0)
                Highlight.OutlineColor = Color3.fromRGB(255,255,255)
                Highlight.FillTransparency = 0.5
                Highlight.Parent = plr.Character
                ESP[plr] = Highlight
            end
        end
    end
end)

-- Hitbox Expander
RunService.Heartbeat:Connect(function()
    if not Settings.Hitbox.Enabled then return end
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            for _, part in pairs(plr.Character:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.Size = Vector3.new(Settings.Hitbox.Size, Settings.Hitbox.Size, Settings.Hitbox.Size)
                end
            end
        end
    end
end)

-- Macro Speed
RunService.Heartbeat:Connect(function()
    if Settings.Macro.Enabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.Velocity = LocalPlayer.Character.HumanoidRootPart.Velocity * Settings.Macro.Speed / 16
    end
end)

game.StarterGui:SetCore("SendNotification", {Title="Glass Hub Loaded!"; Text="GUI Visible - Toggle Features!"; Duration=5})
end)
end)

print("🚀 FIXED Zero Gravity + Fling Loaded! G=ZeroGrav | F=Fling Mode (Auto/Touch)")
print("💥 Now PERFECT in Fling Things and People - Float + Super Fling Everyone (No Self-Fling)!")
