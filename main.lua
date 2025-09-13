-- MASTXR GUI
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Player = Players.LocalPlayer

local GUI = {}
GUI.CurrentTab = nil
GUI.Settings = {}
GUI.isMinimized = false
GUI.isDraggingEnabled = true

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

-- Destroy old GUI
if _G.MASTXR_GUI then
    _G.MASTXR_GUI:Destroy()
    _G.MASTXR_GUI = nil
end

-- Function to create draggable GUI
local function makeDraggableConditional(frame)
    local dragging = false
    local dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if GUI.isDraggingEnabled and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and GUI.isDraggingEnabled and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

-- Loading/Key System
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
    Logo.Image = "rbxassetid://YOUR_LOGO_ID" -- Replace with your logo asset ID
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
        Blur = config.Blur or {Enable = false, value = 0.5},
        alwaysIconOnly = config.alwaysIconOnly or false
    }

    if settings.Blur.Enable then
        local blur = Instance.new("BlurEffect")
        blur.Size = 50
        blur.Parent = workspace.CurrentCamera
        GUI.BlurEffect = blur
    end

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

    -- Make draggable
    makeDraggableConditional(MainFrame)

    -- TitleBar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Parent = MainFrame
    TitleBar.BackgroundColor3 = settings.Theme.Surface
    TitleBar.BackgroundTransparency = 0.1
    TitleBar.Position = UDim2.new(0,0,0,0)
    TitleBar.Size = UDim2.new(1,0,0,50)

    local TitleBarCorner = Instance.new("UICorner")
    TitleBarCorner.CornerRadius = UDim.new(0, 12)
    TitleBarCorner.Parent = TitleBar

    -- Window Icon
    if settings.WindowIcon then
        local Icon = Instance.new("ImageLabel")
        Icon.Size = UDim2.new(0, 50, 0, 50)
        Icon.Position = UDim2.new(0, 10, 0, 0)
        Icon.Image = settings.WindowIcon
        Icon.BackgroundTransparency = 1
        Icon.Parent = TitleBar
    end

    -- Title Label
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(0, settings.WindowWidth-70, 1, 0)
    TitleLabel.Position = UDim2.new(0, 70, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = settings.title
    TitleLabel.TextColor3 = settings.Theme.Text
    TitleLabel.TextScaled = true
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TitleBar

    -- Minimize Button
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.Parent = TitleBar
    MinimizeButton.BackgroundColor3 = settings.Theme.Warning
    MinimizeButton.Position = UDim2.new(1, -85, 0.5, -10)
    MinimizeButton.Size = UDim2.new(0, 20, 0, 20)
    MinimizeButton.Text = ""
    MinimizeButton.AutoButtonColor = false
    local MinimizeCorner = Instance.new("UICorner")
    MinimizeCorner.CornerRadius = UDim.new(1,0)
    MinimizeCorner.Parent = MinimizeButton

    MinimizeButton.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
        -- You can optionally add restore button here
    end)

    -- Navigation Panel
    local NavFrame = Instance.new("Frame")
    NavFrame.Name = "Navigation"
    NavFrame.Parent = MainFrame
    NavFrame.BackgroundColor3 = settings.Theme.NavBackground
    NavFrame.Position = UDim2.new(0, 15, 0, 60)
    NavFrame.Size = UDim2.new(0, 140, 1, -120)
    NavFrame.BorderSizePixel = 0

    local NavCorner = Instance.new("UICorner")
    NavCorner.CornerRadius = UDim.new(0, 12)
    NavCorner.Parent = NavFrame
end

-- Start GUI after loading screen
showLoadingScreen(function()
    GUI:CreateMain({
        Name = "MASTXR",
        title = "MASTXR",
        WindowIcon = "rbxassetid://YOUR_LOGO_ID", -- replace with your logo
        Blur = {Enable = true, value = 0.5}
    })
end)
