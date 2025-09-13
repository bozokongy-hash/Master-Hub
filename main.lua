-- MASTXR HUB - Player Enhancements GUI
local GUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/BloodLetters/Ash-Libs/refs/heads/main/source.lua"))()

-- Create Main GUI
GUI:CreateMain({
    Name = "MASTXR HUB",
    title = "MASTXR HUB",
    WindowIcon = "home",
    Theme = {
        Background = Color3.fromRGB(30, 0, 0),
        Secondary = Color3.fromRGB(50, 0, 0),
        Accent = Color3.fromRGB(255, 0, 0),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(200, 100, 100),
        Border = Color3.fromRGB(100, 0, 0),
        NavBackground = Color3.fromRGB(20, 0, 0)
    },
    Blur = { Enable = false, value = 0.2 },
    Config = { Enabled = false }
})

-- Hide default close/minimize buttons
if GUI.HideWindowButtons then
    GUI:HideWindowButtons(true)
end

-- Bind Right Shift to toggle GUI
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightShift then
        GUI:ToggleUI()
    end
end)

-- PLAYER TAB - Movement & Enhancements
local playerTab = GUI:CreateTab("Player Enhancements", "player")
GUI:CreateSection({ parent = playerTab, text = "Movement & Power Ups" })

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Sprint / Speed
local sprintEnabled = false
local walkSpeed = 16
GUI:CreateSlider({
    parent = playerTab,
    text = "Walk Speed",
    min = 16,
    max = 100,
    default = 16,
    callback = function(value)
        walkSpeed = value
        if sprintEnabled then humanoid.WalkSpeed = value end
    end
})

GUI:CreateToggle({
    parent = playerTab,
    text = "Enable Sprint",
    default = false,
    callback = function(state)
        sprintEnabled = state
        humanoid.WalkSpeed = state and walkSpeed or 16
    end
})

-- Jump Boost / Infinite Jump
local infiniteJump = false
GUI:CreateToggle({
    parent = playerTab,
    text = "Infinite Jump",
    default = false,
    callback = function(state)
        infiniteJump = state
    end
})

UserInputService.JumpRequest:Connect(function()
    if infiniteJump then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Fly / Noclip
local flyEnabled = false
local flying = false
local bodyVelocity, bodyGyro

GUI:CreateToggle({
    parent = playerTab,
    text = "Fly / Noclip",
    default = false,
    callback = function(state)
        flyEnabled = state
        local root = character:WaitForChild("HumanoidRootPart")
        if state then
            bodyVelocity = Instance.new("BodyVelocity")
            bodyGyro = Instance.new("BodyGyro")
            bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            bodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
            bodyVelocity.Velocity = Vector3.new(0,0,0)
            bodyGyro.CFrame = root.CFrame
            bodyVelocity.Parent = root
            bodyGyro.Parent = root
            flying = true
            coroutine.wrap(function()
                while flying do
                    bodyVelocity.Velocity = workspace.CurrentCamera.CFrame.LookVector * 50
                    bodyGyro.CFrame = workspace.CurrentCamera.CFrame
                    wait()
                end
            end)()
        else
            flying = false
            if bodyVelocity then bodyVelocity:Destroy() end
            if bodyGyro then bodyGyro:Destroy() end
        end
    end
})

-- Teleports
GUI:CreateButton({
    parent = playerTab,
    text = "Teleport to Spawn",
    callback = function()
        local root = character:WaitForChild("HumanoidRootPart")
        root.CFrame = CFrame.new(Vector3.new(0,10,0))
    end
})

GUI:CreateButton({
    parent = playerTab,
    text = "Teleport to Loot",
    callback = function()
        local loot = workspace:FindFirstChild("Loot")
        if loot then
            character.HumanoidRootPart.CFrame = loot.CFrame + Vector3.new(0,5,0)
        else
            GUI:CreateNotify({title="Teleport Error", description="No loot found!"})
        end
    end
})

-- SETTINGS TAB
local settings = GUI:CreateTab("Settings", "settings")
GUI:CreateSection({ parent = settings, text = "Reset Enhancements" })

GUI:CreateButton({
    parent = settings,
    text = "Reset All Enhancements",
    callback = function()
        sprintEnabled = false
        humanoid.WalkSpeed = 16
        infiniteJump = false
        flying = false
        if bodyVelocity then bodyVelocity:Destroy() end
        if bodyGyro then bodyGyro:Destroy() end
        flyEnabled = false
        GUI:CreateNotify({title="Reset Complete", description="All player enhancements reverted."})
    end
})
