-- Load Ash-Libs Framework
local GUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/BloodLetters/Ash-Libs/refs/heads/main/source.lua"))()

-- Create Main Window
GUI:CreateMain({
    Name = "MASTXR",
    title = "MASTXR GUI",
    ToggleUI = "K",
    WindowIcon = "home",
    alwaysIconOnly = false,
    Theme = {
        Background = Color3.fromRGB(15, 15, 25),
        Secondary = Color3.fromRGB(25, 25, 35),
        Accent = Color3.fromRGB(200, 0, 50), -- Red accent for MASTXR vibe
        AccentSecondary = Color3.fromRGB(150, 0, 40),
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
        FileName = "MASTXR",
        FolerName = "MASTXR_Dir"
    }
})

-- Example Tabs (empty for now)
local main = GUI:CreateTab("Main", "home")
GUI:CreateSection({
    parent = main,
    text = "Main Section"
})

local settings = GUI:CreateTab("Settings", "settings")
GUI:CreateSection({
    parent = settings,
    text = "Settings Section"
})

local credits = GUI:CreateTab("Credits", "info")
GUI:CreateSection({
    parent = credits,
    text = "Credits Section"
})
