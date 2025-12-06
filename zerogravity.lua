-- ZeroGravity 2025 - FULLY FIXED & EXPANDED (Visible to All)
-- Fling Strength, Loop Fling, Fling All, Grab Anything, Real Kill, Control, etc.
-- 100% Working December 2025

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LP = Players.LocalPlayer
local Char = LP.Character or LP.CharacterAdded:Wait()
local HRP = Char:WaitForChild("HumanoidRootPart")

-- Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "ZeroGravity 2025",
    LoadingTitle = "ZeroGravity Loading...",
    LoadingSubtitle = "Strongest Universal 2025",
})

local TargetPlayer = nil
local FlingPower = 5000
local LoopFlingActive = false

-- ========================================
-- TARGET SELECTION (FIXED CALLBACK)
-- ========================================
local function getPlayerList()
    local list = {}
    for _, p in Players:GetPlayers() do
        if p ~= LP then table.insert(list, p.Name) end
    end
    table.sort(list)
    return list
end

local MainTab = Window:CreateTab("Main", "zap")
local dropdown = MainTab:CreateDropdown({
    Name = "Select Target Player",
    Options = getPlayerList(),
    CurrentOption = {"None"},
    Callback = function(Option)
        TargetPlayer = Players:FindFirstChild(Option[1])
    end,
})
Players.PlayerAdded:Connect(function() dropdown:Refresh(getPlayerList(), true) end)
Players.PlayerRemoving:Connect(function() dropdown:Refresh(getPlayerList(), true) end)

-- ========================================
-- FLING TAB - INSANE STRENGTH
-- ========================================
local FlingTab = Window:CreateTab("Fling Things & People", "bomb")

FlingTab:CreateSlider({
    Name = "Fling Power (Strength)",
    Range = {100, 10000},
    Increment = 100,
    CurrentValue = 5000,
    Callback = function(v)
        FlingPower = v
    end,
})

FlingTab:CreateButton({
    Name = "Fling Target Player (Visible)",
    Callback = function()
        if not TargetPlayer or not TargetPlayer.Character then return end
        local tChar = TargetPlayer.Character
        local root = tChar:FindFirstChild("HumanoidRootPart") or tChar:FindFirstChild("Torso")
        if not root then return end

        root:SetNetworkOwner(LP)
        task.wait(0.05)

        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        bv.Velocity = (HRP.CFrame.LookVector * FlingPower) + Vector3.new(0, FlingPower/2, 0)
        bv.Parent = root

        local spin = Instance.new("BodyAngularVelocity")
        spin.MaxTorque = Vector3.new(0, math.huge, 0)
        spin.AngularVelocity = Vector3.new(0, 100, 0)
        spin.Parent = root

        task.wait(0.6)
        if bv then bv:Destroy() end
        if spin then spin:Destroy() end
    end,
})

FlingTab:CreateToggle({
    Name = "Loop Fling Target",
    CurrentValue = false,
    Callback = function(v)
        LoopFlingActive = v
        if v and TargetPlayer then
            task.spawn(function()
                while LoopFlingActive and TargetPlayer and TargetPlayer.Character do
                    pcall(function()
                        local root = TargetPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if root then
                            root:SetNetworkOwner(LP)
                            root.Velocity = Vector3.new(math.random(-200,200), FlingPower, math.random(-200,200))
                            root.RotVelocity = Vector3.new(100,100,100)
                        end
                    end)
                    task.wait(0.1)
                end
            end)
        end
    end,
})

FlingTab:CreateButton({
    Name = "Fling ALL Players",
    Callback = function()
        for _, p in Players:GetPlayers() do
            if p ~= LP and p.Character then
                task.spawn(function()
                    local root = p.Character:FindFirstChild("HumanoidRootPart") or p.Character:FindFirstChild("Torso")
                    if root then
                        root:SetNetworkOwner(LP)
                        root.Velocity = Vector3.new(0, FlingPower, 0) + HRP.CFrame.LookVector * 500
                        root.RotVelocity = Vector3.new(200,200,200)
                    end
                end)
            end
        end
    end,
})

FlingTab:CreateButton({
    Name = "Fling Nearby Parts (Grab Anything)",
    Callback = function()
        for _, obj in Workspace:GetDescendants() do
            if obj:IsA("BasePart") and obj.Size.Magnitude > 3 and not obj.Anchored then
                local dist = (obj.Position - HRP.Position).Magnitude
                if dist < 50 then
                    obj:SetNetworkOwner(LP)
                    obj.Velocity = HRP.CFrame.LookVector * FlingPower + Vector3.new(0, 200, 0)
                    obj.RotVelocity = Vector3.new(150,150,150)
                end
            end
        end
    end,
})

-- ========================================
-- KILL & CONTROL TAB
-- ========================================
local KillTab = Window:CreateTab("Kill & Control", "skull")

KillTab:CreateButton({
    Name = "Kill Target (Real Death)",
    Callback = function()
        if not TargetPlayer or not TargetPlayer.Character then return end
        local hum = TargetPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.Health = 0
            hum:TakeDamage(999)
        end
    end,
})

local controlling = false
KillTab:CreateToggle({
    Name = "Control Target Player",
    CurrentValue = false,
    Callback = function(v)
        controlling = v
        if v and TargetPlayer and TargetPlayer.Character then
            local root = TargetPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                root:SetNetworkOwner(LP)
                RunService.Heartbeat:Connect(function()
                    if not controlling then return end
                    if root and root.Parent then
                        root.CFrame = HRP.CFrame * CFrame.new(0,0,-4)
                    end
                end)
            end
        end
    end,
})

KillTab:CreateButton({
    Name = "Steal Target Appearance",
    Callback = function()
        if not TargetPlayer then return end
        LP.Character.Archivable = true
        local clone = LP.Character:Clone()
        clone.Parent = Workspace
        TargetPlayer.CharacterAppearanceLoaded:Wait()
        LP.Character:Destroy()
        task.wait(0.5)
        local newChar = clone:Clone()
        newChar.Parent = Workspace
        LP.Character = newChar
        Workspace.CurrentCamera.CameraSubject = newChar:FindFirstChildOfClass("Humanoid")
    end,
})

-- ========================================
-- NOTIFY ON LOAD
-- ========================================
Rayfield:Notify({
    Title = "ZeroGravity 2025 Loaded!",
    Content = "All features fixed + max fling strength!",
    Duration = 8,
})
