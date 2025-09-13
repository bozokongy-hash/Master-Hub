-- Load the Library
local GUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/BloodLetters/Ash-Libs/refs/heads/main/source.lua"))()

-- Create Main Window
GUI:CreateMain({
    Name = "MASTXR",
    title = "MASTXR GUI",
    ToggleUI = "K",
    WindowIcon = "https://i.imgur.com/OuS6Kwc.png", -- Your MASTXR logo
    alwaysIconOnly = false,
    Theme = {
        Background = Color3.fromRGB(15, 15, 25),
        Secondary = Color3.fromRGB(25, 25, 35),
        Accent = Color3.fromRGB(200, 40, 80),
        AccentSecondary = Color3.fromRGB(160, 30, 60),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(180, 180, 180),
        Border = Color3.fromRGB(45, 45, 55),
        NavBackground = Color3.fromRGB(20, 20, 30),
        Surface = Color3.fromRGB(30, 30, 40),
        SurfaceVariant = Color3.fromRGB(35, 35, 45),
        Success = Color3.fromRGB(40, 201, 64),
        Warning = Color3.fromRGB(255, 189, 46),
        Error = Color3.fromRGB(255, 95, 87),
        Shadow = Color3.fromRGB(0, 0, 0)
    },
    Blur = {
        Enable = false,
        value = 0.2
    },
    Config = {
        Enabled = true,
        FileName = "MASTXR",
        FolerName = "MASTXRDir"
    }
})

-- MAIN TAB
local main = GUI:CreateTab("Main", "home")

GUI:CreateSection({ parent = main, text = "Section" })

GUI:CreateButton({
    parent = main,
    text = "Click Me",
    flag = "ClickMeBtn",
    callback = function()
        GUI:CreateNotify({
            title = "Button Clicked",
            description = "You clicked the button!"
        })
    end
})

GUI:CreateButton({
    parent = main,
    text = "Notify",
    flag = "NotifyBtn",
    callback = function()
        GUI:CreateNotify({
            title = "Welcome",
            description = "Welcome to the MASTXR GUI! This is a notification example. You can use this to inform users about important events or actions."
        })
    end
})

GUI:CreateToggle({
    parent = main,
    text = "Toggle Me",
    default = false,
    flag = "ToggleMe",
    callback = function(state)
        print("Toggle state:", state)
    end
})

GUI:CreateSlider({
    parent = main,
    text = "Slider",
    min = 0,
    max = 100,
    default = 50,
    flag = "SliderValue",
    callback = function(value)
        print("Slider value changed:", value)
    end
})

GUI:CreateDropdown({
    parent = main,
    text = "Select Option",
    options = {"Option 1", "Option 2", "Option 3"},
    default = "Option 1",
    flag = "DropdownOption",
    callback = function(selected)
        print("Selected option:", selected)
    end
})

GUI:CreateKeyBind({
    parent = main,
    text = "Press a Key",
    default = "K",
    flag = "KeyBind",
    callback = function(key, input, isPressed)
        if isPressed then
            print("Key pressed:", key)
        else
            print("Key released:", key)
        end
    end
})

GUI:CreateInput({
    parent = main,
    text = "Enter Text",
    placeholder = "Placeholder",
    flag = "InputText",
    callback = function(text)
        print("Input text:", text)
    end
})

GUI:CreateParagraph({
    parent = main,
    title = "Title",
    text = "This is a paragraph explaining something important. It can be multiple lines long and will adjust its size based on the content."
})

GUI:CreateColorPicker({
    parent = main,
    text = "Pick a Color",
    default = Color3.fromRGB(255, 0, 0),
    flag = "ColorPicker",
    callback = function(color)
        print("Selected color:", color)
    end
})

-- SETTINGS TAB
local settings = GUI:CreateTab("Settings", "settings")

GUI:CreateSection({
    parent = settings,
    text = "Settings Section"
})

GUI:CreateButton({
    parent = settings,
    text = "Reset Settings",
    flag = "ResetSettingsBtn",
    callback = function()
        GUI:CreateNotify({
            title = "Settings Reset",
            description = "All settings have been reset to default."
        })
    end
})

GUI:CreateDivider({ parent = settings })

GUI:CreateButton({
    parent = settings,
    text = "Reset 2",
    flag = "ResetSettingsBtn2",
    callback = function()
        GUI:CreateNotify({
            title = "Settings Reset",
            description = "All settings have been reset to default."
        })
    end
})

-- MOVEMENT TAB
local move = GUI:CreateTab("Movement", "zap")

GUI:CreateSection({
    parent = move,
    text = "Movement Options"
})

GUI:CreateButton({
    parent = move,
    text = "Enable Fly",
    flag = "FlyBtn",
    callback = function()
        GUI:CreateNotify({title = "Fly", description = "Fly Enabled (example)"})
    end
})

GUI:CreateButton({
    parent = move,
    text = "Enable Noclip",
    flag = "NoclipBtn",
    callback = function()
        GUI:CreateNotify({title = "Noclip", description = "Noclip Enabled (example)"})
    end
})
