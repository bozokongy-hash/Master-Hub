-- MASTXR HUB v2 - All-in-One GUI with Feature Menus
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

-- Localization
WindUI:Localization({
    Enabled = true,
    Prefix = "loc:",
    DefaultLanguage = "en",
    Translations = {
        ["en"] = {
            ["MASTXR_EXAMPLE"] = "MASTXR HUB v2",
            ["WELCOME"] = "Welcome to MASTXR Hub!",
            ["PLAYER"] = "Player",
            ["UTILITIES"] = "Utilities",
            ["SETTINGS"] = "Settings",
            ["CREDITS"] = "Credits",
            ["THEME_SELECT"] = "Select Theme",
            ["TRANSPARENCY"] = "Window Transparency",
            ["CONFIGURATION"] = "Configuration",
            ["SAVE_CONFIG"] = "Save Configuration",
            ["LOAD_CONFIG"] = "Load Configuration"
        }
    }
})

-- Default theme & transparency
WindUI.TransparencyValue = 0.2
WindUI:SetTheme("Dark")

-- Window
local Window = WindUI:CreateWindow({
    Title = "loc:MASTXR_EXAMPLE",
    Icon = "geist:window",
    Author = "loc:WELCOME",
    Folder = "MASTXR_Hub_v2",
    Size = UDim2.fromOffset(600, 500),
    Theme = "Dark",
    Acrylic = true,
    HideSearchBar = false,
    SideBarWidth = 200,
})

-- Tags
Window:Tag({ Title = "v2.0", Color = Color3.fromHex("#FF0050") })
Window:Tag({ Title = "MASTXR", Color = Color3.fromHex("#30ff6a") })

-- Clock
local TimeTag = Window:Tag({
    Title = "--:--",
    Radius = 0,
    Color = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#FF0F7B"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#F89B29"), Transparency = 0 },
    }, { Rotation = 45 }),
})

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

-- Tabs
local Tabs = {
    Player = Window:Section({ Title = "loc:PLAYER", Opened = true }),
    Utilities = Window:Section({ Title = "loc:UTILITIES", Opened = true }),
    Settings = Window:Section({ Title = "loc:SETTINGS", Opened = true }),
    Credits = Window:Section({ Title = "loc:CREDITS", Opened = true }),
}

-------------------------
-- PLAYER TAB
-------------------------
local PlayerTab = Tabs.Player:Tab({ Title = "Player Features", Icon = "user" })
local PlayerMenu = PlayerTab:Section({ Title = "Select Feature", Icon = "grid" })

-- Helper function to go back to menu
local function reopenMenu(section)
    section:Clear()
    PlayerMenu:Reopen()
end

-- Aimbot
PlayerMenu:Button({
    Title = "Aimbot",
    Icon = "target",
    Callback = function()
        PlayerMenu:Clear()
        local AimbotSection = PlayerTab:Section({ Title = "Aimbot Settings", Icon = "target" })

        AimbotSection:Toggle({
            Title = "Enable Aimbot",
            Value = false,
            Callback = function(state)
                WindUI:Notify({Title="Aimbot", Content=state and "Enabled" or "Disabled", Duration=2})
                -- insert aimbot logic here
            end
        })

        AimbotSection:Slider({
            Title = "FOV",
            Value = {Min=10, Max=180, Default=90},
            Callback = function(value)
                print("Aimbot FOV:", value)
            end
        })

        AimbotSection:Button({
            Title = "Back",
            Icon = "arrow-left",
            Callback = function() reopenMenu(AimbotSection) end
        })
    end
})

-- ESP
PlayerMenu:Button({
    Title = "ESP",
    Icon = "eye",
    Callback = function()
        PlayerMenu:Clear()
        local ESPSection = PlayerTab:Section({ Title = "ESP Settings", Icon = "eye" })

        ESPSection:Toggle({
            Title = "Enable ESP",
            Value = false,
            Callback = function(state)
                WindUI:Notify({Title="ESP", Content=state and "Enabled" or "Disabled", Duration=2})
                -- insert ESP logic here
            end
        })

        ESPSection:Button({
            Title = "Back",
            Icon = "arrow-left",
            Callback = function() reopenMenu(ESPSection) end
        })
    end
})

