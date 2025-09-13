-- =========================
-- MASTXR HUB - 1000x Upgraded Version
-- =========================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local workspace = workspace

local localPlayer = Players.LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

-- =========================
-- GUI & Theme Setup
-- =========================
local GUI = {} -- placeholder for the GUI object
local Themes = {
    Background = Color3.fromRGB(30,0,0),
    Secondary = Color3.fromRGB(50,0,0),
    Accent = Color3.fromRGB(255,0,0),
    Text = Color3.fromRGB(255,255,255),
    TextSecondary = Color3.fromRGB(200,100,100),
    Border = Color3.fromRGB(100,0,0),
    NavBackground = Color3.fromRGB(20,0,0)
}

local function createUI()
    -- Using a simple ScreenGui with frames for demonstration
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MASTXR_UPGRADED_GUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = game:GetService("CoreGui") -- or PlayerGui if local

    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 600, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
    mainFrame.BackgroundColor3 = Themes.Background
    mainFrame.BorderSizePixel = 2
    mainFrame.BorderColor3 = Themes.Border
    mainFrame.Parent = screenGui

    -- Title
    local title = Instance.new("TextLabel", mainFrame)
    title.Size = UDim2.new(1, 0, 0, 50)
    title.BackgroundColor3 = Themes.Accent
    title.Text = "MASTXR HUB - Upgraded"
    title.TextColor3 = Themes.Text
    title.Font = Enum.Font.GothamBold
    title.TextSize = 20

    -- Tabs container
    local tabsContainer = Instance.new("Frame", mainFrame)
    tabsContainer.Size = UDim2.new(1, -20, 1, -60)
    tabsContainer.Position = UDim2.new(0, 10, 0, 60)
    tabsContainer.BackgroundTransparency = 1

    -- Store in GUI table
    GUI.ScreenGui = screenGui
    GUI.MainFrame = mainFrame
    GUI.TabsContainer = tabsContainer
end

local function createTab(name)
    local tabButton = Instance.new("TextButton")
    tabButton.Size = UDim2.new(0, 100, 0, 30)
    tabButton.BackgroundColor3 = Themes.Secondary
    tabButton.Text = name
    tabButton.TextColor3 = Themes.Text
    tabButton.Font = Enum.Font.GothamBold
    tabButton.TextSize = 14
    tabButton.Parent = GUI.MainFrame

    local tabContent = Instance.new("Frame")
    tabContent.Size = UDim2.new(1, 0, 1, -30)
    tabContent.Position = UDim2.new(0, 0, 0, 30)
    tabContent.BackgroundTransparency = 1
    tabContent.Visible = false
    tabContent.Parent = GUI.TabsContainer

    -- Button click to switch
    tabButton.MouseButton1Click:Connect(function()
        for _, child in pairs(GUI.TabsContainer:GetChildren()) do
            if child:IsA("Frame") then
                child.Visible = false
            end
        end
        tabContent.Visible = true
    end)

    return {Button=tabButton, Content=tabContent}
end

