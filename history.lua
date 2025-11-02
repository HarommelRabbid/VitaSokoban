-- History of level states
history, state = {}, {index = 0}

function state.save()
    -- Store a deep copy of the level and player
    state.index = state.index + 1
    history[state.index] = {
        level = grid.copy(level),
        player = { x = player.x, y = player.y, moves = player.moves }
    }
    -- Discard any "future" if rewound
    for i = state.index + 1, #history do
        history[i] = nil
    end
end

function state.restore(index)
    if history[index] then
        level = grid.copy(history[index].level)
        player.x = history[index].player.x
        player.y = history[index].player.y
        player.moves = history[index].player.moves
        state.index = index
    end
end

-- Initial save
state.save()
