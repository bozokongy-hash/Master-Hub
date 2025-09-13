-- Load Coasting UI Library
local CoastingLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/GhostDuckyy/UI-Libraries/main/Coasting%20Ui%20Lib/source.lua"))()

-- Variables
local Player = game.Players.LocalPlayer
local Mouse = Player:GetMouse()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Auras = {}
local GUI = {}

-- Main GUI
GUI.Window = CoastingLibrary:CreateWindow("SwebHub SAB Edition", true) -- true = moveable

-- Tabs
local playerTab = GUI.Window:CreateTab("Player")
local espTab = GUI.Window:CreateTab("ESP")
local funTab = GUI.Window:CreateTab("Fun")
local configTab = GUI.Window:CreateTab("Config")
local creditsTab = GUI.Window:CreateTab("Credits")

-- =======================
-- Player Tab
-- =======================
local playerMain = playerTab:CreateSection("Main Features")

-- Speed Toggle
local speedEnabled = false
local speedValue = 50
playerMain:CreateToggle("Speed Boost", function(state)
    speedEnabled = state
end)
playerMain:CreateSlider("Speed Amount", 16, 200, 50, false, function(value)
    speedValue = value
end)

-- Jump Height
local jumpValue = 50
playerMain:CreateSlider("Jump Power", 50, 300, 50, false, function(value)
    jumpValue = value
    if Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") then
        Player.Character:FindFirstChildOfClass("Humanoid").JumpPower = jumpValue
    end
end)

-- Teleport to Player
playerMain:CreateDropdown("Teleport To", {}, 1, function(selected)
    local target = Players:FindFirstChild(selected)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and Player.Character:FindFirstChild("HumanoidRootPart") then
        Player.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0,5,0)
    end
end)

-- Auto Taunt
local autoTaunt = false
playerMain:CreateToggle("Auto Taunt", function(state)
    autoTaunt = state
end)

RunService.RenderStepped:Connect(function()
    if speedEnabled and Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") then
        Player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = speedValue
    end

    if autoTaunt then
        -- Example: make player play random animation / emote
        if Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") then
            local hum = Player.Character:FindFirstChildOfClass("Humanoid")
            hum:LoadAnimation(Instance.new("Animation")):Play()
        end
    end
end)

-- =======================
-- ESP Tab
-- =======================
local espMain = espTab:CreateSection("ESP Features")
local espEnabled = false
local espColor = Color3.fromRGB(255,0,0)

espMain:CreateToggle("Enable ESP", function(state)
    espEnabled = state
end)

espMain:CreateColorPicker("ESP Color", espColor, function(color)
    espColor = color
end)

RunService.RenderStepped:Connect(function()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= Player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
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
                    Auras[plr].Size = Vector2.new(30,30)
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

-- =======================
-- Fun Tab
-- =======================
local funMain = funTab:CreateSection("Chaos Features")
local stealBrainrot = false
funMain:CreateToggle("Steal Brainrot", function(state)
    stealBrainrot = state
end)

funMain:CreateButton("Trigger Fun Chaos", function()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= Player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            plr.Character.HumanoidRootPart.CFrame = Player.Character.HumanoidRootPart.CFrame + Vector3.new(math.random(-10,10),0,math.random(-10,10))
        end
    end
end)

-- =======================
-- Config Tab
-- =======================
local configMain = configTab:CreateSection("Settings")
configMain:CreateColorPicker("GUI Color", Color3.fromRGB(0, 255, 255), function(color)
    GUI.Window:SetColor(color)
end)

configMain:CreateKeybind("Toggle GUI", Enum.KeyCode.RightShift, true, true, function(active)
    GUI.Window:Toggle()
end)

configMain:CreateButton("Reset to Defaults", function()
    speedEnabled = false
    autoTaunt = false
    espEnabled = false
    stealBrainrot = false
    GUI.Window:SetColor(Color3.fromRGB(0,255,255))
end)

-- =======================
-- Credits Tab
-- =======================
local creditsMain = creditsTab:CreateSection("SwebHub Info")
creditsMain:CreateLabel("Credits", "Built & Coded by Sweb")
creditsMain:CreateLabel("Discord", "@4503")

-- =======================
-- Update Player Dropdown dynamically
-- =======================
local function updatePlayerDropdown()
    local names = {}
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= Player then
            table.insert(names, plr.Name)
        end
    end
    playerMain:UpdateDropdown("Teleport To", names)
end
Players.PlayerAdded:Connect(updatePlayerDropdown)
Players.PlayerRemoving:Connect(updatePlayerDropdown)
updatePlayerDropdown()

print("SwebHub SAB Edition loaded successfully!")
