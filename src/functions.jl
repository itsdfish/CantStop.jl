function play_round!(game::AbstractGame, player::AbstractPlayer)
    runner_selection_phase!(game, player)
    decision_phase!(game, player)
    return nothing
end

"""
    runner_selection_phase!(game::AbstractGame, player::AbstractPlayer)

Implements the runner selection phase in which the player performs two dice rolls to select runners.
The function `select_runners!` is called during this phase.

# Arguments

- `game::AbstractGame`: an abstract game object 
- `player::AbstractPlayer`: an subtype of a abstract player
"""
function runner_selection_phase!(game::AbstractGame, player::AbstractPlayer)
    runners = Int[]
    columns = Int[]
    for i ∈ 1:2
        outcome = roll(game.dice)
        c_idx,rows = select_runners!(game, player, outcome, i)
        is_valid_runner(game, outcome, c_idx, rows)
        push!(game.runners, c_idx...)
        # update game board
    end
    return nothing
end

"""
    decision_phase!(game::AbstractGame, player::AbstractPlayer)

Implements the decision phase in which the player decides to roll the dice for the possibility of 
moving the runners. The two methods named `decide!` are called during this phase.

# Arguments

- `game::AbstractGame`: an abstract game object 
- `player::AbstractPlayer`: an subtype of a abstract player
"""
function decision_phase!(game::AbstractGame, player::AbstractPlayer)
    while true
        risk_it = take_chance(game, player)
        risk_it ? nothing : (set_pieces(game); break) 
        outcome = roll(game.dice)
        is_bust(game, outcome) ? (clear_runners!(game); break) : nothing
        c_idx, r_idx = select_columns(game, player, outcome)
        is_valid_move(game, outcome, c_idx, r_idx)
        # update board
    end
end

function take_chance(game::AbstractGame, player::AbstractPlayer)

end

roll(dice) = rand(1:dice.sides, dice.n)

"""
    move!(game::AbstractGame, col, row)

Move runner to location determined by column and row index

# Arguments

- `game::AbstractGame`: an abstract game object 
- `col`: column index 
- `row`: row index
"""
function move!(game::AbstractGame, col, row)
    column = game.columns[col]
    filter!(x -> x ≠ :_runner, column[row-1])
    push!(column[row], :_runner)
    return nothing 
end

function get_location(column, player_id)
    for c ∈ 1:length(column) 
        player_id ∈ column[c] ? (return c) : nothing 
    end
    return 0 
end

"""
    is_combination(outcome, columns)

Tests whether columns are a possible some of dice outcome.

# Arguments

- `outcome`: a vector of dice outcomes 
- `columns`: a vector of sums based on pairs of dice outcomes 

# Keywords

- `fun=all`: a function for testing the combinations 
"""
function is_combination(outcome, columns; fun=all)
    combs = sum.(combinations(outcome, 2))
    return fun(x -> x ∈ combs, columns)
end

is_bust(outcome, c_idx; fun=any) = !is_combination(outcome, c_idx; fun)

function is_valid_runner(game, outcome, c_idx, rows, player_id)
    if isempty(c_idx)
        error("columns cannot be empty")
    end 
    if isempty(rows)
        error("rows cannot be empty")
    end 
    if length(rows) ≠ length(c_idx)
        error("columns and rows do not have the same length")
    end
    if length(rows) > 2
        error("length of rows cannot exceed 2")
    end
    if !is_in_range(game, c_idx)
        error("$c_idx not in range")
    end
    if !is_combination(outcome, c_idx)
        error("$c_idx is not a valid pair for $outcome")
    end
    if has_been_won(game, c_idx)
        error("$c_idx has been won")
    end
    if !rows_are_valid(game, c_idx, rows, player_id)
        error("rows $rows are not valid")
    end
    return true
end

function is_valid_move(game, outcome, c_idx, r_idx, player_id)
    if length(r_idx) ≠ 2 || length(c_idx) ≠ 2
        error("length of row and column indices must be 2")
    end
    if !is_in_range(game, c_idx)
        error("$c_idx not in range")
    end
    if !is_combination(outcome, c_idx)
        error("$c_idx is not a valid pair for $outcome")
    end
    if has_been_won(game, c_idx)
        error("$c_idx has been won")
    end
    if !rows_are_valid(game, c_idx, r_idx, player_id)
        error("rows $r_idx are not valid")
    end
    return true
end

function has_been_won(game, c_idx)
    for c ∈ c_idx 
        column = game.columns[c]
        isempty(column[end]) ? (continue) : (return true)
    end
    return false
end

function is_in_range(game, c_idx)
    valid_cols = 2:12
    for c ∈ c_idx 
        c ∈ valid_cols ? (continue) : (return false)
    end
    return true 
end

function rows_are_valid(game, c_idx, rows, player_id)
    n = length(c_idx)
    for i ∈ 1:n 
        if rows[i] == 1
            break 
        elseif rows[i] > length(game.columns[c_idx[i]])
            return false 
        elseif player_id ∉ game.columns[c_idx[i]][rows[i]-1] 
            return false
        end
    end
    return true 
end

"""
    is_playing(c_idx) 

Tests whether the player can continue playing. Returns false if columns is empty.

# Arguments

- `c_idx`: a vector of sums based on pairs of dice outcomes 
"""
function is_playing(c_idx) 
    return !isempty(c_idx)
end

function replace_runners!()

end

function no_winner(horse)
    return horse.steps ≠ horse.max_steps
end

"""
    setup!(player::AbstractPlayer, ids)

Perform initial setup after cards are delt, but before the game begins.

# Arguments

- `player`: a player object
- `ids`: all player ids
"""
function setup!(player::AbstractPlayer, ids)
    # intentionally blank
end