local function createSection(parent, text)
    local section = Instance.new("Frame", parent)
    section.Size = UDim2.new(1, -20, 0, 50)
    section.Position = UDim2.new(0, 10, 0, 10 + (#parent:GetChildren()*60))
    section.BackgroundColor3 = Themes.Secondary
    section.BorderSizePixel = 1
    section.BorderColor3 = Themes.Border

    local label = Instance.new("TextLabel", section)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Themes.Text
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
end

local function createButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 150, 0, 30)
    btn.BackgroundColor3 = Themes.Accent
    btn.Text = text
    btn.TextColor3 = Themes.Text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Parent = parent
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function createToggle(parent, text, default, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(0, 200, 0, 30)
    toggleFrame.BackgroundColor3 = Themes.Secondary
    toggleFrame.Parent = parent

    local label = Instance.new("TextLabel", toggleFrame)
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Text = text
    label.TextColor3 = Themes.Text
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14

    local button = Instance.new("TextButton", toggleFrame)
    button.Size = UDim2.new(0.3, 0, 1, 0)
    button.Position = UDim2.new(0.7, 0, 0, 0)
    button.Text = default and "ON" or "OFF"
    button.TextColor3 = Color3.fromRGB(255,255,255)
    button.BackgroundColor3 = default and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 14

    local state = default
    button.MouseButton1Click:Connect(function()
        state = not state
        callback(state)
        button.Text = state and "ON" or "OFF"
        button.BackgroundColor3 = state and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
    end)
    return {Frame=toggleFrame, Button=button, State=state}
end

local function createSlider(parent, text, min, max, default, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(0, 250, 0, 50)
    sliderFrame.BackgroundColor3 = Themes.Secondary
    sliderFrame.Parent = parent

    local label = Instance.new("TextLabel", sliderFrame)
    label.Size = UDim2.new(0.5, 0, 0.4, 0)
    label.Position = UDim2.new(0, 5, 0, 0)
    label.Text = text
    label.TextColor3 = Themes.Text
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14

    local valueLabel = Instance.new("TextLabel", sliderFrame)
    valueLabel.Size = UDim2.new(0.2, 0, 0.4, 0)
    valueLabel.Position = UDim2.new(0.75, 0, 0, 0)
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = Themes.Text
    valueLabel.BackgroundTransparency = 1
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 14

    local slider = Instance.new("Frame", sliderFrame)
    slider.Size = UDim2.new(1, -10, 0, 10)
    slider.Position = UDim2.new(0, 5, 0.6, 0)
    slider.BackgroundColor3 = Themes.Border

    local handle = Instance.new("Frame", slider)
    handle.Size = UDim2.new(0, 20, 1, 0)
    handle.Position = UDim2.new(0, (default - min)/(max - min)* (slider.Size.X.Offset - 20), 0, 0)
    handle.BackgroundColor3 = Themes.Accent

    local dragging = false
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mouseX = UserInputService:GetMouseLocation().X
            local sliderPos = slider.AbsolutePosition.X
            local sliderWidth = slider.AbsoluteSize.X
            local newPos = math.clamp(mouseX - sliderPos, 0, sliderWidth - handle.AbsoluteSize.X)
            handle.Position = UDim2.new(0, newPos, 0, 0)
            local value = math.floor(min + (max - min) * (newPos / (sliderWidth - handle.AbsoluteSize.X)))
            valueLabel.Text = tostring(value)
            callback(value)
        end
    end)

    -- Initialize callback with default
    callback(default)
    return {Frame=sliderFrame, Handle=handle, ValueLabel=valueLabel}
end

-- =========================
-- SETUP UI
-- =========================
createUI()

local mainTab = createTab("Player Enhancements")
local settingsTab = createTab("Settings")
local themeTab = createTab("Themes")
local creditsTab = createTab("Credits")

-- =========================
-- Player Enhancements Section
-- =========================
local peSection = Instance.new("Frame", mainTab.Content)
peSection.Size = UDim2.new(1, 0, 1, 0)
peSection.BackgroundTransparency = 1

createSection(peSection, "Movement & Navigation")

-- Sprint
local sprintEnabled = false
local sprintSpeed = 50
local humanoidWalkSpeed = 16

local sprintToggle = createToggle(peSection, "Enable Sprint", false, function(state)
    sprintEnabled = state
    humanoid.WalkSpeed = state and sprintSpeed or humanoidWalkSpeed
    notify("Sprint", state and "Enabled" or "Disabled")
end)

local sprintSlider = createSlider(peSection, "Sprint Speed", 16, 300, sprintSpeed, function(value)
    sprintSpeed = value
    if sprintEnabled then
        humanoid.WalkSpeed = sprintSpeed
    end
end)

-- Infinite Jump
local infiniteJump = false
local function onJumpRequest()
    if infiniteJump then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end
UserInputService.JumpRequest:Connect(onJumpRequest)

local infiniteJumpToggle = createToggle(peSection, "Enable Infinite Jump", false, function(state)
    infiniteJump = state
    notify("Infinite Jump", state and "Enabled" or "Disabled")
end)

-- Fly/Noclip
local flyEnabled = false
local flySpeed = 50
local noclipConnection
local flyBodyVelocity
local flyControls = {W=false, S=false, A=false, D=false, Space=false, Shift=false}

local function updateFly()
    if flyEnabled then
        local camCF = workspace.CurrentCamera.CFrame
        local direction = Vector3.new(0,0,0)
        if flyControls.W then direction += camCF.LookVector end
        if flyControls.S then direction -= camCF.LookVector end
        if flyControls.A then direction -= camCF.RightVector end
        if flyControls.D then direction += camCF.RightVector end
        if flyControls.Space then direction += Vector3.new(0,1,0) end
        if flyControls.Shift then direction -= Vector3.new(0,1,0) end
        if flyBodyVelocity then
            flyBodyVelocity.Velocity = direction.Unit * flySpeed
        end
    end
end

local function toggleFly(state)
    flyEnabled = state
    if state then
        -- Disable collisions
        noclipConnection = RunService.Stepped:Connect(function()
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end)
        -- BodyVelocity for movement
        flyBodyVelocity = Instance.new("BodyVelocity")
        flyBodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        flyBodyVelocity.Velocity = Vector3.new(0,0,0)
        flyBodyVelocity.Parent = hrp
        notify("Fly/Noclip", "Enabled")
    else
        -- Enable collisions
        if noclipConnection then noclipConnection:Disconnect() end
        if flyBodyVelocity then flyBodyVelocity:Destroy() end
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = true end
        end
        notify("Fly/Noclip", "Disabled")
    end
end

local flyToggle = createToggle(peSection, "Enable Fly / Noclip", false, toggleFly)

local flySlider = createSlider(peSection, "Fly Speed", 10, 300, flySpeed, function(value)
    flySpeed = value
end)

-- Fly controls input
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode == Enum.KeyCode.W then flyControls.W = true end
        if input.KeyCode == Enum.KeyCode.S then flyControls.S = true end
        if input.KeyCode == Enum.KeyCode.A then flyControls.A = true end
        if input.KeyCode == Enum.KeyCode.D then flyControls.D = true end
        if input.KeyCode == Enum.KeyCode.Space then flyControls.Space = true end
        if input.KeyCode == Enum.KeyCode.LeftShift then flyControls.Shift = true end
    end
end)
UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode == Enum.KeyCode.W then flyControls.W = false end
        if input.KeyCode == Enum.KeyCode.S then flyControls.S = false end
        if input.KeyCode == Enum.KeyCode.A then flyControls.A = false end
        if input.KeyCode == Enum.KeyCode.D then flyControls.D = false end
        if input.KeyCode == Enum.KeyCode.Space then flyControls.Space = false end
        if input.KeyCode == Enum.KeyCode.LeftShift then flyControls.Shift = false end
    end
end)
RunService.RenderStepped:Connect(function()
    if flyEnabled then updateFly() end
end)

