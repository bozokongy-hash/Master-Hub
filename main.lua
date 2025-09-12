--// Services
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local Enum = Enum

--// Theme and configuration
local Library = {
    Theme = {
        MainColor = Color3.fromRGB(255, 75, 75),
        BackgroundColor = Color3.fromRGB(35, 35, 35),
        UIToggleKey = Enum.KeyCode.RightControl, -- Change key here
        TextFont = Enum.Font.SourceSansBold,
        EasingStyle = Enum.EasingStyle.Quart
    },
    LibraryColorTable = {},
    TabCount = 0,
    FirstTab = nil,
    CurrentlyBinding = false,
    RainbowColorValue = 0,
    HueSelectionPosition = 0
}

--// Utility functions
local function DarkenObjectColor(object, amount)
    local r = math.clamp((object.R * 255) - amount, 0, 255)
    local g = math.clamp((object.G * 255) - amount, 0, 255)
    local b = math.clamp((object.B * 255) - amount, 0, 255)
    return Color3.fromRGB(r, g, b)
end

local function SetUIAccent(color)
    for i, v in pairs(Library.LibraryColorTable) do
        if v and v:IsA("ImageLabel") then
            if v.Name ~= "CheckboxOutline" and v.ImageColor3 ~= Color3.fromRGB(65, 65, 65) then
                v.ImageColor3 = color
            end
        elseif v and v:IsA("TextLabel") then
            if v.TextColor3 ~= Color3.fromRGB(255, 255, 255) then
                v.TextColor3 = color
            end
        end
    end
end

local function RippleEffect(object)
    spawn(function()
        local Ripple = Instance.new("ImageLabel")
        Ripple.Name = "Ripple"
        Ripple.Parent = object
        Ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Ripple.BackgroundTransparency = 1
        Ripple.ZIndex = 8
        Ripple.Image = "rbxassetid://2708891598"
        Ripple.ImageTransparency = 0.8
        Ripple.ScaleType = Enum.ScaleType.Fit

        local mousePos = UserInputService:GetMouseLocation()
        local absPos = object.AbsolutePosition
        local absSize = object.AbsoluteSize
        local relativeX = (mousePos.X - absPos.X) / absSize.X
        local relativeY = (mousePos.Y - absPos.Y) / absSize.Y
        Ripple.Position = UDim2.new(relativeX, 0, relativeY, 0)
        local targetSize = UDim2.new(12, 0, 12, 0)
        local tween1 = TweenService:Create(Ripple, TweenInfo.new(1, Library.Theme.EasingStyle, Enum.EasingDirection.Out), {Position = UDim2.new(-5.5, 0, -5.5, 0), Size = targetSize})
        tween1:Play()

        wait(0.5)
        local tween2 = TweenService:Create(Ripple, TweenInfo.new(1, Library.Theme.EasingStyle, Enum.EasingDirection.Out), {ImageTransparency = 1})
        tween2:Play()

        wait(1)
        Ripple:Destroy()
    end)
end

local function MakeDraggable(topbarObject, mainObject)
    local dragging = false
    local dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        mainObject.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    topbarObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainObject.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    topbarObject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

