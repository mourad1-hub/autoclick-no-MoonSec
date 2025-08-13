local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui

local function makeDraggable(frame)
    local dragging, dragInput, mousePos, framePos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            mousePos = input.Position
            framePos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            frame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
        end
    end)
end

local Bar = Instance.new("Frame")
Bar.Size = UDim2.new(0, 50, 0, 150)
Bar.Position = UDim2.new(0, 50, 0.5, -75)
Bar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Bar.Active = true
Bar.Draggable = false
Bar.Parent = ScreenGui
makeDraggable(Bar)

local blue = Color3.fromRGB(0, 100, 255)
local green = Color3.fromRGB(0, 200, 0)
local red = Color3.fromRGB(200, 0, 0)

local running = false
local targets = {}
local clickDelay = 0.04

local BtnToggle = Instance.new("TextButton")
BtnToggle.Size = UDim2.new(1, 0, 0, 50)
BtnToggle.Position = UDim2.new(0, 0, 0, 0)
BtnToggle.BackgroundColor3 = blue
BtnToggle.Text = "⏯"
BtnToggle.TextColor3 = Color3.new(1, 1, 1)
BtnToggle.Parent = Bar

local BtnAdd = Instance.new("TextButton")
BtnAdd.Size = UDim2.new(1, 0, 0, 50)
BtnAdd.Position = UDim2.new(0, 0, 0, 50)
BtnAdd.BackgroundColor3 = green
BtnAdd.Text = "+"
BtnAdd.TextColor3 = Color3.new(1, 1, 1)
BtnAdd.Parent = Bar

local BtnClear = Instance.new("TextButton")
BtnClear.Size = UDim2.new(1, 0, 0, 50)
BtnClear.Position = UDim2.new(0, 0, 0, 100)
BtnClear.BackgroundColor3 = red
BtnClear.Text = "X"
BtnClear.TextColor3 = Color3.new(1, 1, 1)
BtnClear.Parent = Bar

local VirtualInputManager = game:GetService("VirtualInputManager")
local function clickAt(pos)
    VirtualInputManager:SendMouseButtonEvent(pos.X, pos.Y, 0, true, game, 0)
    VirtualInputManager:SendMouseButtonEvent(pos.X, pos.Y, 0, false, game, 0)
end

spawn(function()
    while true do
        if running then
            for _, circle in ipairs(targets) do
                clickAt(Vector2.new(circle.AbsolutePosition.X + circle.AbsoluteSize.X/2, circle.AbsolutePosition.Y + circle.AbsoluteSize.Y/2))
                task.wait(clickDelay)
            end
        end
        task.wait()
    end
end)

BtnToggle.MouseButton1Click:Connect(function()
    running = not running
    for _, circle in ipairs(targets) do
        circle.Active = not running
    end
end)

BtnAdd.MouseButton1Click:Connect(function()
    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 40, 0, 40)
    circle.Position = UDim2.new(0.5, -20, 0.5, -20)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    circle.BackgroundTransparency = 0.5
    circle.Active = true
    circle.Parent = ScreenGui
    makeDraggable(circle)
    table.insert(targets, circle)
end)

BtnClear.MouseButton1Click:Connect(function()
    for _, circle in ipairs(targets) do
        circle:Destroy()
    end
    targets = {}
end)
