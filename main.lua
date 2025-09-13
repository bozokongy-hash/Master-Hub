-- MASTXR HUB - Stealm Brainrot GUI
local GUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/BloodLetters/Ash-Libs/refs/heads/main/source.lua"))()

GUI:CreateMain({
    Name = "MASTXR HUB",
    title = "MASTXR HUB",
    ToggleUI = "K",
    WindowIcon = "home",
    Theme = {
        Background = Color3.fromRGB(30, 0, 0),       -- dark red background
        Secondary = Color3.fromRGB(50, 0, 0),
        Accent = Color3.fromRGB(255, 0, 0),          -- bright red accent
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(200, 100, 100),
        Border = Color3.fromRGB(100, 0, 0),
        NavBackground = Color3.fromRGB(20, 0, 0)
    },
    Blur = { Enable = false, value = 0.2 },
    Config = { Enabled = false }
})

-- Main Tab
local main = GUI:CreateTab("Brainrot Features", "home")

GUI:CreateSection({ parent = main, text = "Core Functions" })

GUI:CreateButton({
    parent = main,
    text = "Steal a Soul",
    callback = function()
        GUI:CreateNotify({title = "Brainrot Activated", description = "You just activated the brainrot mode!"})
    end
})

GUI:CreateButton({
    parent = main,
    text = "Trigger Chaos",
    callback = function()
        GUI:CreateNotify({
            title = "Chaos Mode",
            description = "Welcome to MASTXR HUB. Red madness flowing through your veins."
        })
    end
})

GUI:CreateToggle({
    parent = main,
    text = "Enable Madness",
    default = false,
    callback = function(state)
        print("Madness state:", state)
    end
})

GUI:CreateSlider({
    parent = main,
    text = "Insanity Level",
    min = 0,
    max = 100,
    default = 50,
    function(value)
        print("Insanity Level:", value)
    end
})

GUI:CreateDropdown({
    parent = main,
    text = "Select Ritual",
    options = {"Option 1", "Option 2", "Option 3"},
    callback = function(selected)
        print("Ritual selected:", selected)
    end
})

GUI:CreateKeyBind({
    parent = main,
    text = "Activate Ritual",
    default = "K",
    callback = function(key, input, isPressed)
        if isPressed then
            print("Ritual key pressed:", key)
        else
            print("Ritual key released:", key)
        end
    end
})

GUI:CreateInput({
    parent = main,
    text = "Enter Curse",
    placeholder = "Type here...",
    callback = function(text)
        print("Curse entered:", text)
    end
})

GUI:CreateParagraph({
    parent = main,
    text = "MASTXR HUB is powered by Stealm. Red chaos flows through the interface. Use wisely."
})

GUI:CreateColorPicker({
    parent = main,
    text = "Pick Blood Color",
    default = Color3.fromRGB(255, 0, 0),
    callback = function(color)
        print("Selected blood color:", color)
    end
})

-- Settings Tab
local settings = GUI:CreateTab("MASTXR Settings", "settings")

GUI:CreateSection({ parent = settings, text = "Reset & Chaos Options" })

GUI:CreateButton({
    parent = settings,
    text = "Reset Brain",
    callback = function()
        GUI:CreateNotify({ title = "Brain Reset", description = "All settings reverted to default madness." })
    end
})

GUI:CreateDivider({ parent = settings })

GUI:CreateButton({
    parent = settings,
    text = "Reset All Rituals",
    callback = function()
        GUI:CreateNotify({ title = "Ritual Reset", description = "All rituals have been cleared." })
    end
})
