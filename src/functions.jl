"""
    simulate(game::AbstractGame, players)

Simulate CantStop until a player has won. 

# Arguments

- `game::AbstractGame`: an abstract game object 
- `players`: a vector of players where elements are a subtype of a abstract player
"""
function simulate(game::AbstractGame, players)
    initialize_pieces!(game, players)
    shuffle!(players)
    n = length(players)
    idx = 1
    while !is_over(game)
        play_round!(game, players[idx])
        idx = next(idx, n)
    end
end

"""
    play_round!(game::AbstractGame, player::AbstractPlayer)

Play one round with a specified player.

# Arguments

- `game::AbstractGame`: an abstract game object 
- `player::AbstractPlayer`: an subtype of a abstract player
"""
function play_round!(game::AbstractGame, player::AbstractPlayer)
    runner_selection_phase!(game, player)
    decision_phase!(game, player)
    cleanup!(game)
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
    id = player.id
    for i ∈ 1:2
        outcome = roll(game.dice)
        c_idx,r_idx = select_runners(game, player, outcome, i)
        is_valid_runner(game, outcome, c_idx, r_idx, id)
        cache_positions!(game, c_idx, r_idx)
        add_runners!(game, c_idx, r_idx)
        add_pieces_to_reserve!(game, id, c_idx, r_idx)
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
        risk_it ? nothing : (set_pieces!(game, player.id); break) 
        outcome = roll(game.dice)
        is_bust(game, outcome) ? (handle_bust!(game, player.id); break) : nothing
        c_idx, r_idx = select_positions(game, player, outcome)
        is_valid_move(game, outcome, c_idx, r_idx)
        move!(game, c_idx, r_idx)
    end
    return nothing
end

roll(dice) = rand(1:dice.sides, dice.n)

"""
    move!(game::AbstractGame, c_idx, r_idx)

Move runner to location determined by column and row index

# Arguments

- `game::AbstractGame`: an abstract game object 
- `c_idx`: column index 
- `r_idx`: row index
"""
function move!(game::AbstractGame, c_idx, r_idx)
    column = game.columns[c_idx]
    filter!(x -> x ≠ :_runner, column[r_idx-1])
    push!(column[r_idx], :_runner)
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
- `c_idx`: a vector of sums based on pairs of dice outcomes 

# Keywords

- `fun=all`: a function for testing the combinations 
"""
function is_combination(outcome, c_idx; fun=all)
    combs = sum.(combinations(outcome, 2))
    return fun(x -> x ∈ combs, c_idx)
end

function is_bust(game::AbstractGame, outcome; fun=any)
    c_idx = get_runner_locations(game)
    return is_bust(outcome, c_idx; fun)
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
    if !sufficient_pieces(game, length(c_idx), player_id)
        error("Insufficent pieces remaining. Use active piece.")
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

function sufficient_pieces(game::AbstractGame, n, player_id)
    return length(game.pieces[player_id]) ≥ n
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

function set_pieces!(game::AbstractGame, player_id)
    remove_pieces!(game, player_id)
    replace_runners!(game, player_id)
    return nothing
end

"""
    remove_pieces!(game::AbstractGame, player_id)

# Arguments

- `game::AbstractGame`: an abstract game object 
- `player::AbstractPlayer`: an subtype of a abstract player
"""
function remove_pieces!(game::AbstractGame, player_id)
    (;r_idx,c_idx,columns) = game 
    for (c,r) ∈ zip(c_idx, r_idx)
        row = columns[c][r]
        idx = findfirst(x -> x == player_id, row)
        isnothing(idx) ? nothing : deleteat!(row, idx)
    end
    return nothing
end

"""
    replace_runners!(game::AbstractGame, player_id)

Replaces runners with player_id.

# Arguments

- `game::AbstractGame`: an abstract game object 
- `player::AbstractPlayer`: an subtype of a abstract player
"""
function replace_runners!(game::AbstractGame, player_id)
    for c ∈ values(game.columns)
        for r ∈ c 
            replace!(r, :_runner => player_id)
        end
    end
end

function is_over(game)
    ids = Symbol[]
    for c ∈ values(game.columns)
        push!(ids, unique(c[end])...)
    end
    counts = map(x -> count(y -> x == y, ids), unique(ids))
    return any(x -> x ≥ 3, counts)
end

"""
    clear_runners!(game)

Clear runners from board following a bust. 

# Arguments

- `game::AbstractGame`: an abstract game object 
"""
function clear_runners!(game) 
    for c ∈ values(game.columns)
        for r ∈ c 
            filter!(x -> x ≠ :_runner, r)
        end
    end
    return nothing
end

function return_to_reserve!(game, player_id)
    for p ∈ 1:length(game.piece_reserve)
        piece = pop!(game.piece_reserve)
        push!(game.pieces[player_id], piece) 
    end
    return nothing
end

function handle_bust!(game, player_id)
    clear_runners!(game)
    return_to_reserve!(game, player_id)
    return nothing
end

function cleanup!(game)
    empty!(game.r_idx)
    empty!(game.c_idx)
    empty!(game.piece_reserve)
    return nothing
end

next(idx, n) = idx == n ? 1 : idx += 1

function cache_positions!(game::AbstractGame, c_idx, r_idx)
    push!(game.c_idx, c_idx...)
    push!(game.r_idx, r_idx...)
    return nothing 
end

function add_runners!(game::AbstractGame, c_idx, r_idx)
    for i ∈ 1:length(r_idx)
        push!(game.columns[c_idx[i]][r_idx[i]], :_runner)
    end
    return nothing
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

"""
    list_sums(game::AbstractGame, outcome)

Lists all unique sum of combinations of the outcome of rolling dice

# Arguments

- `game::AbstractGame`: an abstract game object 
- `outcome`: the results of rolling the dice
"""
list_sums(game, outcome) = unique(sum.(combinations(outcome, 2)))

function initialize_pieces!(game::AbstractGame, players)
    map(p -> initialize_pieces!(game, p), players)
    return nothing
end

function initialize_pieces!(game::AbstractGame, p::AbstractPlayer)
    game.pieces[p.id] = fill(p.id, 12)
    return nothing
end

function add_pieces_to_reserve!(game, player_id, c_idx, r_idx)
    for i ∈ 1:length(c_idx)
        if r_idx[i] == 1
            piece = pop!(game.pieces[player_id])
            push!(game.piece_reserve, piece)
        end
    end
    return nothing
end

"""
    get_runner_locations(game)

Returns runner locations. 

# Arguments

- `game::AbstractGame`: an abstract game object 

# Returns 

- `c_idx`: column indices
- `r_idx`: row indices
"""
function get_runner_locations(game)
    c_idx = Int[]
    r_idx = Int[]
    columns = game.columns
    for c ∈ keys(columns)
        for r ∈ 1:length(columns[c])
            if :_runner ∈ columns[c][r]
                push!(c_idx, c)
                push!(r_idx, r)
                length(c_idx) == 3 ? (return c_idx, r_idx) : nothing
            end
        end
    end
    return c_idx, r_idx
end