-- FTAP FULL HUB - ULTRA OLD RAYFIELD (BUTTON ONLY)

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "FTAP FULL HUB",
    LoadingTitle = "FTAP",
    LoadingSubtitle = "Ultra-Old Rayfield Mode",
    ConfigurationSaving = {Enabled = false},
    KeySystem = false
})

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()

-- SAFE CHARACTER
local function char()
    return LP.Character or LP.CharacterAdded:Wait()
end

local function hrp()
    return char():FindFirstChild("HumanoidRootPart")
end

local function hum()
    return char():FindFirstChildOfClass("Humanoid")
end

-- TOYS
local ToysFolder =
    Workspace:FindFirstChild(LP.Name .. "SpawnedInToys")
    or Instance.new("Folder", Workspace)

-- ======================
-- STATE
-- ======================
local Teleport = false
local InfiniteJump = false
local SuperThrow = false
local AntiVoid = false
local Aura = false
local PalletFling = false

local AuraParts = {}
local PalletTargets = {}
local PalletPart = nil
local PalletPower = 700

-- ======================
-- TABS
-- ======================
Window:CreateTab("Main")
Window:CreateTab("Fun")
Window:CreateTab("Fling")
Window:CreateTab("Misc")

-- ======================
-- MAIN
-- ======================

Rayfield:CreateButton({
    Name = "Teleport to Mouse (Z) [OFF]",
    Callback = function()
        Teleport = not Teleport
        Rayfield:Notify({
            Title = "Teleport",
            Content = Teleport and "ON" or "OFF",
            Duration = 3
        })
    end
})

Rayfield:CreateButton({
    Name = "Infinite Jump [OFF]",
    Callback = function()
        InfiniteJump = not InfiniteJump
        Rayfield:Notify({
            Title = "Infinite Jump",
            Content = InfiniteJump and "ON" or "OFF",
            Duration = 3
        })
    end
})

Rayfield:CreateButton({
    Name = "Super Throw [OFF]",
    Callback = function()
        SuperThrow = not SuperThrow
        Rayfield:Notify({
            Title = "Super Throw",
            Content = SuperThrow and "ON" or "OFF",
            Duration = 3
        })
    end
})

-- ======================
-- FUN
-- ======================

Rayfield:CreateButton({
    Name = "Aura Orbit [OFF]",
    Callback = function()
        Aura = not Aura
        if Aura then
            AuraParts = {}
            for _, toy in ipairs(ToysFolder:GetChildren()) do
                local p =
                    toy:FindFirstChild("Main")
                    or toy:FindFirstChildWhichIsA("BasePart")
                if p then table.insert(AuraParts, p) end
            end
        end

        Rayfield:Notify({
            Title = "Aura",
            Content = Aura and "ON" or "OFF",
            Duration = 3
        })
    end
})

-- ======================
-- FLING
-- ======================

Rayfield:CreateButton({
    Name = "Pallet Fling [OFF]",
    Callback = function()
        PalletFling = not PalletFling
        Rayfield:Notify({
            Title = "Pallet Fling",
            Content = PalletFling and "ON" or "OFF",
            Duration = 3
        })
    end
})

Rayfield:CreateButton({
    Name = "Add ALL Players as Targets",
    Callback = function()
        PalletTargets = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP then
                table.insert(PalletTargets, p)
            end
        end
        Rayfield:Notify({
            Title = "Targets",
            Content = "All players added",
            Duration = 3
        })
    end
})

-- ======================
-- MISC
-- ======================

Rayfield:CreateButton({
    Name = "Anti Void [OFF]",
    Callback = function()
        AntiVoid = not AntiVoid
        Workspace.FallenPartsDestroyHeight = AntiVoid and -10000 or -500
        Rayfield:Notify({
            Title = "Anti Void",
            Content = AntiVoid and "ON" or "OFF",
            Duration = 3
        })
    end
})

-- ======================
-- INPUT
-- ======================

UIS.InputBegan:Connect(function(input)
    if Teleport and input.KeyCode == Enum.KeyCode.Z then
        if hrp() and Mouse.Hit then
            hrp().CFrame =
                CFrame.new(Mouse.Hit.Position + Vector3.new(0,5,0))
        end
    end

    if InfiniteJump and input.UserInputType == Enum.UserInputType.Keyboard then
        if hum() then
            hum():ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- ======================
-- LOOPS
-- ======================

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
    if Aura and hrp() then
        for i, p in ipairs(AuraParts) do
            if p and p.Parent then
                local angle = tick() + i
                p.CFrame =
                    hrp().CFrame *
                    CFrame.new(
                        math.cos(angle) * 25,
                        3,
                        math.sin(angle) * 25
                    )
            end
        end
    end

    -- Pallet Fling
    if PalletFling then
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
                    PalletPart.CFrame = thrp.CFrame + Vector3.new(0,-4,0)
                    PalletPart.AssemblyLinearVelocity =
                        Vector3.new(0, PalletPower, 0)
                end
            end
        end
    end
end)

Rayfield:Notify({
    Title = "FTAP HUB LOADED",
    Content = "Ultra-old Rayfield FULL hub loaded",
    Duration = 6
})

print("FTAP FULL HUB LOADED (ULTRA OLD RAYFIELD)")
