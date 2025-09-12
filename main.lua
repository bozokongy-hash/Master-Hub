-- Key System
local correctKey = "YZwrKXe7qWuddgruV15RvI3EXpapu3xM"
local userInput = ""

-- Simple UI prompt using Roblox's TextBox
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KeyPrompt"
ScreenGui.Parent = game:GetService("CoreGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 300, 0, 150)
Frame.Position = UDim2.new(0.5, -150, 0.5, -75)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Parent = ScreenGui

local TextLabel = Instance.new("TextLabel")
TextLabel.Size = UDim2.new(1, -20, 0, 50)
TextLabel.Position = UDim2.new(0, 10, 0, 10)
TextLabel.Text = "Enter Key to Continue"
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.BackgroundTransparency = 1
TextLabel.Font = Enum.Font.SourceSansBold
TextLabel.TextSize = 18
TextLabel.Parent = Frame

local TextBox = Instance.new("TextBox")
TextBox.Size = UDim2.new(1, -20, 0, 30)
TextBox.Position = UDim2.new(0, 10, 0, 70)
TextBox.PlaceholderText = "Enter Key..."
TextBox.Text = ""
TextBox.ClearTextOnFocus = false
TextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.Parent = Frame

local Button = Instance.new("TextButton")
Button.Size = UDim2.new(0, 100, 0, 30)
Button.Position = UDim2.new(0.5, -50, 0, 110)
Button.Text = "Submit"
Button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.Parent = Frame

local success = false
Button.MouseButton1Click:Connect(function()
    if TextBox.Text == correctKey then
        success = true
        ScreenGui:Destroy() -- Remove key prompt
    else
        TextLabel.Text = "Incorrect Key!"
        TextLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
end)

-- Wait until key is correct before loading UI
repeat wait() until success

-- From here, load the rest of your Coasting UI
local CoastingLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/GhostDuckyy/UI-Libraries/main/Coasting%20Ui%20Lib/source.lua"))()
