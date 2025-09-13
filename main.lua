-- MASTXR HUB - Ultimate Player Enhancements GUI
local GUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/BloodLetters/Ash-Libs/refs/heads/main/source.lua"))()
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Feature States
local sprintEnabled = false
local sprintSpeed = 50
local flyEnabled = false
local flySpeed = 50
local infiniteJumpEnabled = false
local noclipConnection
local flyBV
local flyControls = {W=false, S=false, A=false, D=false, Space=false, Shift=false}

-- GUI Main
GUI:CreateMain({
    Name = "MASTXR HUB",
    title = "MASTXR HUB",
    ToggleUI = "K",
    WindowIcon = "home",
    Theme = {
        Background = Color3.fromRGB(30, 0, 0),
        Secondary = Color3.fromRGB(50, 0, 0),
        Accent = Color3.fromRGB(255, 0, 0),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(200, 100, 100),
        Border = Color3.fromRGB(100, 0, 0),
        NavBackground = Color3.fromRGB(20, 0, 0)
    },
    Blur = { Enable = false, value = 0.2 },
    Config = { Enabled = false }
})

-- Helper: Small notifications
local function notify(title, description)
    GUI:CreateNotify({title=title, description=description, Time=2})
end

-- =========================
-- PLAYER ENHANCEMENTS TAB
-- =========================
local main = GUI:CreateTab("Player Enhancements", "home")
GUI:CreateSection({ parent = main, text = "Movement & Navigation" })

-- Sprint Toggle
GUI:CreateToggle({
    parent = main,
    text = "Enable Sprint",
    default = false,
    callback = function(state)
        sprintEnabled = state
        humanoid.WalkSpeed = state and sprintSpeed or 16
        notify("Sprint", state and "Enabled" or "Disabled")
    end
})
GUI:CreateSlider({
    parent = main,
    text = "Sprint Speed",
    min = 16,
    max = 300,
    default = 50,
    function(value)
        sprintSpeed = value
        if sprintEnabled then humanoid.WalkSpeed = sprintSpeed end
    end
})

-- Infinite Jump
infiniteJumpEnabled = false
UIS.JumpRequest:Connect(function()
    if infiniteJumpEnabled then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)
GUI:CreateToggle({
    parent = main,
    text = "Enable Infinite Jump",
    default = false,
    callback = function(state)
        infiniteJumpEnabled = state
        notify("Infinite Jump", state and "Enabled" or "Disabled")
    end
})

-- Fly / Noclip
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
        if direction.Magnitude > 0 then
            flyBV.Velocity = direction.Unit * flySpeed
        else
            flyBV.Velocity = Vector3.new(0,0,0)
        end
    end
end

GUI:CreateToggle({
    parent = main,
    text = "Enable Fly / Noclip",
    default = false,
    callback = function(state)
        flyEnabled = state
        if state then
            -- Noclip
            noclipConnection = RunService.Stepped:Connect(function()
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end)
            -- Fly setup
            flyBV = Instance.new("BodyVelocity")
            flyBV.MaxForce = Vector3.new(1e5,1e5,1e5)
            flyBV.Velocity = Vector3.new(0,0,0)
            flyBV.Parent = hrp
            notify("Fly", "Enabled")
        else
            if noclipConnection then noclipConnection:Disconnect() end
            if flyBV then flyBV:Destroy() end
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = true end
            end
            notify("Fly", "Disabled")
        end
    end
})
GUI:CreateSlider({
    parent = main,
    text = "Fly Speed",
    min = 10,
    max = 300,
    default = 50,
    function(value)
        flySpeed = value
    end
})

-- Fly controls
UIS.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode == Enum.KeyCode.W then flyControls.W = true end
        if input.KeyCode == Enum.KeyCode.S then flyControls.S = true end
        if input.KeyCode == Enum.KeyCode.A then flyControls.A = true end
        if input.KeyCode == Enum.KeyCode.D then flyControls.D = true end
        if input.KeyCode == Enum.KeyCode.Space then flyControls.Space = true end
        if input.KeyCode == Enum.KeyCode.LeftShift then flyControls.Shift = true end
    end
end)
UIS.InputEnded:Connect(function(input)
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

-- Teleport Example
GUI:CreateButton({
    parent = main,
    text = "Teleport to Spawn",
    callback = function()
        hrp.CFrame = CFrame.new(0,5,0)
        notify("Teleport", "Teleported to Spawn")
    end
})

-- =========================
-- SETTINGS TAB
-- =========================
local settings = GUI:CreateTab("Settings", "settings")
GUI:CreateSection({ parent = settings, text = "Reset Enhancements" })
GUI:CreateButton({ parent = settings, text = "Reset Sprint", callback = function()
    sprintEnabled = false
    humanoid.WalkSpeed = 16
    notify("Sprint", "Reset")
end })
GUI:CreateButton({ parent = settings, text = "Reset Infinite Jump", callback = function()
    infiniteJumpEnabled = false
    notify("Infinite Jump", "Reset")
end })
GUI:CreateButton({ parent = settings, text = "Reset Fly/Noclip", callback = function()
    flyEnabled = false
    if noclipConnection then noclipConnection:Disconnect() end
    if flyBV then flyBV:Destroy() end
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = true end
    end
    notify("Fly", "Reset")
end })

-- =========================
-- THEMES TAB
-- =========================
local themes = GUI:CreateTab("Themes", "settings")
GUI:CreateSection({ parent = themes, text = "Custom Theme" })
GUI:CreateColorPicker({
    parent = themes,
    text = "Background Color",
    default = Color3.fromRGB(30,0,0),
    callback = function(color)
        GUI.Theme.Background = color
        notify("Theme", "Background Updated")
    end
})
GUI:CreateColorPicker({
    parent = themes,
    text = "Accent Color",
    default = Color3.fromRGB(255,0,0),
    callback = function(color)
        GUI.Theme.Accent = color
        notify("Theme", "Accent Updated")
    end
})
GUI:CreateColorPicker({
    parent = themes,
    text = "Text Color",
    default = Color3.fromRGB(255,255,255),
    callback = function(color)
        GUI.Theme.Text = color
        notify("Theme", "Text Updated")
    end
})
