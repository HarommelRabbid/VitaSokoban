-- finding the player's start
player = { x = 1, y = 1, moves = 0 }
for y = 1, #level do
    for x = 1, #level[y] do
        if level[y][x] == P then
            player.x = x
            player.y = y
        end
    end
end

-- movement
local function is_target(x, y)
    return original_level[y] and original_level[y][x] == T
end

function player.move(dx, dy)
    local x, y = player.x, player.y
    local nx, ny = x + dx, y + dy
    local nnx, nny = x + dx * 2, y + dy * 2

    local function get(x, y)
        return level[y] and level[y][x]
    end

    local dest = get(nx, ny)
    local next2 = get(nnx, nny)

    -- Move to empty or target
    if dest == E or dest == T then
        level[y][x] = is_target(x, y) and T or E
        level[ny][nx] = P
        player.x, player.y = nx, ny
        player.moves = player.moves + 1
        state.save()
    -- Push box
    elseif dest == B or dest == X then
        if next2 == E or next2 == T then
            level[nny][nnx] = (next2 == T) and X or B
            level[y][x] = is_target(x, y) and T or E
            level[ny][nx] = P
            player.x, player.y = nx, ny
            player.moves = player.moves + 1
            state.save()
        end
    end
end
