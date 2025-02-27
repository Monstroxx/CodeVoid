local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")

-- Main notification frame
local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0.15, 0, 0.06, 0) -- Compact size
frame.Position = UDim2.new(0.425, 0, -0.2, 0) -- Starts above screen for animation
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15) -- Solid dark background
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 0 -- Fully solid
frame.ClipsDescendants = true

-- Slightly smoother corners (but still mostly sharp)
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0.08, 0) -- A little more rounded than before
corner.Parent = frame

-- Function to create text labels
local function createTextLabel(parent, text, position, size, fontSize, font)
    local label = Instance.new("TextLabel")
    label.Parent = parent
    label.Size = size
    label.Position = position
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.BackgroundTransparency = 1
    label.Font = font
    label.TextScaled = true
    label.TextSize = fontSize
    label.TextWrapped = true
    return label
end

-- Title (Bold)
local title = createTextLabel(frame, "[CodeVoid]", UDim2.new(0, 0, 0, 2), UDim2.new(1, 0, 0.3, 0), 10, Enum.Font.GothamBold)

-- Message (SemiBold)
local message = createTextLabel(frame, "INJECTED", UDim2.new(0, 0, 0.35, 0), UDim2.new(1, 0, 0.3, 0), 8, Enum.Font.GothamSemibold)

-- Update info (SemiBold)
local update = createTextLabel(frame, "UPDATE v1.0", UDim2.new(0, 0, 0.7, 0), UDim2.new(1, 0, 0.2, 0), 7, Enum.Font.GothamSemibold)

-- Smooth drop-in animation
frame:TweenPosition(UDim2.new(0.425, 0, 0.05, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quint, 0.5, true)
task.wait(0.5)

-- Stay on screen
task.wait(4)

-- Fade out animation
for i = 0, 1, 0.1 do
    frame.BackgroundTransparency = i
    title.TextTransparency = i
    message.TextTransparency = i
    update.TextTransparency = i
    task.wait(0.05)
end

gui:Destroy()
