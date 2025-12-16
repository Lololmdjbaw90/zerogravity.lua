-- FTAP FULL HUB - ULTRA OLD RAYFIELD SAFE

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "FTAP FULL HUB",
    LoadingTitle = "FTAP",
    LoadingSubtitle = "Ultra Old Rayfield Mode",
    ConfigurationSaving = {Enabled=false},
    KeySystem = false
})

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()

-- SAFE CHAR
local function char()
    return LP.Character or LP.CharacterAdded:Wait()
end

local function hrp()
    return char():FindFirstChild("HumanoidRootPart")
end

local function hum()
    return char():FindFirstChildOfClass("Humanoid")
end

-- STATE
local Teleport = false
local InfiniteJump = false
local SuperThrow = false
local Aura = false
local AntiVoid = false

-- TABS
local MainTab  = Window:CreateTab("Main")
local FunTab   = Window:CreateTab("Fun")
local MiscTab  = Window:CreateTab("Misc")

-- =====================
-- MAIN
-- =====================

Rayfield:CreateButton({
    Name = "Teleport to Mouse [OFF]",
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

-- =====================
-- FUN
-- =====================

Rayfield:CreateButton({
    Name = "Aura Orbit [OFF]",
    Callback = function()
        Aura = not Aura
        Rayfield:Notify({
            Title = "Aura",
            Content = Aura and "ON" or "OFF",
            Duration = 3
        })
    end
})

-- =====================
-- MISC
-- =====================

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

-- =====================
-- INPUT
-- =====================

UIS.InputBegan:Connect(function(input)
    if Teleport and input.KeyCode == Enum.KeyCode.Z then
        if hrp() and Mouse.Hit then
            hrp().CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0,5,0))
        end
    end

    if InfiniteJump and input.UserInputType == Enum.UserInputType.Keyboard then
        if hum() then
            hum():ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- =====================
-- LOOPS
-- =====================

RunService.Heartbeat:Connect(function()
    if SuperThrow then
        local gp = Workspace:FindFirstChild("GrabParts")
        if gp and gp:FindFirstChild("DragPart") then
            gp.DragPart.AssemblyLinearVelocity =
                Workspace.CurrentCamera.CFrame.LookVector * 3000
        end
    end

    if Aura and hrp() then
        for i = 1, 8 do
            -- simple visual pulse using character rotation
            hrp().CFrame = hrp().CFrame * CFrame.Angles(0, 0.001, 0)
        end
    end
end)

Rayfield:Notify({
    Title = "FTAP HUB LOADED",
    Content = "Ultra-old Rayfield mode active",
    Duration = 6
})

print("FTAP FULL HUB LOADED (ULTRA OLD RAYFIELD)")

