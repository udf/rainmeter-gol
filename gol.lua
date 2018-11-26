
function Initialize()
    dofile(SKIN:GetVariable('CURRENTPATH') .. 'ShapeImage.lua')

    config = {}
    config.internal_width = 50
    config.internal_height = 50
    config.skin_width = 500
    config.skin_height = 500

    -- Initialize board with a random state
    board1 = {}
    board2 = {}
    for y = 0, config.internal_height - 1 do
        board1[y] = {}
        board2[y] = {}
        for x = 0, config.internal_width - 1 do
            board1[y][x] = (math.random() > 0.5) and 0 or 1
            board2[y][x] = 0
        end
    end

    image = ShapeImage('MeterShape', config.internal_height, config.skin_width, config.skin_height)
    running = true
    drawBoard()
end

function onClick(mx, my)
    local x = math.floor((mx / config.skin_width) * config.internal_width)
    local y = math.floor((my / config.skin_height) * config.internal_height)
    board1[y][x] = (board1[y][x] == 0) and 1 or 0
end

function clear()
    for y = 0, config.internal_height - 1 do
        for x = 0, config.internal_width - 1 do
            board1[y][x] = 0
        end
    end
end

function getCell(y, x)
    return board1[y % config.internal_height][x % config.internal_width]
end

function countNeighbours(y, x)
    return (
        getCell(y - 1, x - 1) +
        getCell(y - 1, x + 0) +
        getCell(y - 1, x + 1) +
        getCell(y + 0, x - 1) +
        getCell(y + 0, x + 1) +
        getCell(y + 1, x - 1) +
        getCell(y + 1, x + 0) +
        getCell(y + 1, x + 1)
    )
end

function Update()
    if running then
        for y = 0, config.internal_height - 1 do
            for x = 0, config.internal_width - 1 do
                local alive = countNeighbours(y, x)
                local cell = board1[y][x]
                if cell == 1 and (alive < 2 or alive > 3) then
                    cell = 0
                elseif cell == 0 and alive == 3 then
                    cell = 1
                end
                board2[y][x] = cell
            end
        end
        board1, board2 = board2, board1
    end

    drawBoard()
end


function drawBoard()
    local black = "0, 0, 0, 255"
    local white = "255, 255, 255, 255"
    for y = 0, #board1 do
        local row = {}
        for x = 0, #board1[y] do
            row[x] = (board1[y][x] == 0) and white or black
        end
        image:drawRow(y, row)
    end
end
