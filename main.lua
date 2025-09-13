-- MASTXR HUB - Player Enhancements GUI
local GUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/BloodLetters/Ash-Libs/refs/heads/main/source.lua"))()

GUI:CreateMain({
    Name = "MASTXR HUB",
    title = "MASTXR HUB",
    ToggleUI = "K",
    WindowIcon = "home",
    Theme = {
        Background = Color3.fromRGB(30, 0, 0), -- dark red
        Secondary = Color3.fromRGB(50, 0, 0),
        Accent = Color3.fromRGB(255, 0, 0), -- bright red accent
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(200, 100, 100),
        Border = Color3.fromRGB(100, 0, 0),
        NavBackground = Color3.fromRGB(20, 0, 0)
    },
    Blur = { Enable = false, value = 0.2 },
    Config = { Enabled = false }
})

-- Main Tab
local main = GUI:CreateTab("Player Enhancements", "home")
GUI:CreateSection({ parent = main, text = "Movement & Navigation" })

-- Speed / Sprint Toggle
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")

GUI:CreateToggle({
    parent = main,
    text = "Enable Sprint",
    default = false,
    callback = function(state)
        if state then
            humanoid.WalkSpeed = 50 -- sprint speed
        else
            humanoid.WalkSpeed = 16 -- default Roblox speed
        end
    end
})

-- Fly / Noclip
local flying = false
local noclipConnection

GUI:CreateToggle({
    parent = main,
    text = "Enable Fly / Noclip",
    default = false,
    callback = function(state)
        flying = state
        if flying then
            -- Noclip
            noclipConnection = game:GetService("RunService").Stepped:Connect(function()
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end)
            -- Simple Fly Implementation
            local UIS = game:GetService("UserInputService")
            local speed = 50
            local bodyVelocity = Instance.new("BodyVelocity", char.HumanoidRootPart)
            bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            bodyVelocity.Velocity = Vector3.new(0,0,0)

            UIS.InputBegan:Connect(function(input)
                if flying then
                    if input.KeyCode == Enum.KeyCode.W then bodyVelocity.Velocity = char.HumanoidRootPart.CFrame.LookVector * speed end
                    if input.KeyCode == Enum.KeyCode.S then bodyVelocity.Velocity = -char.HumanoidRootPart.CFrame.LookVector * speed end
                    if input.KeyCode == Enum.KeyCode.Space then bodyVelocity.Velocity = Vector3.new(0,speed,0) end
                end
            end)
        else
            if noclipConnection then noclipConnection:Disconnect() end
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
})

-- Teleport (example teleport positions)
GUI:CreateButton({
    parent = main,
    text = "Teleport to Spawn",
    callback = function()
        char:SetPrimaryPartCFrame(CFrame.new(Vector3.new(0,5,0))) -- Change coordinates as needed
    end
})

-- Jump Boost / Infinite Jump
local infiniteJumpEnabled = false
game:GetService("UserInputService").JumpRequest:Connect(function()
    if infiniteJumpEnabled then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

GUI:CreateToggle({
    parent = main,
    text = "Enable Infinite Jump",
    default = false,
    callback = function(state)
        infiniteJumpEnabled = state
    end
})

-- Settings Tab
local settings = GUI:CreateTab("MASTXR Settings", "settings")
GUI:CreateSection({ parent = settings, text = "Reset Options" })
GUI:CreateButton({
    parent = settings,
    text = "Reset Player Speed",
    callback = function()
        humanoid.WalkSpeed = 16
    end
})
GUI:CreateButton({
    parent = settings,
    text = "Reset Infinite Jump",
    callback = function()
        infiniteJumpEnabled = false
    end
})
GUI:CreateButton({
    parent = settings,
    text = "Reset Fly/Noclip",
    callback = function()
        flying = false
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
})
