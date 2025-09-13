-- ===== MASTXR HUB - All-in-One GUI with Simple Key System =====

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

-- Localization
WindUI:Localization({
    Enabled = true,
    Prefix = "loc:",
    DefaultLanguage = "en",
    Translations = {
        ["en"] = {
            ["WELCOME"] = "Welcome to MASTXR!",
            ["FEATURES"] = "Features",
            ["SETTINGS"] = "Settings",
            ["UTILITIES"] = "Utilities",
            ["UI_ELEMENTS"] = "UI Elements",
            ["APPEARANCE"] = "Appearance",
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

-- Gradient helper for notifications
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

-- Popup on load
WindUI:Popup({
    Title = gradient("MASTXR Hub", Color3.fromHex("#6A11CB"), Color3.fromHex("#2575FC")),
    Icon = "sparkles",
    Content = "Welcome to MASTXR Hub!",
    Buttons = {
        {
            Title = "Get Started",
            Icon = "arrow-right",
            Variant = "Primary",
            Callback = function() end
        }
    }
})

-- ===== Create Main Window =====
local Window = WindUI:CreateWindow({
    Title = "MASTXR HUB",
    Icon = "geist:window",
    Author = "MASTXR Team",
    Folder = "MASTXR_HUB",
    Size = UDim2.fromOffset(580, 490),
    Theme = "Dark",
    User = { Enabled = true, Anonymous = true },
    Acrylic = true,
    HideSearchBar = false,
    SideBarWidth = 200
})

-- ===== Key System (Simple local version) =====
local unlocked = false
local validKeys = { "MASTXR-123", "MASTXR-999" }

local function isKeyValid(key)
    for i, k in pairs(validKeys) do
        if key == k then
            return true
        end
    end
    return false
end

local function askForKey()
    Window:Dialog({
        Title = "Enter MASTXR Key",
        Content = "Type your key to unlock the hub",
        Inputs = {
            { Placeholder = "XXXX-XXXX-XXXX", Default = "" }
        },
        Buttons = {
            {
                Title = "Verify",
                Variant = "Primary",
                Callback = function(inputs)
                    local keyInput = inputs[1]
                    if isKeyValid(keyInput) then
                        unlocked = true
                        WindUI:Notify({
                            Title = "Key Accepted",
                            Content = "MASTXR is unlocked!",
                            Icon = "check",
                            Duration = 3
                        })
                        return true
                    else
                        WindUI:Notify({
                            Title = "Invalid Key",
                            Content = "Try again!",
                            Icon = "x",
                            Duration = 3
                        })
                        return false
                    end
                end
            }
        }
    })
end

askForKey()

-- Helper to lock features until key is unlocked
local function requireUnlock(callback)
    return function(...)
        if not unlocked then
            WindUI:Notify({
                Title = "Locked",
                Content = "Enter a valid key first",
                Duration = 2
            })
            return
        end
        return callback(...)
    end
end

-- ===== Tabs and Sections =====
local Tabs = {
    Main = Window:Section({ Title = "loc:FEATURES", Opened = true }),
    Settings = Window:Section({ Title = "loc:SETTINGS", Opened = true }),
    Utilities = Window:Section({ Title = "loc:UTILITIES", Opened = true })
}

local TabHandles = {
    Elements = Tabs.Main:Tab({ Title = "loc:UI_ELEMENTS", Icon = "layout-grid" }),
    Appearance = Tabs.Settings:Tab({ Title = "loc:APPEARANCE", Icon = "brush" }),
    Config = Tabs.Utilities:Tab({ Title = "loc:CONFIGURATION", Icon = "settings" })
}

-- ===== Elements Section =====
TabHandles.Elements:Paragraph({
    Title = "Interactive Components",
    Desc = "Explore MASTXR's powerful elements",
    Image = "component",
    ImageSize = 20,
    Color = Color3.fromHex("#30ff6a")
})

local ElementsSection = TabHandles.Elements:Section({
    Title = "Section Example",
    Icon = "bird"
})

local featureToggle = ElementsSection:Toggle({
    Title = "Enable Features",
    Value = false,
    Callback = requireUnlock(function(state)
        WindUI:Notify({
            Title = "Features",
            Content = state and "Features Enabled" or "Features Disabled",
            Icon = state and "check" or "x",
            Duration = 2
        })
    end)
})

local intensitySlider = ElementsSection:Slider({
    Title = "Effect Intensity",
    Value = { Min = 0, Max = 100, Default = 50 },
    Callback = requireUnlock(function(value)
        print("Intensity set to:", value)
    end)
})

local modeDropdown = ElementsSection:Dropdown({
    Title = "Select Mode",
    Values = { "Standard", "Advanced", "Expert" },
    Value = "Standard",
    Callback = requireUnlock(function(option)
        WindUI:Notify({
            Title = "Mode Changed",
            Content = "Selected: "..option,
            Duration = 2
        })
    end)
})

ElementsSection:Button({
    Title = "Secret Feature",
    Icon = "shield",
    Callback = requireUnlock(function()
        WindUI:Notify({ Title = "Secret Feature", Content = "You used it!", Duration = 2 })
    end)
})

ElementsSection:Colorpicker({
    Title = "Select Color",
    Default = Color3.fromHex("#30ff6a"),
    Transparency = 0,
    Callback = requireUnlock(function(color, transparency)
        WindUI:Notify({
            Title = "Color Changed",
            Content = "New color: "..color:ToHex().."\nTransparency: "..transparency,
            Duration = 2
        })
    end)
})

ElementsSection:Code({
    Title = "my_code.luau",
    Code = [[print("Hello world!")]],
    OnCopy = requireUnlock(function()
        print("Copied to clipboard!")
    end)
})

-- ===== Appearance Section =====
TabHandles.Appearance:Paragraph({
    Title = "Customize Interface",
    Desc = "Personalize your experience",
    Image = "palette",
    ImageSize = 20,
    Color = "White"
})

local themes = {}
for themeName, _ in pairs(WindUI:GetThemes()) do
    table.insert(themes, themeName)
end
table.sort(themes)

local themeDropdown = TabHandles.Appearance:Dropdown({
    Title = "loc:THEME_SELECT",
    Values = themes,
    Value = "Dark",
    Callback = function(theme)
        WindUI:SetTheme(theme)
        WindUI:Notify({
            Title = "Theme Applied",
            Content = theme,
            Icon = "palette",
            Duration = 2
        })
    end
})

TabHandles.Appearance:Slider({
    Title = "loc:TRANSPARENCY",
    Value = { Min = 0, Max = 1, Default = 0.2 },
    Step = 0.1,
    Callback = function(value)
        WindUI.TransparencyValue = tonumber(value)
        Window:ToggleTransparency(tonumber(value) > 0)
    end
})

-- ===== Config Section =====
local configName = "default"
local configFile = nil
local MyPlayerData = { name = "Player1", level = 1, inventory = { "sword", "shield", "potion" } }

local ConfigManager = Window.ConfigManager
if ConfigManager then
    ConfigManager:Init(Window)
    configFile = ConfigManager:CreateConfig(configName)

    TabHandles.Config:Input({
        Title = "Config Name",
        Value = configName,
        Callback = function(value)
            configName = value or "default"
        end
    })

    TabHandles.Config:Button({
        Title = "loc:SAVE_CONFIG",
        Icon = "save",
        Variant = "Primary",
        Callback = function()
            configFile:Register("featureToggle", featureToggle)
            configFile:Register("intensitySlider", intensitySlider)
            configFile:Register("modeDropdown", modeDropdown)
            configFile:Register("themeDropdown", themeDropdown)
            configFile:Set("playerData", MyPlayerData)
            configFile:Set("lastSave", os.date("%Y-%m-%d %H:%M:%S"))
            if configFile:Save() then
                WindUI:Notify({ Title = "loc:SAVE_CONFIG", Content = "Saved as: "..configName, Icon = "check", Duration = 3 })
            else
                WindUI:Notify({ Title = "Error", Content = "Failed to save config", Icon = "x", Duration = 3 })
            end
        end
    })

    TabHandles.Config:Button({
        Title = "loc:LOAD_CONFIG",
        Icon = "folder",
        Callback = function()
            local loadedData = configFile:Load()
            if loadedData then
                if loadedData.playerData then MyPlayerData = loadedData.playerData end
                local lastSave = loadedData.lastSave or "Unknown"
                WindUI:Notify({ Title = "loc:LOAD_CONFIG", Content = "Loaded: "..configName.."\nLast save: "..lastSave, Icon = "refresh-cw", Duration = 5 })
            else
                WindUI:Notify({ Title = "Error", Content = "Failed to load config", Icon = "x", Duration = 3 })
            end
        end
    })
end

TabHandles.Config:Paragraph({
    Title = "Created with ❤️",
    Desc = "github.com/Footagesus/WindUI",
    Image = "github",
    ImageSize = 20,
    Color = "Grey",
    Buttons = {
        {
            Title = "Copy Link",
            Icon = "copy",
            Variant = "Tertiary",
            Callback = function()
                setclipboard("https://github.com/Footagesus/WindUI")
                WindUI:Notify({ Title = "Copied!", Content = "GitHub link copied to clipboard", Duration = 2 })
            end
        }
    }
})

Window:OnClose(function()
    print("Window closed")
    if ConfigManager and configFile then
        configFile:Set("playerData", MyPlayerData)
        configFile:Set("lastSave", os.date("%Y-%m-%d %H:%M:%S"))
        configFile:Save()
        print("Config auto-saved on close")
    end
end)

Window:OnDestroy(function()
    print("Window destroyed")
end)
