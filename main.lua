-- MASTXR HUB - Ultimate Player Enhancements GUI (No Shadow Version)
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
    Logo = "https://i.imgur.com/OuS6Kwc.png",
    Theme = {
        Background = Color3.fromRGB(30, 0, 0),
        Secondary = Color3.fromRGB(50, 0, 0),
        Accent = Color3.fromRGB(255, 0, 0),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(200, 100, 100),
        Border = Color3.fromRGB(0,0,0),        -- Removed shadow/border
        NavBackground = Color3.fromRGB(0,0,0)  -- Removed shadow/nav background
    },
    Blur = { Enable = false, value = 0 },      -- Ensure no blur
    Config = { Enabled = false }
})

-- Helper: Small notifications
local function notify(title, description)
    GUI:CreateNotify({title=title, description=description, Time=2})
end

-- =========================
-- PLAYER ENHANCEMENTS TAB
-- =========================
local mainTab = GUI:CreateTab("Player Enhancements", "home")
local movementSection = GUI:CreateSection({ parent = mainTab, text = "Movement & Navigation" })

-- Sprint Toggle
GUI:CreateToggle({
    parent = movementSection,
    text = "Enable Sprint",
    default = false,
    callback = function(state)
        sprintEnabled = state
        humanoid.WalkSpeed = state and sprintSpeed or 16
        notify("Sprint", state and "Enabled" or "Disabled")
    end
})

GUI:CreateSlider({
    parent = movementSection,
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
UIS.JumpRequest:Connect(function()
    if infiniteJumpEnabled then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

GUI:CreateToggle({
    parent = movementSection,
    text = "Enable Infinite Jump",
    default = false,
    callback = function(state)
        infiniteJumpEnabled = state
        notify("Infinite Jump", state and "Enabled" or "Disabled")
    end
})

-- Dioff Mode (Invisible)
GUI:CreateToggle({
    parent = movementSection,
    text = "Dioff Mode (Invisible)",
    default = false,
    callback = function(state)
        dioffEnabled = state
        if dioffEnabled then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = 1
                elseif part:IsA("Decal") then
                    part.Transparency = 1
                elseif part:IsA("Accessory") and part:FindFirstChild("Handle") then
                    part.Handle.Transparency = 1
                end
            end
        else
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = 0
                elseif part:IsA("Decal") then
                    part.Transparency = 0
                elseif part:IsA("Accessory") and part:FindFirstChild("Handle") then
                    part.Handle.Transparency = 0
                end
            end
        end
        notify("Dioff Mode", state and "Invisible Enabled" or "Invisible Disabled")
    end
})

-- Teleport Example
GUI:CreateButton({
    parent = movementSection,
    text = "Teleport to Spawn",
    callback = function()
        hrp.CFrame = CFrame.new(0,5,0)
        notify("Teleport", "Teleported to Spawn")
    end
})

-- =========================
-- SETTINGS TAB
-- =========================
local settingsTab = GUI:CreateTab("Settings", "settings")
local resetSection = GUI:CreateSection({ parent = settingsTab, text = "Reset Enhancements" })

GUI:CreateButton({ parent = resetSection, text = "Reset Sprint", callback = function()
    sprintEnabled = false
    humanoid.WalkSpeed = 16
    notify("Sprint", "Reset")
end })

GUI:CreateButton({ parent = resetSection, text = "Reset Infinite Jump", callback = function()
    infiniteJumpEnabled = false
    notify("Infinite Jump", "Reset")
end })

GUI:CreateButton({ parent = resetSection, text = "Reset Dioff", callback = function()
    dioffEnabled = false
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = 0
        elseif part:IsA("Decal") then
            part.Transparency = 0
        elseif part:IsA("Accessory") and part:FindFirstChild("Handle") then
            part.Handle.Transparency = 0
        end
    end
    notify("Dioff Mode", "Reset (Visible)")
end })

-- =========================
-- THEMES TAB
-- =========================
local themesTab = GUI:CreateTab("Themes", "settings")
local themeSection = GUI:CreateSection({ parent = themesTab, text = "Custom Theme" })

GUI:CreateColorPicker({
    parent = themeSection,
    text = "Background Color",
    default = Color3.fromRGB(30,0,0),
    callback = function(color)
        GUI.Theme.Background = color
        if GUI.UpdateTheme then GUI:UpdateTheme() end
        notify("Theme", "Background Updated")
    end
})

GUI:CreateColorPicker({
    parent = themeSection,
    text = "Accent Color",
    default = Color3.fromRGB(255,0,0),
    callback = function(color)
        GUI.Theme.Accent = color
        if GUI.UpdateTheme then GUI:UpdateTheme() end
        notify("Theme", "Accent Updated")
    end
})

GUI:CreateColorPicker({
    parent = themeSection,
    text = "Text Color",
    default = Color3.fromRGB(255,255,255),
    callback = function(color)
        GUI.Theme.Text = color
        if GUI.UpdateTheme then GUI:UpdateTheme() end
        notify("Theme", "Text Updated")
    end
})

-- =========================
-- CREDITS TAB (Improved Layout)
-- =========================
local creditsTab = GUI:CreateTab("Credits", "info")
local creditsSection = GUI:CreateSection({ parent = creditsTab, text = "MASTXR HUB Credits" })

GUI:CreateLabel({ parent = creditsSection, text = "Creator", description = "Sweb" })
GUI:CreateLabel({ parent = creditsSection, text = "Discord", description = "@4503" })
GUI:CreateLabel({ parent = creditsSection, text = "Library Used", description = "Ash-Libs" })
GUI:CreateLabel({ parent = creditsSection, text = "Version", description = "1.0 (No Shadow & Dioff Mode)" })
