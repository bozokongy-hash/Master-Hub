-- Player Tab
local PlayerTab = Tabs.Player:Tab({ Title = "Player", Icon = "user" })
local PlayerMenu = PlayerTab:Section({ Title = "Select Feature", Icon = "grid" })

-- Helper function to go back to menu
local function BackToMenu(section)
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
            Callback = function() BackToMenu(AimbotSection) end
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
            end
        })

        ESPSection:Button({
            Title = "Back",
            Icon = "arrow-left",
            Callback = function() BackToMenu(ESPSection) end
        })
    end
})

-- Misc
PlayerMenu:Button({
    Title = "Misc",
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
            Callback = function() BackToMenu(MiscSection) end
        })
    end
})
