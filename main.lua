local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer

-- GUI table
local GUI = {}
GUI.CurrentTab = nil
GUI.Settings = {}
GUI.isMinimized = false

-- Default theme
local DefaultTheme = {
    Background = Color3.fromRGB(15, 15, 25),
    Secondary = Color3.fromRGB(25, 25, 35),
    Accent = Color3.fromRGB(138, 43, 226),
    AccentSecondary = Color3.fromRGB(118, 23, 206),
    Text = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(180, 180, 180),
    Border = Color3.fromRGB(45, 45, 55),
    NavBackground = Color3.fromRGB(20, 20, 30),
    Surface = Color3.fromRGB(30, 30, 40),
    SurfaceVariant = Color3.fromRGB(35, 35, 45),
    Success = Color3.fromRGB(40, 201, 64),
    Warning = Color3.fromRGB(255, 189, 46),
    Error = Color3.fromRGB(255, 95, 87),
    Shadow = Color3.fromRGB(0, 0, 0)
}

local Theme = DefaultTheme

-- Destroy old instance if exists
if _G.MASTXR_GUI then
    _G.MASTXR_GUI:Destroy()
    _G.MASTXR_GUI = nil
end

-- Loading / Key Screen
local function showLoadingScreen(callback)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "MASTXR_Loading"
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local LoadingFrame = Instance.new("Frame")
    LoadingFrame.Size = UDim2.new(0, 400, 0, 250)
    LoadingFrame.Position = UDim2.new(0.5, -200, 0.5, -125)
    LoadingFrame.BackgroundColor3 = Theme.Background
    LoadingFrame.BorderSizePixel = 0
    LoadingFrame.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = LoadingFrame

    local Logo = Instance.new("ImageLabel")
    Logo.Size = UDim2.new(0, 150, 0, 150)
    Logo.Position = UDim2.new(0.5, -75, 0.1, 0)
    Logo.Image = "rbxassetid://YOUR_LOGO_ID" -- replace with your uploaded logo ID
    Logo.BackgroundTransparency = 1
    Logo.Parent = LoadingFrame

    local TextLabel = Instance.new("TextLabel")
    TextLabel.Text = "Enter Key:"
    TextLabel.TextColor3 = Theme.Text
    TextLabel.BackgroundTransparency = 1
    TextLabel.Size = UDim2.new(0, 380, 0, 50)
    TextLabel.Position = UDim2.new(0.5, -190, 0.65, 0)
    TextLabel.TextScaled = true
    TextLabel.Parent = LoadingFrame

    local TextBox = Instance.new("TextBox")
    TextBox.Size = UDim2.new(0, 200, 0, 40)
    TextBox.Position = UDim2.new(0.5, -100, 0.8, 0)
    TextBox.PlaceholderText = "Key here"
    TextBox.BackgroundColor3 = Theme.Surface
    TextBox.TextColor3 = Theme.Text
    TextBox.TextScaled = true
    TextBox.Parent = LoadingFrame

    local correctKey = "sweb123"

    TextBox.FocusLost:Connect(function(enterPressed)
        if enterPressed and TextBox.Text == correctKey then
            ScreenGui:Destroy()
            callback()
        else
            TextBox.Text = ""
            TextLabel.Text = "Incorrect Key! Try again:"
        end
    end)
end

-- Main GUI creation
function GUI:CreateMain(config)
    local settings = {
        Name = config.Name or "MASTXR",
        title = config.title or "MASTXR",
        ToggleUI = config.ToggleUI or "K",
        WindowIcon = config.WindowIcon or nil,
        WindowHeight = config.WindowHeight or 400,
        WindowWidth = config.WindowWidth or 600,
        Theme = config.Theme or DefaultTheme,
    }

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = settings.Name
    ScreenGui.Parent = game.CoreGui
    _G.MASTXR_GUI = ScreenGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = settings.Theme.Background
    MainFrame.Size = UDim2.new(0, settings.WindowWidth, 0, settings.WindowHeight)
    MainFrame.Position = UDim2.new(0.5, -settings.WindowWidth/2, 0.5, -settings.WindowHeight/2)

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = MainFrame

    -- Window icon/logo
    if settings.WindowIcon then
        local Icon = Instance.new("ImageLabel")
        Icon.Size = UDim2.new(0, 50, 0, 50)
        Icon.Position = UDim2.new(0, 10, 0, 10)
        Icon.Image = settings.WindowIcon
        Icon.BackgroundTransparency = 1
        Icon.Parent = MainFrame
    end

    -- Example Home Label
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(0, settings.WindowWidth - 70, 0, 50)
    TitleLabel.Position = UDim2.new(0, 70, 0, 10)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = settings.title
    TitleLabel.TextColor3 = settings.Theme.Text
    TitleLabel.TextScaled = true
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Parent = MainFrame
end

-- Start loading screen with key, then load GUI
showLoadingScreen(function()
    GUI:CreateMain({
        Name = "MASTXR",
        title = "MASTXR",
        ToggleUI = "K",
        WindowIcon = "rbxassetid://i.imgur.com/OuS6Kwc.png", -- replace with your uploaded logo ID
        Theme = DefaultTheme
    })
end)
