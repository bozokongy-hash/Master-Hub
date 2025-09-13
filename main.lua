local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

-- Localization
WindUI:Localization({
    Enabled = true,
    Prefix = "loc:",
    DefaultLanguage = "en",
    Translations = {
        ["en"] = {
            ["WINDUI_EXAMPLE"] = "MASTXR Hub",
            ["WELCOME"] = "Welcome to MASTXR!",
            ["LIB_DESC"] = "Ultimate Roblox GUI library",
            ["SETTINGS"] = "Settings",
            ["APPEARANCE"] = "Appearance",
            ["FEATURES"] = "Features",
            ["UTILITIES"] = "Utilities",
            ["UI_ELEMENTS"] = "UI Elements",
            ["CONFIGURATION"] = "Configuration",
            ["SAVE_CONFIG"] = "Save Configuration",
            ["LOAD_CONFIG"] = "Load Configuration",
            ["THEME_SELECT"] = "Select Theme",
            ["TRANSPARENCY"] = "Window Transparency"
        }
    }
})

WindUI.TransparencyValue = 0.2
WindUI:SetTheme("Dark")

-- Gradient helper
local function gradient(text, startColor, endColor)
    local result = ""
    for i = 1, #text do
        local t = (i - 1) / (#text - 1)
        local r = math.floor((startColor.R + (endColor.R - startColor.R) * t) * 255)
        local g = math.floor((startColor.G + (endColor.G - startColor.G) * t) * 255)
        local b = math.floor((startColor.B + (endColor.B - startColor.B) * t) * 255)
        result = result .. string.format('<font color="rgb(%d,%d,%d)">%s</font>', r, g, b, text:sub(i, i))
    end
    return result
end

-- Key system setup
local ValidKeys = {
    "MASTXR-1234",
    "MASTXR-5678",
    "MASTXR-9012"
}

local function validateKey(key)
    for _, k in ipairs(ValidKeys) do
        if k == key then
            return true
        end
    end
    return false
end

-- Create main window with key system
local Window = WindUI:CreateWindow({
    Title = "loc:WINDUI_EXAMPLE",
    Icon = "geist:window",
    Author = "loc:WELCOME",
    Folder = "MASTXR",
    Size = UDim2.fromOffset(580, 490),
    Theme = "Dark",
    Acrylic = true,
    HideSearchBar = false,
    SideBarWidth = 200,
    KeySystem = {
        Key = ValidKeys, -- predefined keys
        SaveKey = true,  -- save key locally
        Callback = function(key)
            if validateKey(key) then
                WindUI:Notify({
                    Title = "Key Valid",
                    Content = "Welcome to MASTXR Hub!",
                    Icon = "check",
                    Duration = 3
                })
                return true
            else
                WindUI:Notify({
                    Title = "Invalid Key",
                    Content = "The key you entered is invalid.",
                    Icon = "x",
                    Duration = 3
                })
                return false
            end
        end
    }
})

-- Example tags
Window:Tag({ Title = "v1.0.0", Color = Color3.fromHex("#FF3D00") })
Window:Tag({ Title = "Beta", Color = Color3.fromHex("#315dff") })

-- Time tag
local TimeTag = Window:Tag({
    Title = "--:--",
    Radius = 0,
    Color = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#FF0F7B"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#F89B29"), Transparency = 0 },
    }, { Rotation = 45 })
})

-- Rainbow clock
task.spawn(function()
    local hue = 0
    while true do
        local now = os.date("*t")
        local hours = string.format("%02d", now.hour)
        local minutes = string.format("%02d", now.min)
        hue = (hue + 0.01) % 1
        local color = Color3.fromHSV(hue, 1, 1)
        TimeTag:SetTitle(hours .. ":" .. minutes)
        task.wait(0.06)
    end
end)

-- Theme switcher button
Window:CreateTopbarButton("theme-switcher", "moon", function()
    WindUI:SetTheme(WindUI:GetCurrentTheme() == "Dark" and "Light" or "Dark")
    WindUI:Notify({
        Title = "Theme Changed",
        Content = "Current theme: "..WindUI:GetCurrentTheme(),
        Duration = 2
    })
end, 990)

-- Sections & Tabs
local Tabs = {
    Main = Window:Section({ Title = "loc:FEATURES", Opened = true }),
    Settings = Window:Section({ Title = "loc:SETTINGS", Opened = true }),
    Utilities = Window:Section({ Title = "loc:UTILITIES", Opened = true })
}

local TabHandles = {
    Elements = Tabs.Main:Tab({ Title = "loc:UI_ELEMENTS", Icon = "layout-grid", Desc = "UI Elements Example" }),
    Appearance = Tabs.Settings:Tab({ Title = "loc:APPEARANCE", Icon = "brush" }),
    Config = Tabs.Utilities:Tab({ Title = "loc:CONFIGURATION", Icon = "settings" })
}

-- Example toggle
local ElementsSection = TabHandles.Elements:Section({ Title = "Section Example", Icon = "bird" })
local featureToggle = ElementsSection:Toggle({
    Title = "Enable Features",
    Value = false,
    Callback = function(state)
        WindUI:Notify({
            Title = "Features",
            Content = state and "Features Enabled" or "Features Disabled",
            Icon = state and "check" or "x",
            Duration = 2
        })
    end
})

-- Example slider
ElementsSection:Slider({
    Title = "Effect Intensity",
    Value = { Min = 0, Max = 100, Default = 50 },
    Callback = function(value)
        print("Intensity set to:", value)
    end
})

-- Example dropdown
ElementsSection:Dropdown({
    Title = "Select Mode",
    Values = { "Standard", "Advanced", "Expert" },
    Value = "Standard",
    Callback = function(option)
        WindUI:Notify({
            Title = "Mode Changed",
            Content = "Selected: "..option,
            Duration = 2
        })
    end
})

-- Notification button
ElementsSection:Button({
    Title = "Show Notification",
    Icon = "bell",
    Callback = function()
        WindUI:Notify({
            Title = "Hello MASTXR!",
            Content = "This is a sample notification",
            Icon = "bell",
            Duration = 3
        })
    end
})

-- Colorpicker example
ElementsSection:Colorpicker({
    Title = "Select Color",
    Default = Color3.fromHex("#FF3D00"),
    Callback = function(color)
        WindUI:Notify({
            Title = "Color Changed",
            Content = "New color: "..color:ToHex(),
            Duration = 2
        })
    end
})

-- Config Manager example
local configName = "default"
local configFile = nil
local MyPlayerData = { name = "Player1", level = 1, inventory = { "sword", "shield" } }

local ConfigManager = Window.ConfigManager
if ConfigManager then
    ConfigManager:Init(Window)
end
