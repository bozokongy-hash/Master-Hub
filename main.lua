-- MASTXR HUB - Ultimate Player Enhancements GUI (Cleaned Version)
local GUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/BloodLetters/Ash-Libs/refs/heads/main/source.lua"))()
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")
local UIS = game:GetService("UserInputService")

-- Feature States
local sprintEnabled = false
local sprintSpeed = 50
local infiniteJumpEnabled = false
local dioffEnabled = false

-- GUI Main
GUI:CreateMain({
    Name = "MASTXR HUB",
    title = "MASTXR HUB",
    ToggleUI = "K",
    WindowIcon = "home",
    Logo = "https://i.imgur.com/OuS6Kwc.png",  -- Your logo here
    Theme = {
        Background = Color3.fromRGB(30, 0, 0),
        Secondary = Color3.fromRGB(50, 0, 0),
        Accent = Color3.fromRGB(255, 0, 0),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(200, 100, 100),
        Border = Color3.fromRGB(100, 0, 0),
        NavBackground = Color3.fromRGB(20, 0, 0)
    },
    Blur = { Enable = false, value = 0 },
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
    callback = function(value)
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

-- Dioff Option
GUI:CreateToggle({
    parent = main,
    text = "Dioff Mode",
    default = false,
    callback = function(state)
        dioffEnabled = state
        notify("Dioff", state and "Enabled" or "Disabled")
    end
})

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
GUI:CreateButton({ parent = settings, text = "Reset Dioff", callback = function()
    dioffEnabled = false
    notify("Dioff", "Reset")
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

-- =========================
-- CREDITS TAB
-- =========================
local credits = GUI:CreateTab("Credits", "info")
GUI:CreateSection({ parent = credits, text = "MASTXR HUB Credits" })
GUI:CreateLabel({ parent = credits, text = "Created By", description = "Sweb" })
GUI:CreateLabel({ parent = credits, text = "Discord", description = "@4503" })
GUI:CreateLabel({ parent = credits, text = "GUI Library", description = "Ash-Libs" })
