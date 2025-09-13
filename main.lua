--==================================================
-- MASTXR HUB MEGA v2.0 - Ultimate All-in-One GUI
-- Author: Sweb7xx
--==================================================

-- Load Ash-Libs
local GUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/BloodLetters/Ash-Libs/refs/heads/main/source.lua"))()
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local camera = workspace.CurrentCamera

--===========================
-- Feature States
--===========================
local sprintEnabled, sprintSpeed = false, 50
local flyEnabled, flySpeed, flyBV = false, 50, nil
local flyControls = {W=false,S=false,A=false,D=false,Space=false,Shift=false}
local infiniteJumpEnabled = false
local noclipConnection
local espEnabled, aimbotEnabled = false, false
local espSettings = {Boxes=true, Names=true, Skeletons=false, Distance=true}
local aimbotSettings = {FOV=100, Target=nil, Silent=false}

--===========================
-- Helper: Notifications
--===========================
local function notify(title, description)
    GUI:CreateNotify({title=title, description=description, Time=2})
end

--===========================
-- GUI MAIN
--===========================
GUI:CreateMain({
    Name = "MASTXR HUB",
    title = "MASTXR HUB",
    ToggleUI = "K",
    WindowIcon = "home",
    Theme = {
        Background = Color3.fromRGB(30,0,0),
        Secondary = Color3.fromRGB(50,0,0),
        Accent = Color3.fromRGB(255,0,0),
        Text = Color3.fromRGB(255,255,255),
        TextSecondary = Color3.fromRGB(200,100,100),
        Border = Color3.fromRGB(100,0,0),
        NavBackground = Color3.fromRGB(20,0,0)
    },
    Blur = {Enable=false,value=0.2},
    Config = {Enabled=false}
})

--===========================
-- PLAYER ENHANCEMENTS TAB
--===========================
local playerTab = GUI:CreateTab("Player Enhancements","home")
GUI:CreateSection({parent=playerTab,text="Movement & Navigation"})

-- Sprint
GUI:CreateToggle({parent=playerTab,text="Enable Sprint",default=false,callback=function(state)
    sprintEnabled = state
    humanoid.WalkSpeed = state and sprintSpeed or 16
    notify("Sprint", state and "Enabled" or "Disabled")
end})
GUI:CreateSlider({parent=playerTab,text="Sprint Speed",min=16,max=300,default=50,function(value)
    sprintSpeed = value
    if sprintEnabled then humanoid.WalkSpeed = sprintSpeed end
end})

-- Infinite Jump
UIS.JumpRequest:Connect(function()
    if infiniteJumpEnabled then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
end)
GUI:CreateToggle({parent=playerTab,text="Enable Infinite Jump",default=false,callback=function(state)
    infiniteJumpEnabled = state
    notify("Infinite Jump", state and "Enabled" or "Disabled")
end})

-- Fly / Noclip
local function updateFly()
    if flyEnabled then
        local camCF = camera.CFrame
        local dir = Vector3.new(0,0,0)
        if flyControls.W then dir += camCF.LookVector end
        if flyControls.S then dir -= camCF.LookVector end
        if flyControls.A then dir -= camCF.RightVector end
        if flyControls.D then dir += camCF.RightVector end
        if flyControls.Space then dir += Vector3.new(0,1,0) end
        if flyControls.Shift then dir -= Vector3.new(0,1,0) end
        flyBV.Velocity = (dir.Magnitude>0 and dir.Unit*flySpeed or Vector3.new(0,0,0))
    end
end

GUI:CreateToggle({parent=playerTab,text="Enable Fly / Noclip",default=false,callback=function(state)
    flyEnabled = state
    if state then
        noclipConnection = RunService.Stepped:Connect(function()
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end)
        flyBV = Instance.new("BodyVelocity")
        flyBV.MaxForce = Vector3.new(1e5,1e5,1e5)
        flyBV.Velocity = Vector3.new(0,0,0)
        flyBV.Parent = hrp
        notify("Fly", "Enabled")
    else
        if noclipConnection then noclipConnection:Disconnect() end
        if flyBV then flyBV:Destroy() end
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = true end
        end
        notify("Fly", "Disabled")
    end
end})

GUI:CreateSlider({parent=playerTab,text="Fly Speed",min=10,max=300,default=50,function(value) flySpeed=value end})

