-- FTAP ULTIMATE FULL HUB (OLD RAYFIELD COMPATIBLE)

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "FTAP ULTIMATE FULL HUB",
    LoadingTitle = "FTAP Ultimate",
    LoadingSubtitle = "Old Rayfield Compatible",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "FTAP_Ultimate_Full"
    },
    KeySystem = false
})

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- SAFE CHARACTER
local function getChar()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function getHRP()
    return getChar():FindFirstChild("HumanoidRootPart")
end

local function getHumanoid()
    return getChar():FindFirstChildOfClass("Humanoid")
end

-- SAFE TOYS FOLDER
local ToysFolder =
    Workspace:FindFirstChild(LocalPlayer.Name .. "SpawnedInToys")
    or Instance.new("Folder", Workspace)

-- =====================
-- STATE
-- =====================
local Teleport = false
local InfiniteJump = false
local SuperThrow = false
local AntiVoid = false

local WalkSpeed = 16

-- Aura
local AuraEnabled = false
local AuraRadius = 35
local AuraSpeed = 50
local AuraParts = {}

-- Pallet
local PalletEnabled = false
local PalletPower = 700
local PalletTargets = {}
local PalletPart = nil

-- =====================
-- TABS (VALID ICONS)
-- =====================
Window:CreateTab("Main", "home")
Window:CreateTab("Aura", "star")
Window:CreateTab("Fling", "target")
Window:CreateTab("Misc", "settings")

-- =====================
-- MAIN FEATURES
-- =====================

Rayfield:CreateToggle({
    Name = "Teleport to Mouse (Z)",
    CurrentValue = false,
    Callback = function(v)
        Teleport = v
    end
})

Rayfield:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Callback = function(v)
        InfiniteJump = v
    end
})

Rayfield:CreateToggle({
    Name = "Super Throw",
    CurrentValue = false,
    Callback = function(v)
        SuperThrow = v
    end
})

Rayfield:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 150},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(v)
        WalkSpeed = v
        local hum = getHumanoid()
        if hum then
            hum.WalkSpeed = v
        end
    end
})

-- =====================
-- AURA
-- =====================

Rayfield:CreateToggle({
    Name = "Enable Aura",
    CurrentValue = false,
    Callback = function(v)
        AuraEnabled = v
        if v then
            AuraParts = {}
            for _, toy in ipairs(ToysFolder:GetChildren()) do
                local part =
                    toy:FindFirstChild("Main")
                    or toy:FindFirstChildWhichIsA("BasePart")
                if part then
                    table.insert(AuraParts, part)
                end
            end
        end
    end
})

Rayfield:CreateSlider({
    Name = "Aura Radius",
    Range = {10, 100},
    Increment = 1,
    CurrentValue = 35,
    Callback = function(v)
        AuraRadius = v
    end
})

Rayfield:CreateSlider({
    Name = "Aura Speed",
    Range = {1, 150},
    Increment = 1,
    CurrentValue = 50,
    Callback = function(v)
        AuraSpeed = v
    end
})

-- =====================
-- PALLET FLING
-- =====================

Rayfield:CreateToggle({
    Name = "Pallet Fling",
    CurrentValue = false,
    Callback = function(v)
        PalletEnabled = v
    end
})

Rayfield:CreateSlider({
    Name = "Pallet Power",
    Range = {100, 1500},
    Increment = 50,
    CurrentValue = 700,
    Callback = function(v)
        PalletPower = v
    end
})

local PlayerNames = {}
for _, p in ipairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then
        table.insert(PlayerNames, p.DisplayName)
    end
end

Rayfield:CreateDropdown({
    Name = "Add Target",
    Options = PlayerNames,
    Callback = function(name)
        for _, p in ipairs(Players:GetPlayers()) do
            if p.DisplayName == name then
                table.insert(PalletTargets, p)
            end
        end
    end
})

-- =====================
-- MISC
-- =====================

Rayfield:CreateToggle({
    Name = "Anti Void",
    CurrentValue = false,
    Callback = function(v)
        AntiVoid = v
        Workspace.FallenPartsDestroyHeight = v and -10000 or -500
    end
})

-- =====================
-- INPUT
-- =====================

UIS.InputBegan:Connect(function(input)
    if Teleport and input.KeyCode == Enum.KeyCode.Z then
        local hrp = getHRP()
        if hrp and Mouse.Hit then
            hrp.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 5, 0))
        end
    end

    if InfiniteJump and input.UserInputType == Enum.UserInputType.Keyboard then
        local hum = getHumanoid()
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- =====================
-- LOOPS
-- =====================

RunService.Heartbeat:Connect(function()
    -- Super Throw
    if SuperThrow then
        local gp = Workspace:FindFirstChild("GrabParts")
        if gp and gp:FindFirstChild("DragPart") then
            gp.DragPart.AssemblyLinearVelocity =
                Workspace.CurrentCamera.CFrame.LookVector * 3000
        end
    end

    -- Aura
    if AuraEnabled then
        local hrp = getHRP()
        if hrp then
            for i, part in ipairs(AuraParts) do
                if part and part.Parent then
                    local angle =
                        (i / #AuraParts) * math.pi * 2
                        + tick() * (AuraSpeed / 50)

                    part.CFrame =
                        hrp.CFrame *
                        CFrame.new(
                            math.cos(angle) * AuraRadius,
                            3,
                            math.sin(angle) * AuraRadius
                        )
                end
            end
        end
    end

    -- Pallet Fling
    if PalletEnabled then
        if not PalletPart then
            for _, toy in ipairs(ToysFolder:GetChildren()) do
                if toy.Name:lower():find("pallet") then
                    PalletPart =
                        toy:FindFirstChild("Main")
                        or toy:FindFirstChildWhichIsA("BasePart")
                    break
                end
            end
        end

        if PalletPart then
            for _, tgt in ipairs(PalletTargets) do
                if tgt.Character and tgt.Character:FindFirstChild("HumanoidRootPart") then
                    local thrp = tgt.Character.HumanoidRootPart
                    PalletPart.CFrame = thrp.CFrame + Vector3.new(0, -4, 0)
                    PalletPart.AssemblyLinearVelocity =
                        Vector3.new(0, PalletPower, 0)
                end
            end
        end
    end
end)

Rayfield:Notify({
    Title = "FTAP HUB LOADED",
    Content = "All features loaded successfully",
    Duration = 6
})

print("FTAP ULTIMATE FULL HUB LOADED")

notify("FTAP Hub Loaded", "All features initialized successfully")
print("FTAP ULTIMATE FULL HUB LOADED")