-- Teleport to spawn
local function teleportToSpawn()
    local spawnPos = Vector3.new(0, 5, 0)
    pcall(function()
        hrp.CFrame = CFrame.new(spawnPos)
    end)
    notify("Teleport", "Teleported to Spawn")
end

local teleportButton = createButton(peSection, "Teleport to Spawn", teleportToSpawn)

-- =========================
-- Settings Section
-- =========================
local sSection = Instance.new("Frame", settingsTab.Content)
sSection.Size = UDim2.new(1, 0, 1, 0)
sSection.BackgroundTransparency = 1

createSection(sSection, "Reset Enhancements")
local function resetSprint()
    sprintEnabled = false
    humanoid.WalkSpeed = humanoidWalkSpeed
    notify("Sprint", "Reset")
end
createButton(sSection, "Reset Sprint", resetSprint)

local function resetInfiniteJump()
    infiniteJump = false
    notify("Infinite Jump", "Reset")
end
createButton(sSection, "Reset Infinite Jump", resetInfiniteJump)

local function resetFly()
    flyEnabled = false
    if noclipConnection then noclipConnection:Disconnect() end
    if flyBodyVelocity then flyBodyVelocity:Destroy() end
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = true end
    end
    notify("Fly", "Reset")
end
createButton(sSection, "Reset Fly/Noclip", resetFly)

