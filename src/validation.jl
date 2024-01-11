"""
    validate_runner(game::AbstractGame, outcome, c_idx, r_idx, player_id)

Throws an error if the proposed position of a runner is invalid .

# Arguments

- `game::AbstractGame`: an abstract game object for Can't Stop
- `outcome`: a vector of dice outcomes 
- `c_idx`: column indices of active positions
- `r_idx`: row indices of active positions
- `player_id`: id of player
"""
function validate_runner(game::AbstractGame, outcome, c_idx, r_idx, player_id)
    (;board) = game
    if length(r_idx) ≠ length(c_idx)
        error("columns and rows do not have the same length")
    end
    if length(r_idx) > 2
        error("length of rows cannot exceed 2")
    end
    if !is_in_range(c_idx)
        error("$c_idx not in range")
    end
    if !sufficient_pieces(game, length(c_idx), player_id)
        error("Insufficent pieces remaining. Use active piece.")
    end
    if !is_combination(outcome, c_idx)
        error("$c_idx is not a valid pair for $outcome")
    end
    if has_been_won(board, c_idx)
        error("$c_idx has been won")
    end
    if !rows_are_valid(board, c_idx, r_idx, player_id)
        error("rows $r_idx are not valid")
    end
    if too_many_runners(game, c_idx, r_idx)
        error("Too many runners. You may only have 3 runners.")
    end
    return true
end

function sufficient_pieces(game::AbstractGame, n, player_id)
    return length(game.pieces[player_id]) ≥ n
end

function validate_move(game, outcome, c_idx, r_idx, player_id)
    (;board) = game
    if length(r_idx) ≠ length(c_idx)
        error("columns and rows do not have the same length")
    end
    if length(r_idx) > 2
        error("length of rows cannot exceed 2")
    end
    if !is_in_range(c_idx)
        error("$c_idx not in range")
    end
    if !is_combination(outcome, c_idx)
        error("$c_idx is not a valid pair for $outcome")
    end
    if has_been_won(board, c_idx)
        error("$c_idx has been won")
    end
    if !rows_are_valid(board, c_idx, r_idx, player_id)
        error("rows $r_idx are not valid")
    end
    return true
end

function has_been_won(board, c_idx)
    for c ∈ c_idx 
        column = board[c]
        isempty(column[end]) ? (continue) : (return true)
    end
    return false
end

function is_in_range(c_idx)
    valid_cols = 2:12
    for c ∈ c_idx 
        c ∈ valid_cols ? (continue) : (return false)
    end
    return true 
end

function rows_are_valid(board, c_idx, r_idx, player_id)
    n = length(c_idx)
    for i ∈ 1:n 
        if r_idx[i] == 1
            break 
        elseif r_idx[i] > length(board[c_idx[i]])
            return false 
        elseif player_id ∉ board[c_idx[i]][r_idx[i]-1] 
            return false
        end
    end
    return true 
end

function too_many_runners(game, c_idx, r_idx)
    n_new_runners = 0
    for i ∈ 1:length(c_idx)
        n_new_runners += r_idx[i] == 1
    end
    println("n_new_runners $(n_new_runners)")
    return game.runner_count + n_new_runners > 3 ? true : false
end