--// UI Creation
local function CreateUI()
    local gui = Instance.new("ScreenGui")
    gui.Name = HttpService:GenerateGUID(false)
    gui.Parent = CoreGui
    gui.DisplayOrder = 1
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Global

    local Main = Instance.new("ImageLabel", gui)
    Main.Name = "Main"
    Main.BackgroundColor3 = Library.Theme.BackgroundColor
    Main.BackgroundTransparency = 1
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.Size = UDim2.new(0, 450, 0, 250)
    Main.ZIndex = 2
    Main.Image = "rbxassetid://3570695787"
    Main.ImageColor3 = Library.Theme.BackgroundColor
    Main.ScaleType = Enum.ScaleType.Slice
    Main.SliceCenter = Rect.new(100, 100, 100, 100)
    Main.SliceScale = 0.050

    local Border = Instance.new("ImageLabel", Main)
    Border.Name = "Border"
    Border.BackgroundColor3 = Library.Theme.MainColor
    Border.BackgroundTransparency = 1
    Border.Position = UDim2.new(0, -1, 0, -1)
    Border.Size = UDim2.new(1, 2, 1, 2)
    Border.Image = "rbxassetid://3570695787"
    Border.ImageColor3 = Library.Theme.MainColor
    Border.ScaleType = Enum.ScaleType.Slice
    Border.SliceCenter = Rect.new(100, 100, 100, 100)
    Border.SliceScale = 0.050
    Border.ImageTransparency = 1

    local Topbar = Instance.new("Frame", Main)
    Topbar.Name = "Topbar"
    Topbar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Topbar.BackgroundTransparency = 1
    Topbar.Size = UDim2.new(0, 450, 0, 15)
    Topbar.ZIndex = 2

    local UITabs = Instance.new("Frame", Main)
    UITabs.Name = "UITabs"
    UITabs.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    UITabs.BackgroundTransparency = 1
    UITabs.ClipsDescendants = true
    UITabs.Size = UDim2.new(1, 0, 1, 0)

    local Tabs = Instance.new("Frame", UITabs)
    Tabs.Name = "Tabs"
    Tabs.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Tabs.BackgroundTransparency = 1
    Tabs.Position = UDim2.new(0, 13, 0, 41)
    Tabs.Size = UDim2.new(0, 421, 0, 209)
    Tabs.ZIndex = 2

    local TabButtons = Instance.new("ImageLabel", UITabs)
    TabButtons.Name = "TabButtons"
    TabButtons.BackgroundColor3 = Library.Theme.MainColor
    TabButtons.BackgroundTransparency = 1
    TabButtons.Position = UDim2.new(0, 14, 0, 16)
    TabButtons.Size = UDim2.new(0, 419, 0, 25)
    TabButtons.ZIndex = 2
    TabButtons.Image = "rbxassetid://3570695787"
    TabButtons.ImageColor3 = Library.Theme.MainColor
    TabButtons.ScaleType = Enum.ScaleType.Slice
    TabButtons.SliceCenter = Rect.new(100, 100, 100, 100)
    TabButtons.SliceScale = 0.050
    TabButtons.ClipsDescendants = true

    local TabButtonLayout = Instance.new("UIListLayout", TabButtons)
    TabButtonLayout.FillDirection = Enum.FillDirection.Horizontal
    TabButtonLayout.SortOrder = Enum.SortOrder.LayoutOrder

    -- Animate opening
    TweenService:Create(Main, TweenInfo.new(0.5, Library.Theme.EasingStyle, Enum.EasingDirection.Out), {Size = UDim2.new(0, 450, 0, 250)}):Play()
    TweenService:Create(Border, TweenInfo.new(0.5, Library.Theme.EasingStyle, Enum.EasingDirection.Out), {ImageTransparency = 0}):Play()

    -- Store references
    Library.Gui = gui
    Library.Main = Main
    Library.Topbar = Topbar
    Library.UITabs = UITabs
    Library.Tabs = Tabs
    Library.TabButtons = TabButtons
    Library.TabButtonLayout = TabButtonLayout

    -- Make draggable
    MakeDraggable(Topbar, Main)

    -- Add to color table
    table.insert(Library.LibraryColorTable, Border)
    table.insert(Library.LibraryColorTable, TabButtons)

    -- Helper to close all tabs
    local function CloseAllTabs()
        for _, v in pairs(Tabs:GetChildren()) do
            if v:IsA("Frame") then
                v.Visible = false
            end
        end
    end

    return {
        gui = gui,
        Main = Main,
        CloseAllTabs = CloseAllTabs
    }
end

local UI = CreateUI()

--// UI Toggle with key (hold mode or toggle mode)
local toggleMode = false -- false = toggle, true = hold
local isUIVisible = false

local function ToggleUI(state)
    isUIVisible = state or not isUIVisible
    UI.Main.Visible = isUIVisible
end

-- Initialize hidden
UI.Main.Visible = false

-- Detect key press
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Library.Theme.UIToggleKey then
        if toggleMode then
            -- Hold mode: show while holding
            UI.Main.Visible = true
        else
            -- Toggle mode
            ToggleUI()
        end
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Library.Theme.UIToggleKey then
        if toggleMode then
            -- Hold mode: hide when released
            UI.Main.Visible = false
        end
    end
end)

--// Example: Creating your UI Tabs, Sections, and Controls

local aimbotTab = UI.CloseAllTabs and (function() -- create tab
    local tab = {
        CreateSection = function(self, name)
            local sectionFrame = Instance.new("Frame", UI.Tabs)
            sectionFrame.Name = name
            sectionFrame.Size = UDim2.new(1, 0, 0, 100)
            local label = Instance.new("TextLabel", sectionFrame)
            label.Text = name
            label.Size = UDim2.new(1, 0, 0, 20)
            label.BackgroundTransparency = 1
        end,
        CreateButton = function(self, name, callback)
            -- replace with your actual button creation code
        end,
        CreateLabel = function(self, name, text)
            -- replace with your actual label creation code
        end,
        CreateToggle = function(self, name, callback)
            -- replace with your actual toggle creation code
        end,
        CreateSlider = function(self, name, min, max, preset, decimals, callback)
            -- replace with your actual slider creation code
        end,
        CreateColorPicker = function(self, name, color, callback)
            -- replace with your actual color picker creation code
        end,
        CreateDropdown = function(self, name, options, presetIndex, callback)
            -- replace with your actual dropdown creation code
        end,
        CreateKeybind = function(self, name, keyCode, keyboardOnly, holdMode, callback)
            -- Implement keybind UI and callback
        end
    }
    return tab
end)() -- replace with your actual tab creation code

-- Example usage:
local MainSection = aimbotTab:CreateSection("Main")
MainSection:CreateButton("Click Me!", function()
    print("Boo!")
end)
MainSection:CreateLabel("Namey", "Hello!")
MainSection:CreateToggle("Aimbot", function(state)
    print("Aimbot:", state)
end)
MainSection:CreateSlider("Field Of View", 0, 150, 50, false, function(value)
    print("FOV:", value)
end)

local ConfigSection = aimbotTab:CreateSection("Config")
ConfigSection:CreateColorPicker("Field of View Color", Color3.fromRGB(255, 255, 255), function(color)
    print("Color:", color)
end)
ConfigSection:CreateDropdown("Type", {"Mouse", "Character"}, 1, function(option)
    print("Type selected:", option)
end)
ConfigSection:CreateKeybind("Aimbot Bind", Enum.KeyCode.RightShift, true, false, function(active)
    print("Aimbot Active:", active)
end)
