local http = require("socket.http")
local console = require('console')
local sound = require('sound')

local networking = true
local quit = false
local url = 'http://enno.kn-bremen.de/counters/death.php'
local img
local bubble, popped
local tilew, tileh
local sheetw, sheeth
local is_popped = {}
local gdeaths = 0
local deaths = 0

local function count_pop()
    deaths = deaths + 1
    if networking then
        local str = http.request(url)
        local g = tonumber(str)
        if g~=nil then
            gdeaths = g
            deaths = 0
        else
            console.log(str)
            networking = false
        end
    end
    console.log("bubbles popped: " .. (gdeaths + deaths))
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
    end
    count_pop()
end

function love.load()
    love.window.setTitle("Bubbles (c) Enno Rehling 2015")
    console.log("Bubbles (c) Enno Rehling 2015")
    img = love.graphics.newImage("res/bubbless.png")
    tilew, tileh = img:getDimensions()
    tilew = tilew/2
    tileh = tileh
    sheetw, sheeth = love.window.getDimensions()
    sheetw = 1+ sheetw / tilew
    sheeth = 1+ sheeth / tileh
    bubble = love.graphics.newQuad(0, 0, tilew, tileh, img:getDimensions())
    popped = love.graphics.newQuad(tilew, 0, tilew, tileh, img:getDimensions())
end

function love.draw()
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
    console.draw()
end

function love.update()
    if quit then
        love.event.quit()
    end
end

function love.mousereleased(x, y, b)
    local i, j
    j = math.floor(y/tileh)+1
    if math.mod(j, 2)==1 then
        x = x + tilew/2
    end
    i = math.floor(x/tilew)+1
    bubble_pop(i, j)
end

function love.keypressed(key)
    if key == "escape" then
        quit = true
    elseif key == "tab" then
        console.visible = not console.visible
    end
end
