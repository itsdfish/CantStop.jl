function roll(dice)
    return rand(1:dice.sides, dice.n)
end

# function move!(game::AbstractGame, col, player_id)
#     column = game.columns[col]
#     idx = get_location(column, :_runner)
#     idx = idx ≠ 0 ? get_location(column, player_id) : idx
#     if idx ≠ 0
#         filter!(x -> x ≠ :_runner, column[idx])
#         push!(column[idx+1], :_runner)
#         return nothing 
#     end
#     push!(column[1], :_runner)
#     return nothing 
# end

function move!(game::AbstractGame, col, row)
    column = game.columns[col]
    popat!(column, row)
    push!(column[idx+1], :_runner)
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

is_bust(outcome, columns; fun=any) = !is_combination(outcome, columns; fun)

function replace_runners!()

end

function no_winner(horse)
    return horse.steps ≠ horse.max_steps
end

function play_round!(game::AbstractGame, player::AbstractPlayer)
    runner_selection_phase!(game, player)
    decision_phase!(game, player)
    return nothing
end

function runner_selection_phase!(game::AbstractGame, player::AbstractPlayer)
    runners = Int[]
    columns = Int[]
    for i ∈ 1:2
        outcome = roll(game.dice)
        columns,rows = select_runners!(game, player, outcome, i)
        push!(game.runners, columns...)
        # update game board
    end
    return nothing
end

function decision_phase!(game::AbstractGame, player::AbstractPlayer)
    while is_playing(game, columns, runners) 
        outcome = roll(game.dice)
        columns = decide(game, player, outcome)
        # isempty(columns) ? break : nothing 
        # is_valid
    end
end

"""
    is_playing(outcome, columns) 

Tests whether the player can continue playing. Returns false if columns is empty or a bust occurs.

# Arguments

- `outcome`: a vector of dice outcomes 
- `columns`: a vector of sums based on pairs of dice outcomes 
"""
function is_playing(outcome, columns) 
    return !isempty(columns) && !is_bust(outcome, columns)
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