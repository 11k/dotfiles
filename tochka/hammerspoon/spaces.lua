local spaces = require "hs._asm.undocumented.spaces"
local eventtap = require "hs.eventtap"

local windowMetatable = hs.getObjectMetatable("hs.window")
local screenMetatable = hs.getObjectMetatable("hs.screen")

-- Disable "Automatically rearrange Spaces based on most recent use"
-- in System Preferences/Mission Control.

-- Return the ID of a space in a certain position. The leftmost space
-- on a screen is at position 1.
screenMetatable.__index.spaceAtPosition = function(object, position)
    local layout = spaces.layout()

    for screenId, screenSpaces in pairs(layout) do
        if screenId == object:spacesUUID() then
            if position >= 1 and position <= #screenSpaces then
                return screenSpaces[position]
            end
        end
    end
end

-- Move a window to a space in a certain position (on its current screen).
-- moveWith specifies whether or not we want to switch to that space after the
-- window is moved.
windowMetatable.__index.moveToSpaceAtPosition = function(object, position, moveWith)
    local screen = object:screen()
    local space = screen:spaceAtPosition(position)

    -- Don't try moving a window if we're in the middle of transitioning between
    -- spaces.
    if space and not screen:spacesAnimating() then
        object:spacesMoveTo(space)
        -- Enable hotkeys for switching between Desktops in
        -- System Preferences/Shortcuts/Mission Control for this to work.
        -- Using the undocumented APIs to switch between spaces requires
        -- resetting the dock, which makes your background flash to black
        -- and is pretty outrageous in general.
        if moveWith == nil or moveWith then
            eventtap.keyStroke({ "ctrl" }, tostring(position))
        end
    end
end

-- Move a window to the next screen.
windowMetatable.__index.moveToNextScreen = function(object)
    local currentScreen = object:screen()
    object:moveToScreen(currentScreen:next())
end

-- Move a window to the previous screen.
windowMetatable.__index.moveToPreviousScreen = function(object)
    local currentScreen = object:screen()
    object:moveToScreen(currentScreen:previous())
end
