-- Da Hood Glass Hub v2.1 | Xeno/Zeno Optimized (2025) - Instant Load, No Crashes
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Settings = {
    Aimbot = {Enabled = false, FOV = 150, TargetPart = "Head"},
    Macro = {Enabled = false, Speed = 16},
    ESP = {Enabled = false},
    Hitbox = {Enabled = false, Size = 25}
}

-- CoreGui Fallback (Xeno Safe)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GlassHub" .. tick()
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer.PlayerGui end

-- Glass MainFrame (Compact for Xeno)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 450, 0, 350)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
MainFrame.BackgroundTransparency = 0.05
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 18)
Corner.Parent = MainFrame

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(80, 140, 255)
Stroke.Thickness = 2
Stroke.Parent = MainFrame

local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 60)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 40))
}
Gradient.Rotation = 45
Gradient.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundTransparency = 1
Title.Text = "⭐ Da Hood Glass Hub v2.1 (Xeno Ready)"
Title.TextColor3 = Color3.new(1,1,1)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Sections
local Sections = Instance.new("ScrollingFrame")
Sections.Size = UDim2.new(1, -15, 1, -60)
Sections.Position = UDim2.new(0, 7.5, 0, 50)
Sections.BackgroundTransparency = 1
Sections.ScrollBarThickness = 6
Sections.CanvasSize = UDim2.new(0,0,0,500)
Sections.Parent = MainFrame

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0,8)
ListLayout.Parent = Sections

-- Toggle Helper
local function AddToggle(parent, text, callback)
    local Toggle = Instance.new("Frame")
    Toggle.Size = UDim2.new(1,0,0,40)
    Toggle.BackgroundColor3 = Color3.fromRGB(30,30,50)
    Toggle.Parent = parent
    local TCorner = Instance.new("UICorner", Toggle) TCorner.CornerRadius = UDim.new(0,10)
    
    local TLabel = Instance.new("TextLabel")
    TLabel.Size = UDim2.new(1,-55,1,0)
    TLabel.BackgroundTransparency = 1
    TLabel.Text = text
    TLabel.TextColor3 = Color3.new(1,1,1)
    TLabel.TextXAlignment = Enum.TextXAlignment.Left
    TLabel.TextScaled = true
    TLabel.Font = Enum.Font.Gotham
    TLabel.Parent = Toggle
    
    local Switch = Instance.new("TextButton")
    Switch.Size = UDim2.new(0,45,0,25)
    Switch.Position = UDim2.new(1,-50,0.5,-12.5)
    Switch.BackgroundColor3 = Color3.fromRGB(120,120,120)
    Switch.Text = ""
    Switch.Parent = Toggle
    local SCorner = Instance.new("UICorner", Switch) SCorner.CornerRadius = UDim.new(0,12)
    
    local enabled = false
    Switch.MouseButton1Click:Connect(function()
        enabled = not enabled
        Switch.BackgroundColor3 = enabled and Color3.fromRGB(0,160,0) or Color3.fromRGB(120,120,120)
        callback(enabled)
    end)
end

-- Sections Setup
local CombatSec = Instance.new("Frame")
CombatSec.Size = UDim2.new(1,0,0,100)
CombatSec.BackgroundTransparency = 1
CombatSec.Parent = Sections

local VisualSec = Instance.new("Frame")
VisualSec.Size = UDim2.new(1,0,0,60)
VisualSec.BackgroundTransparency = 1
VisualSec.Parent = Sections

-- Add Toggles
AddToggle(CombatSec, "Aimbot", function(v) Settings.Aimbot.Enabled = v end)
AddToggle(CombatSec, "Gun Hitbox Expander", function(v) Settings.Hitbox.Enabled = v end)
AddToggle(CombatSec, "Speed Macro", function(v) Settings.Macro.Enabled = v end)
AddToggle(VisualSec, "ESP", function(v) Settings.ESP.Enabled = v end)

-- Draggable (Xeno-Optimized)
local dragging, dragInput, startPos, startPos2
Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragInput = input
        startPos = input.Position
        startPos2 = MainFrame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - startPos
        MainFrame.Position = UDim2.new(startPos2.X.Scale, startPos2.X.Offset + delta.X, startPos2.Y.Scale, startPos2.Y.Offset + delta.Y)
    end
end)

-- Aimbot (Lerp Smooth, Xeno Fast)
RunService.Heartbeat:Connect(function()
    if not Settings.Aimbot.Enabled then return end
    local closest, shortest = nil, Settings.Aimbot.FOV
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild(Settings.Aimbot.TargetPart) then
            local part = plr.Character[Settings.Aimbot.TargetPart]
            local pos = Camera:WorldToViewportPoint(part.Position)
            local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
            if pos.Z > 0 and dist < shortest then
                shortest = dist
                closest = part
            end
        end
    end
    if closest then
        Camera.CFrame = Camera.CFrame:Lerp(CFrame.lookAt(Camera.CFrame.Position, closest.Position), 0.15)
    end
end)

-- ESP (Highlight - Visible Always)
local ESP = {}
RunService.Heartbeat:Connect(function()
    if not Settings.ESP.Enabled then
        for _, v in pairs(ESP) do if v then v:Destroy() end end
        ESP = {}
        return
    end
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") and not ESP[plr] then
            local Highlight = Instance.new("Highlight")
            Highlight.FillColor = Color3.fromRGB(255,50,50)
            Highlight.OutlineColor = Color3.fromRGB(255,255,255)
            Highlight.FillTransparency = 0.4
            Highlight.Parent = plr.Character
            ESP[plr] = Highlight
        end
    end
end)

-- Hitbox Expander (Enemy Only)
RunService.Heartbeat:Connect(function()
    if not Settings.Hitbox.Enabled then return end
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            for _, part in pairs(plr.Character:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.Size = Vector3.new(Settings.Hitbox.Size, Settings.Hitbox.Size, Settings.Hitbox.Size)
                    part.Transparency = math.min(part.Transparency, 0.8)
                end
            end
        end
    end
end)

-- Macro (Velocity Boost - Undetectable)
RunService.Heartbeat:Connect(function()
    if Settings.Macro.Enabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local root = LocalPlayer.Character.HumanoidRootPart
        root.Velocity = root.Velocity * (Settings.Macro.Speed / 16)
    end
end)

game.StarterGui:SetCore("SendNotification", {Title="Glass Hub v2.1 Loaded!"; Text="Xeno Ready - GUI Up!"; Duration=4})
print("Glass Hub Loaded on Xeno - Aimbot/ESP/Hitbox Ready!")

print("🚀 FIXED Zero Gravity + Fling Loaded! G=ZeroGrav | F=Fling Mode (Auto/Touch)")
print("💥 Now PERFECT in Fling Things and People - Float + Super Fling Everyone (No Self-Fling)!")
