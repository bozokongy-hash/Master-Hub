-- MASTXR HUB v2 - Ultimate All-in-One GUI
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

-- Player Tab Features
local PlayerTab = Tabs.Player:Tab({ Title = "Player Features", Icon = "user" })
local PlayerSection = PlayerTab:Section({ Title = "Player Mods", Icon = "activity" })

PlayerSection:Toggle({
    Title = "Enable Speed Hack",
    Value = false,
    Callback = function(state)
        if state then
            humanoid.WalkSpeed = 100
        else
            humanoid.WalkSpeed = 16
        end
        WindUI:Notify({Title="Speed Hack", Content=state and "Enabled" or "Disabled", Duration=2})
    end
})

PlayerSection:Slider({
    Title = "Jump Power",
    Value = { Min = 50, Max = 500, Default = 50 },
    Callback = function(value)
        humanoid.JumpPower = value
        WindUI:Notify({Title="Jump Power", Content="Set to "..value, Duration=2})
    end
})

PlayerSection:Toggle({
    Title = "Infinite Jump",
    Value = false,
    Callback = function(state)
        if state then
            _G.InfJump = true
            game:GetService("UserInputService").JumpRequest:Connect(function()
                if _G.InfJump then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        else
            _G.InfJump = false
        end
        WindUI:Notify({Title="Infinite Jump", Content=state and "Enabled" or "Disabled", Duration=2})
    end
})

PlayerSection:Toggle({
    Title = "Noclip",
    Value = false,
    Callback = function(state)
        if state then
            _G.Noclip = true
            game:GetService("RunService").Stepped:Connect(function()
                if _G.Noclip then
                    for _, part in pairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            _G.Noclip = false
        end
        WindUI:Notify({Title="Noclip", Content=state and "Enabled" or "Disabled", Duration=2})
    end
})

-- Utilities Tab
local UtilitiesTab = Tabs.Utilities:Tab({ Title = "Game Utilities", Icon = "tool" })
local UtilsSection = UtilitiesTab:Section({ Title = "Utilities", Icon = "tool" })

UtilsSection:Button({
    Title = "Server Hop",
    Icon = "refresh-cw",
    Callback = function()
        WindUI:Notify({Title="Server Hop", Content="Feature coming soon!", Duration=2})
    end
})

UtilsSection:Button({
    Title = "Infinite Yield",
    Icon = "command",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source.lua"))()
        WindUI:Notify({Title="Infinite Yield", Content="Executed!", Duration=2})
    end
})

-- Settings Tab
local SettingsTab = Tabs.Settings:Tab({ Title = "Appearance & Config", Icon = "settings" })

-- Theme Dropdown
local themes = {}
for themeName, _ in pairs(WindUI:GetThemes()) do
    table.insert(themes, themeName)
end
table.sort(themes)

SettingsTab:Dropdown({
    Title = "loc:THEME_SELECT",
    Values = themes,
    Value = WindUI:GetCurrentTheme(),
    Callback = function(theme)
        WindUI:SetTheme(theme)
        WindUI:Notify({Title="Theme Applied", Content=theme, Duration=2})
    end
})

-- Transparency Slider
SettingsTab:Slider({
    Title = "loc:TRANSPARENCY",
    Value = { Min = 0, Max = 1, Default = 0.2 },
    Step = 0.1,
    Callback = function(value)
        WindUI.TransparencyValue = tonumber(value)
        Window:ToggleTransparency(tonumber(value) > 0)
    end
})

-- Credits Tab
local CreditsTab = Tabs.Credits:Tab({ Title = "Credits", Icon = "heart" })

CreditsTab:Paragraph({
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

-- Example notification to confirm UI is ready
WindUI:Notify({
    Title = "MASTXR HUB v2",
    Content = "UI Loaded Successfully!",
    Duration = 3
})
