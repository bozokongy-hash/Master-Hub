-- MASTXR HUB - GUI Skeleton with Key System
local GUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/BloodLetters/Ash-Libs/refs/heads/main/source.lua"))()

-- Set your key here
local correctKey = "mastxr123" -- You can change this

-- Prompt for key
local userKey = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("ScreenGui"):WaitForChild("TextBox") -- Example: you can create your own input
local input = game:GetService("Players").LocalPlayer:PromptInput("Enter Key for MASTXR GUI:")

if input ~= correctKey then
    warn("Incorrect key! GUI will not load.")
    return
end

-- Create Main GUI
GUI:CreateMain({
    Name = "MASTXR",
    title = "MASTXR GUI",
    ToggleUI = "K",
    WindowIcon = "home", -- home icon
    alwaysIconOnly = false,
    Theme = {
        Background = Color3.fromRGB(15, 15, 25),
        Secondary = Color3.fromRGB(25, 25, 35),
        Accent = Color3.fromRGB(255, 0, 0), -- Neon Red
        AccentSecondary = Color3.fromRGB(200, 0, 0),
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
    },
    Blur = {
        Enable = false,
        value = 0.2
    },
    Config = {
        Enabled = false,
        FileName = "MASTXRConfig",
        FolerName = "MASTXRDir",
    }
})

-- Tabs
local main = GUI:CreateTab("Main", "home")
GUI:CreateSection({ parent = main, text = "Main Section" })

local settings = GUI:CreateTab("Settings", "settings")
GUI:CreateSection({ parent = settings, text = "Settings Section" })

-- Example Button
GUI:CreateButton({
    parent = main,
    text = "Test Button",
    flag = "TestBtn",
    callback = function()
        GUI:CreateNotify({ title = "MASTXR", description = "Button clicked!" })
    end
})
