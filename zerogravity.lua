-- Simple & Perfect Zero Gravity (works on all executors)
local button = Instance.new("ScreenGui")
local frame = Instance.new("Frame")
local textbutton = Instance.new("TextButton")

button.Parent = game:GetService("CoreGui")
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0.5, -100, 0.9, -120)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(255, 100, 100)
frame.Parent = button

textbutton.Size = UDim2.new(1, -20, 1, -20)
textbutton.Position = UDim2.new(0, 10, 0, 10)
textbutton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
textbutton.Text = "Zero Gravity: OFF"
textbutton.TextColor3 = Color3.new(1, 1, 1)
textbutton.TextScaled = true
textbutton.Parent = frame

local on = false
textbutton.MouseButton1Click:Connect(function()
    on = not on
    if on then
        workspace.Gravity = 0
        textbutton.Text = "Zero Gravity: ON"
        textbutton.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
    else
        workspace.Gravity = 196.2
        textbutton.Text = "Zero Gravity: OFF"
        textbutton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    end
end)

-- Make the GUI draggable (optional but cool)
local dragging = false
local dragInput, dragStart, startPos

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)

frame.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)
