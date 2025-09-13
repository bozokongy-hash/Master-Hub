-- Load Coasting UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/GhostDuckyy/UI-Libraries/main/Coasting%20Ui%20Lib/source.lua"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Auras = {}

-- =======================
-- Variables
-- =======================
local speedEnabled = false
local speedValue = 50
local jumpValue = 50
local espEnabled = false
local espColor = Color3.fromRGB(255, 0, 0)
local autoTaunt = false
local stealBrainrot = false

-- =======================
-- Create Tabs
-- =======================
local playerTab = Library:CreateTab("Player")
local espTab = Library:CreateTab("ESP")
local funTab = Library:CreateTab("Fun")
local configTab = Library:CreateTab("Config")
local creditsTab = Library:CreateTab("Credits")

-- =======================
-- Player Tab
-- =======================
local playerSection = playerTab:CreateSection("Player Features")

playerSection:CreateToggle("Speed Boost", function(state)
    speedEnabled = state
end)

playerSection:CreateSlider("Speed Amount", 16, 200, 50, false, function(value)
    speedValue = value
end)

playerSection:CreateSlider("Jump Power", 50, 300, 50, false, function(value)
    jumpValue = value
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = jumpValue
    end
end)

-- Teleport to Player Dropdown
local function getPlayerNames()
    local names = {}
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            table.insert(names, plr.Name)
        end
    end
    return names
end

local teleportDropdown = playerSection:CreateDropdown("Teleport To", getPlayerNames(), 1, function(selected)
    local target = Players:FindFirstChild(selected)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
    end
end)

Players.PlayerAdded:Connect(function()
    teleportDropdown:Update(getPlayerNames())
end)
Players.PlayerRemoving:Connect(function()
    teleportDropdown:Update(getPlayerNames())
end)

playerSection:CreateToggle("Auto Taunt", function(state)
    autoTaunt = state
end)

-- =======================
-- ESP Tab
-- =======================
local espSection = espTab:CreateSection("ESP Features")

espSection:CreateToggle("Enable ESP", function(state)
    espEnabled = state
end)

espSection:CreateColorPicker("ESP Color", espColor, function(color)
    espColor = color
end)

-- =======================
-- Fun Tab
-- =======================
local funSection = funTab:CreateSection("Chaos Features")

funSection:CreateToggle("Steal Brainrot", function(state)
    stealBrainrot = state
end)

funSection:CreateButton("Trigger Fun Chaos", function()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            plr.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(math.random(-10,10),0,math.random(-10,10))
        end
    end
end)

-- =======================
-- Config Tab
-- =======================
local configSection = configTab:CreateSection("Settings")

configSection:CreateKeybind("Toggle GUI", Enum.KeyCode.RightShift, true, true, function(active)
    Library:Toggle()
end)

configSection:CreateButton("Reset to Defaults", function()
    speedEnabled = false
    autoTaunt = false
    espEnabled = false
    stealBrainrot = false
end)

-- =======================
-- Credits Tab
-- =======================
local creditsSection = creditsTab:CreateSection("Credits")
creditsSection:CreateLabel("Credits", "Built & Coded by Sweb")
creditsSection:CreateLabel("Discord", "@4503")

-- =======================
-- Runtime Updates
-- =======================
RunService.RenderStepped:Connect(function()
    -- Speed
    if speedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = speedValue
    end

    -- Auto Taunt (example placeholder)
    if autoTaunt then
        -- Add your taunt logic here
    end

    -- ESP
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local root = plr.Character.HumanoidRootPart
            if espEnabled then
                if not Auras[plr] then
                    local box = Drawing.new("Square")
                    box.Visible = true
                    box.Color = espColor
                    box.Thickness = 2
                    box.Filled = false
                    Auras[plr] = box
                end
                local screenPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(root.Position)
                if onScreen then
                    Auras[plr].Position = Vector2.new(screenPos.X - 15, screenPos.Y - 15)
                    Auras[plr].Size = Vector2.new(30, 30)
                    Auras[plr].Visible = true
                else
                    Auras[plr].Visible = false
                end
            else
                if Auras[plr] then
                    Auras[plr]:Remove()
                    Auras[plr] = nil
                end
            end
        end
    end
end)

print("SwebHub SAB Edition loaded correctly!")
