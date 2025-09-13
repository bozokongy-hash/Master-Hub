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
        GUI:CreateNotify({title="Sprint", description="Sprint "..(state and "Enabled" or "Disabled")})
    end
})
GUI:CreateSlider({
    parent = main,
    text = "Sprint Speed",
    min = 16,
    max = 200,
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
        GUI:CreateNotify({title="Infinite Jump", description=state and "Enabled" or "Disabled"})
    end
})

-- Fly / Noclip
local flyBV
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
        flyBV.Velocity = direction.Unit * flySpeed
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
            GUI:CreateNotify({title="Fly", description="Fly Enabled"})
        else
            if noclipConnection then noclipConnection:Disconnect() end
            if flyBV then flyBV:Destroy() end
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = true end
            end
            GUI:CreateNotify({title="Fly", description="Fly Disabled"})
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
        GUI:CreateNotify({title="Teleport", description="Teleported to Spawn"})
    end
})

-- =========================
-- SETTINGS TAB
-- =========================
local settings = GUI:CreateTab("MASTXR Settings", "settings")
GUI:CreateSection({ parent = settings, text = "Reset Enhancements" })
GUI:CreateButton({ parent = settings, text = "Reset Sprint", callback = function() sprintEnabled = false humanoid.WalkSpeed=16 end })
GUI:CreateButton({ parent = settings, text = "Reset Infinite Jump", callback = function() infiniteJumpEnabled = false end })
GUI:CreateButton({ parent = settings, text = "Reset Fly/Noclip", callback = function()
    flyEnabled = false
    if noclipConnection then noclipConnection:Disconnect() end
    if flyBV then flyBV:Destroy() end
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = true end
    end
end })

-- =========================
-- THEMES TAB
-- =========================
local themes = GUI:CreateTab("Themes", "settings")
GUI:CreateSection({ parent = themes, text = "Pick Theme" })
local themeOptions = {
    Red = {Background=Color3.fromRGB(30,0,0), Accent=Color3.fromRGB(255,0,0)},
    Blue = {Background=Color3.fromRGB(0,0,30), Accent=Color3.fromRGB(0,170,255)},
    Dark = {Background=Color3.fromRGB(15,15,15), Accent=Color3.fromRGB(255,255,255)}
}
for name, colors in pairs(themeOptions) do
    GUI:CreateButton({ parent = themes, text = name.." Theme", callback = function()
        GUI:SetTheme({Background=colors.Background, Accent=colors.Accent})
        GUI:CreateNotify({title="Theme", description=name.." Applied"})
    end })
end
