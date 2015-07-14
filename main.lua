local http = require("socket.http")
local console = require('console')
local sound = require('sound')

local networking = true
local quit = false
local hosts = {
  current = 0,
  list = { 'enno.kn-bremen.de', '10.0.0.11' }
}
local img
local bubble, popped
local tilew, tileh
local sheetw, sheeth
local is_popped = {}
local gdeaths = 0
local deaths = 0
local url_post, url_get

local function next_host()
  if hosts.current == #hosts.list then
    return false
  else
    hosts.current = hosts.current + 1
    local host = hosts.list[hosts.current]
    console.log("trying host " .. host)
    url_post = 'http://' .. host .. '/counters/death.php'
    url_get = 'http://' .. host .. '/counters/deathcount.php'
  end
  return true
end

local function refresh_count(url)
  if not networking then return end
  local str = http.request(url)
  local g = tonumber(str)
  if g~=nil then
    gdeaths = g
    deaths = 0
  else
    -- console.log(str)
    networking = next_host()
  end
end

local function count_pop()
    deaths = deaths + 1
    refresh_count(url_post)
end

local function bubble_get(x, y)
    if is_popped[x+y*sheetw] then
        return false
    else
        return true
    end
end

local function bubble_pop(x, y)
  if not is_popped[x+y*sheetw] then
    love.audio.play("res/pop.wav", "stream")
    is_popped[x+y*sheetw] = true
    count_pop()
  end
end

function love.load()
    love.window.setTitle("Bubbles (c) Enno Rehling 2015")
    console.log("Bubbles (c) Enno Rehling 2015")
    local w, h, f = love.window.getDimensions()
    local scale = love.window.getPixelScale()
    console.visible = false
    console.log("Bubbles version 0.2")
    console.log("scale: " .. scale)
    if scale and scale>1.0 then
      img = love.graphics.newImage("res/bubblesl.png")
    else
      img = love.graphics.newImage("res/bubbless.png")
    end
    tilew, tileh = img:getDimensions()
    tilew = tilew/2
    tileh = tileh
    sheetw = 1+ w / tilew
    sheeth = 1+ h / tileh
    bubble = love.graphics.newQuad(0, 0, tilew, tileh, img:getDimensions())
    popped = love.graphics.newQuad(tilew, 0, tilew, tileh, img:getDimensions())
    next_host()
    refresh_count(url_get)
end

local draw = love.draw
function love.draw()
    love.graphics.setColor(255, 255, 255, 255)
    local i, j
    for i = 1,sheetw do for j = 1,sheeth do
        local quad
        local x, y
        x = (i-1)*tilew
        y = (j-1)*tileh
        if bubble_get(i, j) then
            quad = bubble
        else
            quad = popped
        end
        if j % 2 == 1 then
            x = x - tilew/2
        end
        love.graphics.draw(img, quad, x, y)
    end end
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.print("bubbles popped: " .. (gdeaths + deaths), 10, 20)
    -- console.draw()
end

local refresh_time = 5.0
local refresh_interval = 1.0

function love.update(dt)
    refresh_time = refresh_time + dt
    if refresh_time > refresh_interval then
      refresh_time = 0
      refresh_count(url_get)
    end
    if quit then
        love.event.quit()
    end
end

local function pop(x, y)
  local i, j
  j = math.floor(y/tileh)+1
  if math.mod(j, 2)==1 then
      x = x + tilew/2
  end
  i = math.floor(x/tilew)+1
  bubble_pop(i, j)
end

local popping = false

function love.mousemoved(x, y, dx, dy)
  if (popping) then
    pop(x, y)
  end
end

function love.mousereleased(x, y, b)
  popping = false
end

function love.mousepressed(x, y, b)
  popping = true
  pop(x, y)
end

function love.keypressed(key)
    if key == "escape" or key=='q' then
        quit = true
    elseif key == "tab" then
        console.visible = not console.visible
    end
end
