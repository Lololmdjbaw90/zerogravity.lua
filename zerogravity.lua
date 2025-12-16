-- DEBUG WRAPPER
local function try(func)
    local ok, err = pcall(func)
    if not ok then
        warn("FTAP SCRIPT ERROR:", err)
    end
end

try(function()
    -- LOAD RAYFIELD
    local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
    local Window = Rayfield:CreateWindow({
        Name = "FTAP ULTIMATE FULL HUB",
        LoadingTitle = "Initializing...",
        LoadingSubtitle = "Debug Safe Version",
        ConfigurationSaving = {Enabled=true, FolderName="FTAP_Ultimate_FULL"},
        KeySystem = false
    })

    local function notify(t,c) Rayfield:Notify({Title=t,Content=c,Duration=6}) end

    -- SERVICES
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Workspace = game:GetService("Workspace")
    local RunService = game:GetService("RunService")
    local UIS = game:GetService("UserInputService")

    local LocalPlayer = Players.LocalPlayer
    local Mouse = LocalPlayer:GetMouse()

    -- SAFE REFERENCES
    local ToysFolder = Workspace:FindFirstChild(LocalPlayer.Name.."SpawnedInToys") or Instance.new("Folder",Workspace)
    local GrabEvents = ReplicatedStorage:FindFirstChild("GrabEvents")
    local CharacterEvents = ReplicatedStorage:FindFirstChild("CharacterEvents")

    -- STATE
    local state = {
        Teleport=false,
        AntiGrab=false,
        SuperThrow=false,
        InfJump=false,
        Aura={Enabled=false,Parts={},Center=nil,Speed=50,X=50,Y=50,H=50},
        Pallet={Enabled=false,Power=700,Targets={},Part=nil}
    }

    local function getChar() return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait() end
    local function getHRP() return getChar():FindFirstChild("HumanoidRootPart") end

    -- MAIN TAB
    local mainTab = Window:CreateTab("Main","🏠")
    local mainSec = mainTab:CreateSection("Core")
    mainSec:CreateToggle({Name="🔮 Teleport (Z)",Callback=function(v) state.Teleport=v end})
    mainSec:CreateToggle({Name="🛡️ Anti Grab",Callback=function(v) state.AntiGrab=v end})
    mainSec:CreateToggle({Name="💪 Super Throw",Callback=function(v) state.SuperThrow=v end})

    -- AURA TAB
    local auraTab = Window:CreateTab("Aura","🌟")
    local auraSec = auraTab:CreateSection("Aura")
    auraSec:CreateToggle({
        Name="Aura ON",
        Callback=function(v)
            state.Aura.Enabled=v
            if v then
                state.Aura.Parts={}
                for _,toy in ipairs(ToysFolder:GetChildren()) do
                    local p = toy:FindFirstChild("Main") or toy:FindFirstChildWhichIsA("BasePart")
                    if p then table.insert(state.Aura.Parts,p) end
                end
                notify("Aura","Enabled with "..#state.Aura.Parts.." parts")
            end
        end
    })
    auraSec:CreateButton({Name="Select Center (F)",Callback=function() state.Aura.Center=Mouse.Target notify("Aura","Center Set") end})

    -- TARGET / PALLET
    local targetTab = Window:CreateTab("Target/Fling","🎯")
    local targetSec = targetTab:CreateSection("Pallet Fling")
    targetSec:CreateToggle({Name="Pallet Fling",Callback=function(v) state.Pallet.Enabled=v end})
    targetSec:CreateSlider({Name="Power",Min=100,Max=1500,Default=700,Callback=function(v) state.Pallet.Power=v end})

    local names={}
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LocalPlayer then table.insert(names,p.DisplayName) end
    end
    targetSec:CreateDropdown({
        Name="Add Target",
        Options=names,
        Callback=function(d)
            for _,p in ipairs(Players:GetPlayers()) do
                if p.DisplayName == d then table.insert(state.Pallet.Targets,p) end
            end
        end
    })

    -- MISC TAB
    local miscTab = Window:CreateTab("Misc","⚙️")
    local miscSec = miscTab:CreateSection("Extras")
    miscSec:CreateToggle({Name="Infinite Jump",Callback=function(v) state.InfJump=v end})
    miscSec:CreateToggle({
        Name="Anti Void",
        Callback=function(v) Workspace.FallenPartsDestroyHeight = v and -10000 or -500 end
    })

    notify("FTAP Hub Loaded","UI created")

    -- INPUT & LOOPS
    UIS.InputBegan:Connect(function(input)
        if input.KeyCode==Enum.KeyCode.Z and state.Teleport and Mouse.Hit then
            local hrp = getHRP()
            if hrp then hrp.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0,5,0)) end
        end
        if state.InfJump and input.UserInputType == Enum.UserInputType.Keyboard then
            local h = getChar():FindFirstChildWhichIsA("Humanoid")
            if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
        end
    end)

    RunService.Heartbeat:Connect(function()
        if state.SuperThrow then
            local gp = Workspace:FindFirstChild("GrabParts")
            if gp and gp:FindFirstChild("DragPart") then
                gp.DragPart.AssemblyLinearVelocity = Workspace.CurrentCamera.CFrame.LookVector * 3000
            end
        end

        if state.Aura.Enabled then
            local center = (state.Aura.Center and state.Aura.Center.Position) or (getHRP() and getHRP().Position)
            if center then
                for i,p in ipairs(state.Aura.Parts) do
                    if p and p.Parent then
                        local ang = (i/#state.Aura.Parts)*math.pi*2 + tick()*(state.Aura.Speed/50)
                        p.CFrame = CFrame.new(center + Vector3.new(math.cos(ang)*state.Aura.X, state.Aura.H, math.sin(ang)*state.Aura.Y))
                    end
                end
            end
        end

        if state.Pallet.Enabled then
            if not state.Pallet.Part then
                for _,toy in ipairs(ToysFolder:GetChildren()) do
                    if toy.Name:match("Pallet") then
                        state.Pallet.Part = toy:FindFirstChild("Main") or toy:FindFirstChildWhichIsA("BasePart")
                        break
                    end
                end
            end
            if state.Pallet.Part then
                for _,t in ipairs(state.Pallet.Targets) do
                    if t.Character and t.Character:FindFirstChild("HumanoidRootPart") then
                        local hrp = t.Character.HumanoidRootPart
                        state.Pallet.Part.CFrame = hrp.CFrame + Vector3.new(0,-4,0)
                        state.Pallet.Part.AssemblyLinearVelocity = Vector3.new(0,state.Pallet.Power,0)
                    end
                end
            end
        end
    end)
end)

