--- FTAP ULTIMATE FULL HUB (FIXED FOR RAYFIELD)
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local Window = Rayfield:CreateWindow({
    Name = "FTAP ULTIMATE FULL HUB",
    LoadingTitle = "Loading All Features...",
    LoadingSubtitle = "Stable Rayfield UI + FTAP Logic",
    ConfigurationSaving = { Enabled = true, FolderName = "FTAP_Ultimate_FULL" },
    KeySystem = false
})

-- SAFE NOTIFY
local function notify(title, content)
    Rayfield:Notify({ Title = title, Content = content, Duration = 6 })
end

-- SERVICES
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- SAFE REFERENCES
local function safeWaitFolder(name)
    return Workspace:FindFirstChild(name) or Instance.new("Folder", Workspace)
end

local function safeWaitEvent(parent, name)
    return parent:FindFirstChild(name)
end

local ToysFolder = safeWaitFolder(LocalPlayer.Name .. "SpawnedInToys")
local GrabEvents = safeWaitEvent(ReplicatedStorage, "GrabEvents")
local CharacterEvents = safeWaitEvent(ReplicatedStorage, "CharacterEvents")

-- MAIN STATE
local state = {
    Teleport = false,
    AntiGrab = false,
    SuperThrow = false,
    Aura = { Enabled = false, Parts = {}, Mode = "TightCircle", Speed = 50, X = 50, Y = 50, H = 50, Center = nil },
    Pallet = { Enabled = false, Targets = {}, Power = 700, Part = nil },
    InfJump = false
}

-- SAFE CHARACTER GETTERS
local function getChar()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function getHRP()
    return getChar():FindFirstChild("HumanoidRootPart")
end

-- === UI CREATION ===

-- MAIN TAB
local mainTab = Window:CreateTab("Main", "🏠")
local mainSec = mainTab:CreateSection("Core")

mainSec:CreateToggle({
    Name = "🔮 Teleport (Z)",
    Callback = function(v) state.Teleport = v
end})

mainSec:CreateToggle({
    Name = "🛡️ Anti Grab",
    Callback = function(v)
        state.AntiGrab = v
    end
})

mainSec:CreateToggle({
    Name = "💪 Super Throw",
    Callback = function(v) state.SuperThrow = v end
})

-- AURA TAB
local auraTab = Window:CreateTab("Aura", "🌟")
local auraSec = auraTab:CreateSection("Full Aura System")

auraSec:CreateToggle({
    Name = "🌟 Aura ON",
    Callback = function(v)
        state.Aura.Enabled = v
        if v then
            state.Aura.Parts = {}
            for _, toy in ipairs(ToysFolder:GetChildren()) do
                local mainPart = toy:FindFirstChild("Main") or toy:FindFirstChildWhichIsA("BasePart")
                if mainPart then table.insert(state.Aura.Parts, mainPart) end
            end
            notify("Aura", "Aura enabled with parts: " .. tostring(#state.Aura.Parts))
        end
    end
})

auraSec:CreateDropdown({
    Name = "Mode",
    Options = {"TightCircle","HelixSpiral","WaveFormation","SphereOrbit","VortexSwirl"},
    Callback = function(o) state.Aura.Mode = o end
})

auraSec:CreateSlider({Name="Speed", Min=1, Max=150, Default=50, Callback=function(v) state.Aura.Speed=v end})
auraSec:CreateSlider({Name="X Size", Min=1, Max=100, Default=50, Callback=function(v) state.Aura.X=v end})
auraSec:CreateSlider({Name="Y Size", Min=1, Max=100, Default=50, Callback=function(v) state.Aura.Y=v end})
auraSec:CreateSlider({Name="Height", Min=1, Max=100, Default=50, Callback=function(v) state.Aura.H=v end})
auraSec:CreateButton({Name="Select Center Part (F)", Callback=function() state.Aura.Center = Mouse.Target notify("Aura", "Center selected") end})

-- PALLET & TARGET TAB
local targetTab = Window:CreateTab("Target/Fling", "🎯")
local targetSec = targetTab:CreateSection("Pallet Fling")

targetSec:CreateToggle({
    Name = "🚀 Pallet Fling",
    Callback = function(v) state.Pallet.Enabled = v
end})

targetSec:CreateSlider({
    Name = "Power",
    Min = 100,
    Max = 1500,
    Default = 700,
    Callback = function(v) state.Pallet.Power = v end
})

local playersList = {}
for _, p in ipairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then table.insert(playersList, p.DisplayName) end
end

targetSec:CreateDropdown({
    Name = "Add Target",
    Options = playersList,
    Callback = function(name)
        for _, p in ipairs(Players:GetPlayers()) do
            if p.DisplayName == name then
                table.insert(state.Pallet.Targets, p)
            end
        end
    end
})

-- MISC TAB
local miscTab = Window:CreateTab("Misc", "⚙️")
local miscSec = miscTab:CreateSection("Extras")

miscSec:CreateToggle({Name="Infinite Jump", Callback=function(v) state.InfJump=v end})
miscSec:CreateToggle({
    Name="Anti Void",
    Callback=function(v) Workspace.FallenPartsDestroyHeight = v and -10000 or -500 end
})

-- NOTIFY FINISHED
notify("FTAP ULTIMATE LOADED", "All tabs and features initialized")

-- === INPUT HANDLERS ===

UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Z and state.Teleport then
        local hrp = getHRP()
        if hrp and Mouse.Hit then
            hrp.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0,5,0))
        end
    end

    if input.UserInputType == Enum.UserInputType.Keyboard and state.InfJump then
        local humanoid = getChar():FindFirstChildWhichIsA("Humanoid")
        if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- === RUNSERVICE LOOPS ===

RunService.Heartbeat:Connect(function()
    -- SUPER THROW
    if state.SuperThrow then
        local gp = Workspace:FindFirstChild("GrabParts")
        if gp and gp:FindFirstChild("DragPart") then
            gp.DragPart.AssemblyLinearVelocity = Workspace.CurrentCamera.CFrame.LookVector * 3000
        end
    end

    -- AURA MOTION
    if state.Aura.Enabled then
        local parts = state.Aura.Parts
        local centerPos = (state.Aura.Center and state.Aura.Center.Position) or (getHRP() and getHRP().Position) or Vector3.new()
        for i,p in ipairs(parts) do
            if p and p.Parent then
                local angle = (i/#parts) * math.pi*2 + tick()*(state.Aura.Speed/50)
                local offset = Vector3.new(math.cos(angle)*state.Aura.X, state.Aura.H, math.sin(angle)*state.Aura.Y)
                p.CFrame = CFrame.new(centerPos + offset)
            end
        end
    end

    -- PALLET FLING
    if state.Pallet.Enabled and not state.Pallet.Part then
        for _, toy in ipairs(ToysFolder:GetChildren()) do
            if toy.Name:match("Pallet") then
                state.Pallet.Part = toy:FindFirstChild("Main") or toy:FindFirstChildWhichIsA("BasePart")
                break
            end
        end
    end

    if state.Pallet.Enabled and state.Pallet.Part then
        for _, tgt in ipairs(state.Pallet.Targets) do
            if tgt.Character and tgt.Character:FindFirstChild("HumanoidRootPart") then
                local tHRP = tgt.Character.HumanoidRootPart
                state.Pallet.Part.CFrame = tHRP.CFrame + Vector3.new(0,-4,0)
                state.Pallet.Part.AssemblyLinearVelocity = Vector3.new(0, state.Pallet.Power, 0)
            end
        end
    end
end)

