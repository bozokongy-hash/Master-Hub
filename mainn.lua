-- Load the Coasting UI Library
local CoastingLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/GhostDuckyy/UI-Libraries/main/Coasting%20Ui%20Lib/source.lua"))()

-- Create the Aimbot tab
local aimbotTab = CoastingLibrary:CreateTab("Aimbot")

-- Create sections within the tab
local mainSection = aimbotTab:CreateSection("Main")
local configSection = aimbotTab:CreateSection("Config")

-- Main Section Elements

-- Button that prints "Boo!"
mainSection:CreateButton("Click Me!", function()
    print("Boo!")
end)

-- Label displaying "Hello!"
mainSection:CreateLabel("Namey", "Hello!")

-- Toggle for enabling/disabling Aimbot
mainSection:CreateToggle("Aimbot", function(isEnabled)
    print("Aimbot:", isEnabled)
    -- Add your logic here to enable/disable Aimbot
end)

-- Slider for adjusting Field Of View
mainSection:CreateSlider("Field Of View", 0, 150, 50, false, function(value)
    print("Field Of View:", value)
    -- Use the value as needed, e.g., update a camera or Aimbot FOV
end)

-- Config Section Elements

-- Color Picker for Field of View Color
configSection:CreateColorPicker("Field of View Color", Color3.fromRGB(255, 255, 255), function(color)
    print("Field of View Color:", color)
    -- Apply color to UI or other element
end)

-- Dropdown for selecting Type
configSection:CreateDropdown("Type", {"Mouse", "Character"}, 1, function(selectedOption)
    print("Type:", selectedOption)
    -- Handle the option selection
end)

-- Keybind for toggling Aimbot
configSection:CreateKeybind("Aimbot Bind", Enum.KeyCode.Unknown, false, true, function(isActive)
    print("Aimbot Active:", isActive)
    -- Bind/unbind Aimbot with key
end)