-- =========================
-- Themes Section
-- =========================
local themeSection = Instance.new("Frame", themeTab.Content)
themeSection.Size = UDim2.new(1, 0, 1, 0)
themeSection.BackgroundTransparency = 1

createSection(themeSection, "Custom Theme")

local function applyTheme()
    local theme = Themes
    -- Apply theme to UI elements if exists
    -- For simplicity, only updating main background color
    if GUI and GUI.MainFrame then
        GUI.MainFrame.BackgroundColor3 = theme.Background
    end
end

local function pickColor(callback)
    -- Placeholder color picker, in Roblox you'd use a plugin or custom UI
    -- Here, just cycling colors for demonstration
    local colors = {
        Color3.fromRGB(30,0,0),
        Color3.fromRGB(50,0,0),
        Color3.fromRGB(0,0,50),
        Color3.fromRGB(0,50,0),
        Color3.fromRGB(50,50,0),
        Color3.fromRGB(0,50,50),
        Color3.fromRGB(50,0,50)
    }
    local index = 1
    return function()
        index = index % #colors + 1
        callback(colors[index])
    end
end

local function createColorPicker(parent, label, defaultColor, callback)
    local colorBtn = createButton(parent, label, function()
        local newColor = pickColor(callback)()
        Themes[callback] = newColor
        applyTheme()
        notify("Theme", label .. " updated")
    end)
    return colorBtn
end

createColorPicker(themeSection, "Background Color", Themes.Background, function(color)
    Themes.Background = color
end)
createColorPicker(themeSection, "Accent Color", Themes.Accent, function(color)
    Themes.Accent = color
    applyTheme()
end)
createColorPicker(themeSection, "Text Color", Themes.Text, function(color)
    Themes.Text = color
    applyTheme()
end)

-- =========================
-- Credits Section
-- =========================
local creditsSection = Instance.new("Frame", creditsTab.Content)
creditsSection.Size = UDim2.new(1, 0, 1, 0)
creditsSection.BackgroundTransparency = 1

createSection(creditsSection, "Author Info")
local creditText = Instance.new("TextLabel", creditsSection)
creditText.Size = UDim2.new(1, -20, 0, 100)
creditText.Position = UDim2.new(0,10,0,30)
creditText.BackgroundTransparency = 1
creditText.Text = "Built and maintained by Sweb7xx\nDiscord: @4503"
creditText.TextColor3 = Themes.Text
creditText.Font = Enum.Font.GothamBold
creditText.TextSize = 14
creditText.TextWrapped = true

-- =========================
-- Notifications Helper
-- =========================
local function notify(title, description)
    -- Simple notification system
    local notif = Instance.new("TextLabel")
    notif.Size = UDim2.new(0, 300, 0, 50)
    notif.Position = UDim2.new(0.5, -150, 0, 10)
    notif.BackgroundColor3 = Themes.Accent
    notif.Text = title .. ": " .. description
    notif.TextColor3 = Themes.Text
    notif.Font = Enum.Font.GothamBold
    notif.TextSize = 14
    notif.Parent = GUI.ScreenGui
    -- Tween out
    TweenService:Create(notif, TweenInfo.new(2), {TextTransparency=1, BackgroundTransparency=1}):Play()
    -- Destroy after delay
    delay(2, function() notif:Destroy() end)
end

-- =========================
-- Main Loop for Updates
-- =========================
RunService.RenderStepped:Connect(function()
    if flyEnabled then updateFly() end
end)

-- =========================
-- Final Initialization
-- =========================
createUI()
applyTheme()

-- END of Script
