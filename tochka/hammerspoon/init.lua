-- Jay's Config
local hotkey = require "hs.hotkey"
local window = require "hs.window"

require "grid"
require "spaces"

window.animationDuration = 0 -- Disable animations.

-- Shorthand for getting the focused window to make things more concise.
function focused()
    return window.focusedWindow()
end

-- Map Caps Lock to Control. Press Command with thumb and Control (Caps Lock) with pinky for maximum comfiness.
local mods = { "cmd", "ctrl" }

hotkey.bind(mods, "I", function() focused():snap("0,0", "2x2") end)
hotkey.bind(mods, "J", function() focused():snap("0,0", "1x2") end)
hotkey.bind(mods, "L", function() focused():snap("1,0", "1x2") end)
hotkey.bind(mods, "U", function() focused():snap("0,0", "1x1") end)
hotkey.bind(mods, "O", function() focused():snap("1,0", "1x1") end)
hotkey.bind(mods, "M", function() focused():snap("0,1", "1x1") end)
hotkey.bind(mods, ".", function() focused():snap("1,1", "1x1") end)

-- Use a loop to eliminate duplicate code.
for i = 1, 5 do
    hotkey.bind(mods, tostring(i), function() focused():moveToSpaceAtPosition(i) end)
end

hotkey.bind(mods, "H", function() focused():moveToPreviousScreen() end)
hotkey.bind(mods, ";", function() focused():moveToNextScreen() end)
