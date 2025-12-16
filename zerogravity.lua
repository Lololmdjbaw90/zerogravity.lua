-- FTAP ULTIMATE FULL HUB (RAYFIELD) — FIXED & FINAL

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local Window = Rayfield:CreateWindow({
    Name = "FTAP ULTIMATE FULL HUB",
    LoadingTitle = "Loading FTAP Features...",
    LoadingSubtitle = "Gravity & Extras Adapted",
    ConfigurationSaving = { Enabled = true, FolderName = "FTAP_Ultimate_FULL" },
    KeySystem = false
})

-- SERVICES
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- PLAYER
local function getChar()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function getHRP()
    local c = getChar()
    return c:FindFirstChild("HumanoidRootPart")
end

-- TOYS & EVENT FOLDERS
local ToysFolder = Workspace:WaitForChild(LocalPlayer.Name .. "SpawnedInToys")
local GrabEvents = RS:WaitForChild("GrabEvents")
local CharacterEvents = RS:WaitForChild("CharacterEvents")

-- STATE
local state = {
    Teleport = false,
    AntiGrab = false,
    SuperThrow = false,
    Aura = { Enabled = false, Parts = {}, Mode = "TightCircle", Speed = 50, X = 50, Y = 50, H = 50, Center = nil },
    Pallet = { Enabled = false, Targets = {}, Power = 700, Part = nil }
}

-- UTILS
local function notify(title, content, dur)
    Rayfield:Notify({ Title = title, Content = content, Duration = dur or 5 })
end

-- MAIN TAB
local mainTab = Window:CreateTab("Main", "🏠")
local mainSec = mainTab:CreateSection("Core")

mainSec:CreateToggle({ Name = "🔮 Teleport (Z)", Callback = function(v) state.Teleport = v end })
mainSec:CreateToggle({
    Name = "🛡️ Anti Grab",
    Callback = function(v)
        state.AntiGrab = v
        if v then
            task.spawn(function()
                while state.AntiGrab do
                    local c = getChar()
                    if c and c:FindFirstChild("IsHeld") and c.IsHeld.Value then
                        CharacterEvents.Struggle:FireServer(LocalPlayer)
                    end
                    task.wait(0.1)
                end
            end)
        end
    end
})

mainSec:CreateToggle({
    Name = "💪 Super Throw",
    Callback = function(v)
        state.SuperThrow = v
    end
})

UIS.InputBegan:Connect(function(input)
    if state.Teleport and input.KeyCode == Enum.KeyCode.Z then
        local hit = Mouse.Hit
        if hit then
            getHRP().CFrame = CFrame.new(hit.Position + Vector3.new(0, 5, 0))
        end
    end
end)

-- SUPER THROW LOOP
RunService.Heartbeat:Connect(function()
    if state.SuperThrow then
        local gp = Workspace:FindFirstChild("GrabParts")
        if gp and gp:FindFirstChild("DragPart") then
            gp.DragPart.AssemblyLinearVelocity = Workspace.CurrentCamera.CFrame.LookVector * 3000
        end
    end
end)

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
                local main = toy:FindFirstChild("Main") or toy:FindFirstChildWhichIsA("BasePart")
                if main then table.insert(state.Aura.Parts, main) end
            end
        end
    end
})

auraSec:CreateDropdown({
    Name = "Mode",
    Options = { "TightCircle", "HelixSpiral", "WaveFormation", "SphereOrbit", "VortexSwirl" },
    Callback = function(o) state.Aura.Mode = o end
})

auraSec:CreateSlider({ Name = "Speed", Min = 1, Max = 150, Default = 50, Callback = function(v) state.Aura.Speed = v end })
auraSec:CreateSlider({ Name = "X Size", Min = 1, Max = 100, Default = 50, Callback = function(v) state.Aura.X = v end })
auraSec:CreateSlider({ Name = "Y Size", Min = 1, Max = 100, Default = 50, Callback = function(v) state.Aura.Y = v end })
auraSec:CreateSlider({ Name = "Height", Min = 1, Max = 100, Default = 50, Callback = function(v) state.Aura.H = v end })
auraSec:CreateButton({
    Name = "Select General Part (F)",
    Callback = function()
        state.Aura.Center = Mouse.Target
        notify("Selected", state.Aura.Center and state.Aura.Center.Name or "None")
    end
})

RunService.Heartbeat:Connect(function()
    if state.Aura.Enabled then
        local parts = state.Aura.Parts
        local centerPos = state.Aura.Center and state.Aura.Center.Position or getHRP().Position
        for i, p in ipairs(parts) do
            local angle = (i / #parts) * math.pi * 2 + tick() * (state.Aura.Speed / 50)
            local offset = Vector3.new(math.cos(angle) * state.Aura.X, state.Aura.H, math.sin(angle) * state.Aura.Y)
            p.CFrame = CFrame.new(centerPos + offset)
            p.AssemblyAngularVelocity = Vector3.new(0, 100, 0)
        end
    end
end)

-- TARGET/Fling TAB
local targetTab = Window:CreateTab("Target/Fling", "🎯🚀")
local targetSec = targetTab:CreateSection("Pallet Fling")

targetSec:CreateToggle({
    Name = "🚀 Pallet Fling",
    Callback = function(v)
        state.Pallet.Enabled = v
        if v then
            for _, toy in ipairs(ToysFolder:GetChildren()) do
                if toy.Name:match("Pallet") then
                    state.Pallet.Part = toy:FindFirstChild("Main") or toy:FindFirstChildWhichIsA("BasePart")
                    break
                end
            end
            if not state.Pallet.Part then
                notify("No pallet found", "Place a pallet toy first!")
            end
        end
    end
})

targetSec:CreateSlider({
    Name = "Power",
    Min = 100,
    Max = 1500,
    Default = 700,
    Callback = function(v) state.Pallet.Power = v end
})

-- populate dropdown
local list = {}
for _, p in ipairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then table.insert(list, p.DisplayName) end
end
targetSec:CreateDropdown({
    Name = "Add Target",
    Options = list,
    Callback = function(name)
        for _, p in ipairs(Players:GetPlayers()) do
            if p.DisplayName == name then
                table.insert(state.Pallet.Targets, p)
                break
            end
        end
    end
})

RunService.Heartbeat:Connect(function()
    if state.Pallet.Enabled and state.Pallet.Part then
        for _, tgt in ipairs(state.Pallet.Targets) do
            if tgt.Character and tgt.Character:FindFirstChild("HumanoidRootPart") then
                local tHRP = tgt.Character.HumanoidRootPart
                state.Pallet.Part.CFrame = tHRP.CFrame + Vector3.new(0, -4, 0)
                state.Pallet.Part.AssemblyLinearVelocity = Vector3.new(0, state.Pallet.Power, 0)
            end
        end
    end
end)

-- MISC STUFF (placeholders you can expand similarly)
local miscTab = Window:CreateTab("Misc", "⚙️")
local miscSec = miscTab:CreateSection("Extras")

miscSec:CreateToggle({ Name = "Infinite Jump", Callback = function(v) state.InfJump = v end })
miscSec:CreateToggle({
    Name = "Anti Void",
    Callback = function(v)
        Workspace.FallenPartsDestroyHeight = v and -10000 or -500
    end
})

UIS.InputBegan:Connect(function(input)
    if state.InfJump and input.UserInputType == Enum.UserInputType.Keyboard then
        getChar().Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- FINISHED
notify("FTAP ULTIMATE HUB LOADED", "All core systems initialized", 10)
print("FTAP ULTIMATE HUB READY")
