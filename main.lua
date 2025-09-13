-- MASTXR HUB - Clean Modern UI
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

-- Kill any old GUI
if _G.MASTXR_GUI then
    _G.MASTXR_GUI:Destroy()
    _G.MASTXR_GUI = nil
end

-- Theme
local Theme = {
    Background = Color3.fromRGB(15, 15, 25),
    Secondary = Color3.fromRGB(25, 25, 35),
    Accent = Color3.fromRGB(138, 43, 226),
    AccentSecondary = Color3.fromRGB(118, 23, 206),
    Text = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(180, 180, 180),
    Border = Color3.fromRGB(45, 45, 55),
    NavBackground = Color3.fromRGB(20, 20, 30),
    Surface = Color3.fromRGB(30, 30, 40),
    Success = Color3.fromRGB(40, 201, 64),
    Warning = Color3.fromRGB(255, 189, 46),
    Error = Color3.fromRGB(255, 95, 87)
}

local GUI = {}
GUI.isDraggingEnabled = true
GUI.isMinimized = false

-- MAIN UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MASTXR"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
_G.MASTXR_GUI = ScreenGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
MainFrame.Size = UDim2.new(0, 600, 0, 400)

local BorderStroke = Instance.new("UIStroke")
BorderStroke.Parent = MainFrame
BorderStroke.Color = Theme.Border
BorderStroke.Thickness = 1
BorderStroke.Transparency = 0.5

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = MainFrame

-- DRAGGABLE
local function makeDraggable(frame)
    local dragging, dragStart, startPos = false, nil, nil
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and GUI.isDraggingEnabled then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                       startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end
makeDraggable(MainFrame)

-- TITLE BAR
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Theme.Surface
TitleBar.Size = UDim2.new(1, 0, 0, 50)

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

-- LOGO
local Logo = Instance.new("ImageLabel")
Logo.Name = "Logo"
Logo.Parent = TitleBar
Logo.BackgroundTransparency = 1
Logo.Position = UDim2.new(0, 10, 0.5, -15)
Logo.Size = UDim2.new(0, 30, 0, 30)
Logo.Image = "https://i.imgur.com/OuS6Kwc.png"

-- TITLE TEXT
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "Title"
TitleLabel.Parent = TitleBar
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 50, 0, 0)
TitleLabel.Size = UDim2.new(0, 200, 1, 0)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "MASTXR HUB"
TitleLabel.TextColor3 = Theme.Text
TitleLabel.TextSize = 18
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- WINDOW BUTTONS
local function makeTitleBtn(name, color, posX)
    local Btn = Instance.new("TextButton")
    Btn.Name = name
    Btn.Parent = TitleBar
    Btn.BackgroundColor3 = color
    Btn.BorderSizePixel = 0
    Btn.Position = UDim2.new(1, posX, 0.5, -10)
    Btn.Size = UDim2.new(0, 20, 0, 20)
    Btn.Text = ""
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(1, 0)
    BtnCorner.Parent = Btn
    return Btn
end

local MinimizeButton = makeTitleBtn("Minimize", Theme.Warning, -85)
local MaximizeButton = makeTitleBtn("Maximize", Theme.Success, -60)
local CloseButton = makeTitleBtn("Close", Theme.Error, -35)

-- NAVIGATION
local NavFrame = Instance.new("Frame")
NavFrame.Name = "Navigation"
NavFrame.Parent = MainFrame
NavFrame.BackgroundColor3 = Theme.NavBackground
NavFrame.Position = UDim2.new(0, 15, 0, 60)
NavFrame.Size = UDim2.new(0, 140, 1, -120)

local NavCorner = Instance.new("UICorner")
NavCorner.CornerRadius = UDim.new(0, 12)
NavCorner.Parent = NavFrame

local NavStroke = Instance.new("UIStroke")
NavStroke.Parent = NavFrame
NavStroke.Color = Theme.Border
NavStroke.Thickness = 1
NavStroke.Transparency = 0.7

-- CONTENT FRAME
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "Content"
ContentFrame.Parent = MainFrame
ContentFrame.BackgroundColor3 = Theme.Surface
ContentFrame.Position = UDim2.new(0, 165, 0, 60)
ContentFrame.Size = UDim2.new(1, -180, 1, -120)

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 12)
ContentCorner.Parent = ContentFrame

-- SAMPLE TAB LABEL
local TabLabel = Instance.new("TextLabel")
TabLabel.Parent = ContentFrame
TabLabel.Text = "Welcome to MASTXR HUB"
TabLabel.TextColor3 = Theme.Text
TabLabel.Font = Enum.Font.Gotham
TabLabel.TextSize = 20
TabLabel.BackgroundTransparency = 1
TabLabel.Size = UDim2.new(1, 0, 0, 50)
TabLabel.Position = UDim2.new(0, 0, 0, 20)

print("MASTXR HUB loaded!")
