-- Load Ash-Libs Framework
local GUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/BloodLetters/Ash-Libs/refs/heads/main/source.lua"))()

-- Create Main Window (MASTXR Ritual Style)
GUI:CreateMain({
    Name = "MASTXR",
    title = "MASTXR RITUAL GUI",
    ToggleUI = "K",
    WindowIcon = "home",
    alwaysIconOnly = false,
    Theme = {
        Background = Color3.fromRGB(5, 5, 10),         -- Pure void black
        Secondary = Color3.fromRGB(15, 0, 15),        -- Dark ritual purple/black
        Accent = Color3.fromRGB(255, 0, 50),          -- Neon blood-red
        AccentSecondary = Color3.fromRGB(180, 0, 40), -- Deeper crimson glow
        Text = Color3.fromRGB(255, 255, 255),         -- White ritual markings
        TextSecondary = Color3.fromRGB(200, 50, 70),  -- Blood-tinted text
        Border = Color3.fromRGB(100, 0, 30),          -- Red border glow
        NavBackground = Color3.fromRGB(10, 0, 15),    -- Dark side panel
        Surface = Color3.fromRGB(20, 0, 20),          -- Panel surface
        SurfaceVariant = Color3.fromRGB(30, 0, 30),   -- Variant for layers
        Success = Color3.fromRGB(0, 255, 100),        -- Toxic ritual green
        Warning = Color3.fromRGB(255, 200, 0),        -- Glowing yellow sigils
        Error = Color3.fromRGB(255, 0, 80),           -- Burning red failure
        Shadow = Color3.fromRGB(0, 0, 0)              -- Void shadows
    },
    Blur = {
        Enable = false,
        value = 0.2
    },
    Config = {
        Enabled = false,
        FileName = "MASTXR_Ritual",
        FolerName = "MASTXR_Dir"
    }
})

-- Ritual Tabs
local main = GUI:CreateTab("Ritual", "skull")
GUI:CreateSection({
    parent = main,
    text = "Main Ritual Chamber"
})

local settings = GUI:CreateTab("Runes", "settings")
GUI:CreateSection({
    parent = settings,
    text = "Rune Configurations"
})

local credits = GUI:CreateTab("Blood Oath", "info")
GUI:CreateSection({
    parent = credits,
    text = "Bound by the MASTXR"
})
