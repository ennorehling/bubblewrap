local console = { transparent = true, lines = {}, visible = false, fps = true }

function console.log(msg)
    table.insert(console.lines, msg)
end

function console.draw()
    maxlines = 40
    if console.fps then
        love.graphics.print(("FPS: %d"):format(love.timer.getFPS()), 4, 10)
    end
    if not console.visible then
        return
    end
    local num = #console.lines
    local first = num - maxlines
    if first < 1 then first = 1 end
    print(first, num)
    for k, msg in ipairs(console.lines) do
        -- TODO: inefficient loop
        if k>first then
            love.graphics.print(msg, 4, 30+10*(k-first))
        end
    end
end

return console
