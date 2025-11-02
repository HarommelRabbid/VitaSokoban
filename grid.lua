grid = {}

local TILE = 40

function grid.draw(lvl)
    local rows = #lvl
    local cols = #lvl[1]

    -- Calculate total grid size
    local grid_width  = cols * TILE
    local grid_height = rows * TILE

    -- Centering offsets
    local offset_x = math.floor((960 - grid_width) / 2)
    local offset_y = math.floor((544 - grid_height) / 2)

    for y, row in ipairs(lvl) do
        for x, tile in ipairs(row) do
            local px = offset_x + (x - 1) * TILE
            local py = offset_y + (y - 1) * TILE
            if tile ~= E then draw.rect(px, py, TILE, TILE, tile) end
        end
    end
end

-- Deep copy for target memory
function grid.copy(src)
    local dst = {}
    for y = 1, #src do
        dst[y] = {}
        for x = 1, #src[y] do
            dst[y][x] = src[y][x]
        end
    end
    return dst
end

function grid.count(block)
    local count = 0
for y = 1, #level do
    for x = 1, #level[y] do
        if level[y][x] == block then
            count = count + 1
        end
    end
end
    return count
end
