-- Touchscreen Spawner Control - by Jing Kang

local monitor = peripheral.find("monitor")
monitor.setTextScale(1)

-- Define spawners (side + display name)
local spawners = {
  {side = "left",   name = "Skeleton"},
  {side = "right",  name = "Zombie"},
  {side = "top",    name = "Creeper"},
  {side = "bottom", name = "Blaze"},
  {side = "front",  name = "Enderman"},
  {side = "back",   name = "Witch"}
}

-- Track ON/OFF states
local state = {}
for _, s in ipairs(spawners) do
  state[s.side] = false
end

-- Draw UI
local function drawUI()
  monitor.clear()
  for i, s in ipairs(spawners) do
    local y = i * 2
    monitor.setCursorPos(2, y)
    if state[s.side] then
      monitor.setTextColor(colors.lime)
      monitor.write("["..s.name..": ON ]")
    else
      monitor.setTextColor(colors.red)
      monitor.write("["..s.name..": OFF]")
    end
    monitor.setTextColor(colors.white)
  end
end

-- Toggle spawner
local function toggleSpawner(index)
  local s = spawners[index]
  state[s.side] = not state[s.side]
  redstone.setOutput(s.side, state[s.side])
  drawUI()
end

-- Map monitor click to spawner
local function getSpawnerAt(y)
  for i = 1, #spawners do
    if y == i * 2 then return i end
  end
  return nil
end

-- Main program loop
drawUI()
while true do
  local event, side, x, y = os.pullEvent("monitor_touch")
  local index = getSpawnerAt(y)
  if index then
    toggleSpawner(index)
  end
end
