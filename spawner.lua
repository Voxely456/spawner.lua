-- 5x2 Touchscreen Mob Control --

local monitor = peripheral.wrap("top") -- adjust side if different
monitor.setTextScale(1)

-- Define spawners + light
local controls = {
    {name="Blaze", side="left"},
    {name="Wither", side="right"},
    {name="Creeper", side="top"},
    {name="Iron Golem", side="bottom"},
    {name="Witch", side="front"},
    {name="Piglin", side="back"},
    {name="Others 1", side="bundled1"},
    {name="Others 2", side="bundled2"},
    {name="Others 3", side="bundled3"},
    {name="Others 4", side="bundled4"},
    {name="Others 5", side="bundled5"},
    {name="Light", side="light"}
}

-- Track ON/OFF state
local state = {}
for _, c in ipairs(controls) do
    state[c.side] = false
end

-- Draw UI
local function drawUI()
    monitor.clear()
    local x, y = 1, 1
    for i, c in ipairs(controls) do
        monitor.setCursorPos(x, y)
        if state[c.side] then
            monitor.setTextColor(colors.lime)
            monitor.write("["..c.name..": ON ]")
        else
            monitor.setTextColor(colors.red)
            monitor.write("["..c.name..":OFF]")
        end
        monitor.setTextColor(colors.white)
        x = x + 12 -- adjust spacing
        if x > 60 then -- move to next row if exceeds width
            x = 1
            y = y + 2
        end
    end
end

-- Map click to control
local function getControlAt(x, y)
    -- Each button width assumed 12 chars, height 2
    local col = math.ceil(x/12)
    local row = math.ceil(y/2)
    local index = (row-1)*5 + col
    if index >=1 and index <= #controls then
        return index
    end
    return nil
end

-- Toggle control
local function toggleControl(index)
    local c = controls[index]
    state[c.side] = not state[c.side]
    if c.side ~= "bundled1" and c.side ~= "bundled2" and c.side ~= "bundled3" and c.side ~= "bundled4" and c.side ~= "bundled5" and c.side ~= "light" then
        redstone.setOutput(c.side, state[c.side])
    else
        -- For bundled cables or light switch, you would handle with appropriate method
        -- Example: redstone.setBundledOutput or similar if using bundled cables
    end
    drawUI()
end

-- Main loop
drawUI()
while true do
    local event, side, x, y = os.pullEvent("monitor_touch")
    local index = getControlAt(x, y)
    if index then
        toggleControl(index)
    end
end

