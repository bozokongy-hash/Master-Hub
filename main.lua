-- Load WindUI framework
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

-- Localization (renamed for MASTXR)
WindUI:Localization({
    Enabled = true,
    Prefix = "loc:",
    DefaultLanguage = "en",
    Translations = {
        ["en"] = {
            ["MASTXR_EXAMPLE"] = "MASTXR HUB",
            ["WELCOME"] = "Welcome to MASTXR Hub!",
            ["LIB_DESC"] = "The ultimate all-in-one hub for Roblox",
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

-- Default transparency & theme
WindUI.TransparencyValue = 0.2
WindUI:SetTheme("Dark")

-- Window Setup (Renamed to MASTXR)
local Window = WindUI:CreateWindow({
    Title = "loc:MASTXR_EXAMPLE",
    Icon = "geist:window",
    Author = "loc:WELCOME",
    Folder = "MASTXR_Hub",
    Size = UDim2.fromOffset(580, 490),
    Theme = "Dark",
    User = {
        Enabled = true,
        Anonymous = true,
        Callback = function()
            WindUI:Notify({
                Title = "User Profile",
                Content = "Profile clicked!",
                Duration = 3
            })
        end
    },
    Acrylic = true,
    HideSearchBar = false,
    SideBarWidth = 200,
})

-- Tags
Window:Tag({ Title = "v2.0", Color = Color3.fromHex("#FF0050") })
Window:Tag({ Title = "MASTXR", Color = Color3.fromHex("#30ff6a") })

-- Clock Tag (kept)
local TimeTag = Window:Tag({
    Title = "--:--",
    Radius = 0,
    Color = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#FF0F7B"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#F89B29"), Transparency = 0 },
    }, { Rotation = 45 }),
})

-- Time updater
task.spawn(function()
	while true do
		local now = os.date("*t")
		TimeTag:SetTitle(string.format("%02d:%02d", now.hour, now.min))
		task.wait(0.5)
	end
end)

-- Theme Switcher button
Window:CreateTopbarButton("theme-switcher", "moon", function()
    WindUI:SetTheme(WindUI:GetCurrentTheme() == "Dark" and "Light" or "Dark")
    WindUI:Notify({
        Title = "Theme Changed",
        Content = "Now using "..WindUI:GetCurrentTheme().." mode",
        Duration = 2
    })
end, 999)

-- Main Tabs
local Tabs = {
    Main = Window:Section({ Title = "loc:FEATURES", Opened = true }),
    Settings = Window:Section({ Title = "loc:SETTINGS", Opened = true }),
    Utilities = Window:Section({ Title = "loc:UTILITIES", Opened = true })
}

-- Tab Handles
local TabHandles = {
    Elements = Tabs.Main:Tab({ Title = "loc:UI_ELEMENTS", Icon = "layout-grid", Desc = "Core UI Elements" }),
    Appearance = Tabs.Settings:Tab({ Title = "loc:APPEARANCE", Icon = "brush" }),
    Config = Tabs.Utilities:Tab({ Title = "loc:CONFIGURATION", Icon = "settings" })
}

-- Example Elements
local ElementsSection = TabHandles.Elements:Section({ Title = "Core Features", Icon = "sparkles" })

local featureToggle = ElementsSection:Toggle({
    Title = "Enable Features",
    Value = false,
    Callback = function(state) 
        WindUI:Notify({
            Title = "Features",
            Content = state and "Enabled" or "Disabled",
            Icon = state and "check" or "x",
            Duration = 2
        })
    end
})

local intensitySlider = ElementsSection:Slider({
    Title = "Effect Intensity",
    Value = { Min = 0, Max = 100, Default = 50 },
    Callback = function(value) print("Intensity set to:", value) end
})

local modeDropdown = ElementsSection:Dropdown({
    Title = "Mode Select",
    Values = { "Standard", "Advanced", "Expert" },
    Value = "Standard",
    Callback = function(option)
        WindUI:Notify({
            Title = "Mode Changed",
            Content = "Now: "..option,
            Duration = 2
        })
    end
})

ElementsSection:Button({
    Title = "Show Notification",
    Icon = "bell",
    Callback = function()
        WindUI:Notify({
            Title = "MASTXR Hub",
            Content = "Notification test successful!",
            Icon = "bell",
            Duration = 3
        })
    end
})

-- Appearance Tab
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

-- Config Tab
TabHandles.Config:Paragraph({
    Title = "Configuration Manager",
    Desc = "Save & Load settings easily",
    Image = "save",
    ImageSize = 20,
    Color = "White"
})

-- Footer
local footerSection = Window:Section({ Title = "MASTXR Hub " .. WindUI.Version })
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
                WindUI:Notify({
                    Title = "Copied!",
                    Content = "GitHub link copied",
                    Duration = 2
                })
            end
        }
    }
})