-- Misc Player Mods
PlayerMenu:Button({
    Title = "Misc Player Mods",
    Icon = "settings",
    Callback = function()
        PlayerMenu:Clear()
        local MiscSection = PlayerTab:Section({ Title = "Misc Player Mods", Icon = "settings" })

        MiscSection:Toggle({
            Title = "Speed Hack",
            Value = false,
            Callback = function(state)
                humanoid.WalkSpeed = state and 100 or 16
                WindUI:Notify({Title="Speed Hack", Content=state and "Enabled" or "Disabled", Duration=2})
            end
        })

        MiscSection:Slider({
            Title = "Jump Power",
            Value = {Min=50, Max=500, Default=50},
            Callback = function(value)
                humanoid.JumpPower = value
                WindUI:Notify({Title="Jump Power", Content="Set to "..value, Duration=2})
            end
        })

        MiscSection:Toggle({
            Title = "Infinite Jump",
            Value = false,
            Callback = function(state)
                _G.InfJump = state
                if state then
                    game:GetService("UserInputService").JumpRequest:Connect(function()
                        if _G.InfJump then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
                    end)
                end
                WindUI:Notify({Title="Infinite Jump", Content=state and "Enabled" or "Disabled", Duration=2})
            end
        })

        MiscSection:Toggle({
            Title = "Noclip",
            Value = false,
            Callback = function(state)
                _G.Noclip = state
                if state then
                    game:GetService("RunService").Stepped:Connect(function()
                        if _G.Noclip then
                            for _, part in pairs(char:GetDescendants()) do
                                if part:IsA("BasePart") then
                                    part.CanCollide = false
                                end
                            end
                        end
                    end)
                end
                WindUI:Notify({Title="Noclip", Content=state and "Enabled" or "Disabled", Duration=2})
            end
        })

        MiscSection:Button({
            Title = "Back",
            Icon = "arrow-left",
            Callback = function() reopenMenu(MiscSection) end
        })
    end
})

-------------------------
-- UTILITIES TAB
-------------------------
local UtilitiesTab = Tabs.Utilities:Tab({ Title = "Game Utilities", Icon = "tool" })
local UtilitiesMenu = UtilitiesTab:Section({ Title = "Select Utility", Icon = "grid" })

-- Server Hop
UtilitiesMenu:Button({
    Title = "Server Hop",
    Icon = "refresh-cw",
    Callback = function()
        UtilitiesMenu:Clear()
        local Section = UtilitiesTab:Section({ Title = "Server Hop", Icon = "refresh-cw" })

        Section:Button({
            Title = "Hop Now",
            Icon = "zap",
            Callback = function()
                WindUI:Notify({Title="Server Hop", Content="Feature coming soon!", Duration=2})
            end
        })

        Section:Button({
            Title = "Back",
            Icon = "arrow-left",
            Callback = function() reopenMenu(Section) end
        })
    end
})

-- Infinite Yield
UtilitiesMenu:Button({
    Title = "Infinite Yield",
    Icon = "command",
    Callback = function()
        UtilitiesMenu:Clear()
        local Section = UtilitiesTab:Section({ Title = "Infinite Yield", Icon = "command" })

        Section:Button({
            Title = "Execute",
            Icon = "play",
            Callback = function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source.lua"))()
                WindUI:Notify({Title="Infinite Yield", Content="Executed!", Duration=2})
            end
        })

        Section:Button({
            Title = "Back",
            Icon = "arrow-left",
            Callback = function() reopenMenu(Section) end
        })
    end
})

-------------------------
-- SETTINGS TAB
-------------------------
local SettingsTab = Tabs.Settings:Tab({ Title = "Appearance & Config", Icon = "settings" })
local SettingsMenu = SettingsTab:Section({ Title = "Settings Menu", Icon = "grid" })

-- Theme Dropdown
local themes = {}
for themeName, _ in pairs(WindUI:GetThemes()) do
    table.insert(themes, themeName)
end
table.sort(themes)

SettingsMenu:Dropdown({
    Title = "loc:THEME_SELECT",
    Values = themes,
    Value = WindUI:GetCurrentTheme(),
    Callback = function(theme)
        WindUI:SetTheme(theme)
        WindUI:Notify({Title="Theme Applied", Content=theme, Duration=2})
    end
})

-- Transparency Slider
SettingsMenu:Slider({
    Title = "loc:TRANSPARENCY",
    Value = { Min = 0, Max = 1, Default = 0.2 },
    Step = 0.1,
    Callback = function(value)
        WindUI.TransparencyValue = tonumber(value)
        Window:ToggleTransparency(tonumber(value) > 0)
    end
})

-------------------------
-- CREDITS TAB
-------------------------
local CreditsTab = Tabs.Credits:Tab({ Title = "Credits", Icon = "heart" })
local CreditsMenu = CreditsTab:Section({ Title = "Credits", Icon = "grid" })

CreditsMenu:Paragraph({
    Title = "MASTXR HUB v2",
    Desc = "Created with ❤️ by Sweb",
    Image = "github",
    ImageSize = 20,
    Color = "White",
    Buttons = {
        {
            Title = "Discord",
            Icon = "message-circle",
            Variant = "Primary",
            Callback = function()
                setclipboard("https://discord.gg/yourserver")
                WindUI:Notify({Title="Copied!", Content="Discord link copied", Duration=2})
            end
        },
        {
            Title = "GitHub",
            Icon = "github",
            Variant = "Primary",
            Callback = function()
                setclipboard("https://github.com/Sweb7xx")
                WindUI:Notify({Title="Copied!", Content="GitHub link copied", Duration=2})
            end
        }
    }
})

-- Footer
Window:Section({ Title = "MASTXR HUB v2 "..WindUI.Version })

-- Final notification
WindUI:Notify({
    Title = "MASTXR HUB v2",
    Content = "UI Loaded Successfully!",
    Duration = 3
})
