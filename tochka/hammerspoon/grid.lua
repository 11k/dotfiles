local screen = require "hs.screen"
local geometry = require "hs.geometry"

local windowMetatable = hs.getObjectMetatable("hs.window")

-- Grid.
local Grid = {}

-- Caches a grid for each screen so they don't have to be
-- recreated every time a window is snapped.
Grid.cachedGrids = {}

-- Space around windows.
gapSize = 8

function Grid:forScreen(screen)
    -- Check to see if a cached grid exists, first.
    local grid = self.cachedGrids[screen:id()]

    if grid then
        return grid
    end

    grid = { screen = screen }
    self.__index = self
    -- Cache the newly-created grid. We use the screen's ID as a key
    -- because it's a unique value.
    self.cachedGrids[screen:id()] = grid

    return setmetatable(grid, self)
end

-- Return a window frame for a particular grid-based origin and size.
--
-- 0,0 ------- 1,0 ---------+
--  |           |           |
--  |           |           |
-- 0,1 ------- 1,1 ---------+
--  |           |           |
--  |           |           |
--  +-----------------------+
function Grid:frameForPosition(origin, size)
    local frame = {}

    if origin == "0,0" then
        frame.x = self.screen:frame().x + gapSize
        frame.y = self.screen:frame().y + gapSize
    elseif origin == "1,0" then
        frame.x = self.screen:frame().x + self.screen:frame().w / 2 + gapSize * 0.5
        frame.y = self.screen:frame().y + gapSize
    elseif origin == "0,1" then
        frame.x = self.screen:frame().x + gapSize
        frame.y = self.screen:frame().y + self.screen:frame().h / 2 + gapSize * 0.5
    elseif origin == "1,1" then
        frame.x = self.screen:frame().x + self.screen:frame().w / 2 + gapSize * 0.5
        frame.y = self.screen:frame().y + self.screen:frame().h / 2 + gapSize * 0.5
    end

    if size == "1x1" then
        frame.w = self.screen:frame().w / 2 - gapSize * 1.5
        frame.h = self.screen:frame().h / 2 - gapSize * 1.5
    elseif size == "1x2" then -- One unit wide and two units tall.
        frame.w = self.screen:frame().w / 2 - gapSize * 1.5
        frame.h = self.screen:frame().h - gapSize * 2
    elseif size == "2x2" then
        frame.w = self.screen:frame().w - gapSize * 2
        frame.h = self.screen:frame().h - gapSize * 2
    end

    return hs.geometry(frame)
end

-- Snap a window to an origin and resize it.
windowMetatable.__index.snap = function(object, origin, size)
    local grid = Grid:forScreen(object:screen())
    object:setFrame(grid:frameForPosition(origin, size))
end
