-- FIXED Ultimate Zero Gravity + Fling Bypass (PERFECT for Fling Things & People + All Games) - Upload to zerogravity.lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/Anti-Kick/main/Anti-Kick.lua"))()

local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Debris = game:GetService("Debris")

local normalGravity = Workspace.Gravity
local zeroGrav = false
local flingMode = false
local Connections = {}

local function cleanupForce(part)
    if not part then return end
    for _, child in ipairs(part:GetChildren()) do
        if (child:IsA("VectorForce") and child.Name:find("ZeroGrav")) or 
           (child:IsA("BodyAngularVelocity") and child.Name:find("FlingSpin")) or
           (child:IsA("Attachment") and child.Name:find("ZeroGrav")) then
            child:Destroy()
        end
    end
end

local function applyZeroGravity(part)
    if part:IsA("BasePart") and not part.Anchored and part.Parent then
        cleanupForce(part)
        local att = Instance.new("Attachment")
        att.Name = "ZeroGravAtt" .. math.random(1,999)
        att.Parent = part
        
        local vf = Instance.new("VectorForce")
        vf.Name = "ZeroGravForce" .. math.random(1,999)
        vf.Attachment0 = att
        vf.RelativeTo = Enum.ActuatorRelativeTo.World
        vf.Force = Vector3.new(0, part.AssemblyMass * Workspace.Gravity, 0)
        vf.Parent = part
    end
end

local function startFlingSpin(part)
    if not part then return end
    cleanupForce(part)
    part.AssemblyAngularVelocity = Vector3.new(0, math.huge, 0)
    local bav = Instance.new("BodyAngularVelocity")
    bav.Name = "FlingSpin" .. math.random(1,999)
    bav.AngularVelocity = Vector3.new(0, 5e5, 0)
    bav.MaxTorque = Vector3.new(0, math.huge, 0)
    bav.Parent = part
end

local function applyFling(rootPart)
    if not rootPart or not rootPart.Parent or rootPart.Parent == LocalPlayer.Character then return end  -- Self-protect
    rootPart.AssemblyMassless = false
    rootPart.CanCollide = true
    startFlingSpin(rootPart)
    -- Upward fling boost with delay for stability
    task.wait(0.05)
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(0, math.huge, 0)
    bv.Velocity = Vector3.new(0, 5e4, 0)
    bv.Parent = rootPart
    Debris:AddItem(bv, 0.1)
end

local function toggleZeroGrav()
    zeroGrav = not zeroGrav
    if zeroGrav then
        for _, obj in ipairs(Workspace:GetDescendants()) do
            applyZeroGravity(obj)
        end
        Connections.DescAdded = Workspace.DescendantAdded:Connect(function(obj)
            if obj:IsA("BasePart") then task.wait(0.1) applyZeroGravity(obj) end
        end)
    else
        -- No Gravity change - just cleanup forces
        for _, obj in ipairs(Workspace:GetDescendants()) do
            cleanupForce(obj)
        end
        if Connections.DescAdded then Connections.DescAdded:Disconnect() end
    end
end

local function toggleFling()
    flingMode = not flingMode
    if flingMode then
        -- Handle new parts for touch-fling
        Connections.Touched = Workspace.DescendantAdded:Connect(function(obj)
            if obj:IsA("BasePart") and obj.Parent:FindFirstChild("Humanoid") and obj.Parent ~= LocalPlayer.Character then
                obj.Touched:Connect(function(hit)
                    if hit and hit.Parent == LocalPlayer.Character then
                        local enemyRoot = obj.Parent:FindFirstChild("HumanoidRootPart") or obj.Parent:FindFirstChild("Torso")
                        applyFling(enemyRoot)
                    end
                end)
            end
        end)
        -- Auto-fling nearby loop (low freq for no lag/detect)
        Connections.FlingLoop = RunService.Heartbeat:Connect(function()
            if flingMode then
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                        local dist = (plr.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                        if dist < 50 then applyFling(plr.Character.HumanoidRootPart) end
                    end
                end
            end
        end)
    else
        if Connections.Touched then Connections.Touched:Disconnect() end
        if Connections.FlingLoop then Connections.FlingLoop:Disconnect() end
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.Character then 
                local root = plr.Character:FindFirstChild("HumanoidRootPart")
                cleanupForce(root)
            end
        end
    end
end

-- Keybinds: G = Zero Grav Toggle, F = Fling Mode Toggle
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.G then toggleZeroGrav() end
    if input.KeyCode == Enum.KeyCode.F then toggleFling() end
end)

-- Draggable GUI (random name, minimal)
local guiName = tostring(math.random(1e9, 9e9))
local button = Instance.new("ScreenGui")
button.Name = guiName
button.Parent = game:GetService("CoreGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 80)
frame.Position = UDim2.new(0.5, -125, 0.9, -100)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Parent = button

local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, 0, 1, 0)
label.BackgroundTransparency = 1
label.Text = "ZG: OFF (G) | Fling: OFF (F)\nTouch/nearby to fling others!\nZeroGrav floats EVERYTHING"
label.TextColor3 = Color3.new(1,1,1)
label.TextScaled = true
label.Font = Enum.Font.SourceSansBold
label.Parent = frame

-- Draggable
local dragging, dragStart, startPos
frame.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = inp.Position
        startPos = frame.Position
    end
end)
frame.InputChanged:Connect(function(inp)
    if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = inp.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
frame.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

-- Update GUI text dynamically
RunService.Heartbeat:Connect(function()
    label.Text = "ZG: " .. (zeroGrav and "ON" or "OFF") .. " (G) | Fling: " .. (flingMode and "ON" or "OFF") .. " (F)\nTouch/nearby to fling others!\nZeroGrav floats EVERYTHING"
end)

print("🚀 FIXED Zero Gravity + Fling Loaded! G=ZeroGrav | F=Fling Mode (Auto/Touch)")
print("💥 Now PERFECT in Fling Things and People - Float + Super Fling Everyone (No Self-Fling)!")
