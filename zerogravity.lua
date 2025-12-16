-- FTAP ULTIMATE FULL HUB (RAYFIELD SAFE / NO CRASH)

-- Load Rayfield
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "FTAP ULTIMATE FULL HUB",
    LoadingTitle = "FTAP Ultimate",
    LoadingSubtitle = "All Features Loaded Safely",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "FTAP_Ultimate_Full"
    },
    KeySystem = false
})

local function notify(t, c)
    Rayfield:Notify({
        Title = t,
        Content = c,
        Duration = 6
    })
end

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- SAFE CHARACTER GETTERS
local function getCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function getHRP()
    local char = getCharacter()
    return char:FindFirstChild("HumanoidRootPart")
end

local function getHumanoid()
    local char = getCharacter()
    return char:FindFirstChildOfClass("Humanoid")
end

-- SAFE FOLDERS (NO WAITFORCHILD)
local ToysFolder =
    Workspace:FindFirstChild(LocalPlayer.Name .. "SpawnedInToys")
    or Instance.new("Folder", Workspace)

-- =========================
-- STATE
-- =========================
local State = {
    Teleport = false,
    SuperThrow = false,
    AntiGrab = false,
    InfiniteJump = false,

    Aura = {
        Enabled = false,
        Parts = {},
        Speed = 50,
        Radius = 40
    },

    Pallet = {
        Enabled = false,
        Power = 700,
        Targets = {},
        Part = nil
    }
}

-- =========================
-- UI TABS (VALID ICONS ONLY)
-- =========================

local MainTab   = Window:CreateTab("Main", "home")
local AuraTab   = Window:CreateTab("Aura", "star")
local TargetTab = Window:CreateTab("Target / Fling", "target")
local MiscTab   = Window:CreateTab("Misc", "settings")

-- =========================
-- MAIN TAB
-- =========================

local Main = MainTab:CreateSection("Core")

Main:CreateToggle({
    Name = "Teleport to Mouse (Z)",
    Callback = function(v)
        State.Teleport = v
    end
})

Main:CreateToggle({
    Name = "Super Throw",
    Callback = function(v)
        State.SuperThrow = v
    end
})

Main:CreateToggle({
    Name = "Anti Grab",
    Callback = function(v)
        State.AntiGrab = v
    end
})

-- =========================
-- AURA TAB
-- =========================

local Aura = AuraTab:CreateSection("Aura System")

Aura:CreateToggle({
    Name = "Enable Aura",
    Callback = function(v)
        State.Aura.Enabled = v
        if v then
            State.Aura.Parts = {}
            for _, toy in ipairs(ToysFolder:GetChildren()) do
                local part = toy:FindFirstChild("Main") or toy:FindFirstChildWhichIsA("BasePart")
                if part then
                    table.insert(State.Aura.Parts, part)
                end
            end
            notify("Aura", "Collected " .. #State.Aura.Parts .. " parts")
        end
    end
})

Aura:CreateSlider({
    Name = "Aura Speed",
    Range = {1, 150},
    Increment = 1,
    CurrentValue = 50,
    Callback = function(v)
        State.Aura.Speed = v
    end
})

Aura:CreateSlider({
    Name = "Aura Radius",
    Range = {5, 100},
    Increment = 1,
    CurrentValue = 40,
    Callback = function(v)
        State.Aura.Radius = v
    end
})

-- =========================
-- TARGET / FLING TAB
-- =========================

local Target = TargetTab:CreateSection("Pallet Fling")

Target:CreateToggle({
    Name = "Enable Pallet Fling",
    Callback = function(v)
        State.Pallet.Enabled = v
    end
})

Target:CreateSlider({
    Name = "Fling Power",
    Range = {100, 1500},
    Increment = 50,
    CurrentValue = 700,
    Callback = function(v)
        State.Pallet.Power = v
    end
})

local playerNames = {}
for _, p in ipairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then
        table.insert(playerNames, p.DisplayName)
    end
end

Target:CreateDropdown({
    Name = "Add Target",
    Options = playerNames,
    Callback = function(name)
        for _, p in ipairs(Players:GetPlayers()) do
            if p.DisplayName == name then
                table.insert(State.Pallet.Targets, p)
                notify("Target Added", name)
                break
            end
        end
    end
})

-- =========================
-- MISC TAB
-- =========================

local Misc = MiscTab:CreateSection("Misc")

Misc:CreateToggle({
    Name = "Infinite Jump",
    Callback = function(v)
        State.InfiniteJump = v
    end
})

Misc:CreateToggle({
    Name = "Anti Void",
    Callback = function(v)
        Workspace.FallenPartsDestroyHeight = v and -10000 or -500
    end
})

-- =========================
-- INPUT
-- =========================

UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Z and State.Teleport then
        local hrp = getHRP()
        if hrp and Mouse.Hit then
            hrp.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 5, 0))
        end
    end

    if State.InfiniteJump and input.UserInputType == Enum.UserInputType.Keyboard then
        local hum = getHumanoid()
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- =========================
-- LOOPS
-- =========================

RunService.Heartbeat:Connect(function()
    -- Super Throw
    if State.SuperThrow then
        local gp = Workspace:FindFirstChild("GrabParts")
        if gp and gp:FindFirstChild("DragPart") then
            gp.DragPart.AssemblyLinearVelocity =
                Workspace.CurrentCamera.CFrame.LookVector * 3000
        end
    end

    -- Aura
    if State.Aura.Enabled then
        local hrp = getHRP()
        if hrp then
            for i, part in ipairs(State.Aura.Parts) do
                if part and part.Parent then
                    local angle =
                        (i / #State.Aura.Parts) * math.pi * 2
                        + tick() * (State.Aura.Speed / 50)

                    part.CFrame =
                        hrp.CFrame *
                        CFrame.new(
                            math.cos(angle) * State.Aura.Radius,
                            3,
                            math.sin(angle) * State.Aura.Radius
                        )
                end
            end
        end
    end

    -- Pallet Fling
    if State.Pallet.Enabled then
        if not State.Pallet.Part then
            for _, toy in ipairs(ToysFolder:GetChildren()) do
                if toy.Name:lower():find("pallet") then
                    State.Pallet.Part =
                        toy:FindFirstChild("Main")
                        or toy:FindFirstChildWhichIsA("BasePart")
                    break
                end
            end
        end

        if State.Pallet.Part then
            for _, tgt in ipairs(State.Pallet.Targets) do
                if tgt.Character and tgt.Character:FindFirstChild("HumanoidRootPart") then
                    local thrp = tgt.Character.HumanoidRootPart
                    State.Pallet.Part.CFrame = thrp.CFrame + Vector3.new(0, -4, 0)
                    State.Pallet.Part.AssemblyLinearVelocity =
                        Vector3.new(0, State.Pallet.Power, 0)
                end
            end
        end
    end
end)

notify("FTAP Hub Loaded", "All features initialized successfully")
print("FTAP ULTIMATE FULL HUB LOADED")