-- Fly Controls
UIS.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.Keyboard then
        if input.KeyCode==Enum.KeyCode.W then flyControls.W=true end
        if input.KeyCode==Enum.KeyCode.S then flyControls.S=true end
        if input.KeyCode==Enum.KeyCode.A then flyControls.A=true end
        if input.KeyCode==Enum.KeyCode.D then flyControls.D=true end
        if input.KeyCode==Enum.KeyCode.Space then flyControls.Space=true end
        if input.KeyCode==Enum.KeyCode.LeftShift then flyControls.Shift=true end
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.Keyboard then
        if input.KeyCode==Enum.KeyCode.W then flyControls.W=false end
        if input.KeyCode==Enum.KeyCode.S then flyControls.S=false end
        if input.KeyCode==Enum.KeyCode.A then flyControls.A=false end
        if input.KeyCode==Enum.KeyCode.D then flyControls.D=false end
        if input.KeyCode==Enum.KeyCode.Space then flyControls.Space=false end
        if input.KeyCode==Enum.KeyCode.LeftShift then flyControls.Shift=false end
    end
end)
RunService.RenderStepped:Connect(function() if flyEnabled then updateFly() end end)

-- Teleport
GUI:CreateButton({parent=playerTab,text="Teleport to Spawn",callback=function()
    hrp.CFrame = CFrame.new(0,5,0)
    notify("Teleport","Teleported to Spawn")
end})
GUI:CreateButton({parent=playerTab,text="Teleport to Player",callback=function()
    local targetName = player:PromptInput("Enter Player Name:")
    local targetPlayer = game.Players:FindFirstChild(targetName)
    if targetPlayer and targetPlayer.Character then
        hrp.CFrame = targetPlayer.Character:WaitForChild("HumanoidRootPart").CFrame
        notify("Teleport","Teleported to "..targetName)
    else notify("Teleport","Player not found") end
end})

--===========================
-- SETTINGS TAB
--===========================
local settingsTab = GUI:CreateTab("Settings","settings")
GUI:CreateSection({parent=settingsTab,text="Reset Enhancements"})
GUI:CreateButton({parent=settingsTab,text="Reset Sprint",callback=function()
    sprintEnabled=false humanoid.WalkSpeed=16 notify("Sprint","Reset")
end})
GUI:CreateButton({parent=settingsTab,text="Reset Infinite Jump",callback=function()
    infiniteJumpEnabled=false notify("Infinite Jump","Reset")
end})
GUI:CreateButton({parent=settingsTab,text="Reset Fly/Noclip",callback=function()
    flyEnabled=false if noclipConnection then noclipConnection:Disconnect() end
    if flyBV then flyBV:Destroy() end
    for _, part in pairs(char:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide=true end end
    notify("Fly","Reset")
end})

--===========================
-- THEMES TAB
--===========================
local themesTab = GUI:CreateTab("Themes","settings")
GUI:CreateSection({parent=themesTab,text="Custom Theme"})
GUI:CreateColorPicker({parent=themesTab,text="Background Color",default=Color3.fromRGB(30,0,0),callback=function(color) GUI.Theme.Background=color notify("Theme","Background Updated") end})
GUI:CreateColorPicker({parent=themesTab,text="Accent Color",default=Color3.fromRGB(255,0,0),callback=function(color) GUI.Theme.Accent=color notify("Theme","Accent Updated") end})
GUI:CreateColorPicker({parent=themesTab,text="Text Color",default=Color3.fromRGB(255,255,255),callback=function(color) GUI.Theme.Text=color notify("Theme","Text Updated") end})

--===========================
-- CREDITS TAB
--===========================
local creditsTab = GUI:CreateTab("Credits","home")
GUI:CreateSection({parent=creditsTab,text="Author Info"})
GUI:CreateParagraph({parent=creditsTab,text="MASTXR HUB GUI"})
GUI:CreateParagraph({parent=creditsTab,text="Built and maintained by Sweb7xx"})
GUI:CreateParagraph({parent=creditsTab,text="Discord: @4503"})
GUI:CreateParagraph({parent=creditsTab,text="Version: Mega v2.0"})

--===========================
-- EXTRA: FPS Optimized Loop for ESP / Aimbot (Placeholder)
--===========================
RunService.RenderStepped:Connect(function()
    if espEnabled then
        -- Add your ESP rendering logic here
    end
    if aimbotEnabled then
        -- Add your Aimbot logic here
    end
end)

notify("MASTXR HUB","Loaded Successfully")
