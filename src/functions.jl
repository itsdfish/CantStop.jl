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
    while is_playing(game)
        play_round!(game, players[idx])
        idx = next(idx, n)
    end
end

"""
    play_round!(game::AbstractGame, player::AbstractPlayer)

Play one round with a specified player. A round has two phases:

- a runner selection phase 
- a decision phase

# Arguments

- `game::AbstractGame`: an abstract game object 
- `player::AbstractPlayer`: an subtype of a abstract player
"""
function play_round!(game::AbstractGame, player::AbstractPlayer)
    decision_phase!(game, player)
    cleanup!(game, player)
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
        # roll the dice 
        outcome = roll(game.dice)
        # list_options
        options = list_options(game, player, outcome)
        is_bust(options) ? (handle_bust!(game, player); break) : nothing
        choice = select_positions(deepcopy(game), player, options)
        validate_choice(options, choice) ? nothing : break 
        set_status!(game, player.id, c_idx, r_idx)
        move!(game, player.id, c_idx, r_idx)
        risk_it = take_chance(deepcopy(game), player)
        risk_it ? nothing : (handle_stop!(game, player); break) 
    end
    return nothing
end

roll(dice) = rand(1:dice.sides, dice.n)

"""
    move!(game::AbstractGame, c_idx, r_idx)

Move runner to location determined by column and row index

# Arguments

- `game::AbstractGame`: an abstract game object 
- `c_idx`: column index of position 
- `r_idx`: row index of position 
"""
function move!(game::AbstractGame, id, c_idx, r_idx)
    for i ∈ 1:length(c_idx)
        game.pieces[id][c_idx[i]].row += 1
    end
    return nothing 
end

function set_status!(game::AbstractGame, id, c_idx, r_idx)
    for i ∈ 1:length(c_idx)
        piece = game.pieces[id][c_idx[i]]
        if !piece.is_runner 
            piece.is_runner = true 
            piece.start_row = piece.row 
        end
    end
    return nothing 
end

validate_choice(options, choice) = choice ∈ options

"""
    is_combination(outcome, c_idx)

Tests whether columns are a possible some of dice outcome.

# Arguments

- `outcome`: a vector of dice outcomes 
- `c_idx`: a vector of sums based on pairs of dice outcomes 

# Keywords

- `fun=all`: a function for testing the combinations 
"""
function is_combination(outcome, c_idx; fun=all)
    combs = list_sums(outcome) 
    n = length(c_idx)
    checks = fill(false, n)
    for c ∈ 1:n
        println("c_idx[c] $(c_idx[c]) in $combs")
        if c_idx[c] ∈ combs 
            idx = findfirst(x -> x == c_idx[c], combs)
            deleteat!(combs, idx)
            checks[c] = true
        end
    end
    return fun(checks)
end

"""
    is_bust(options)

Checks whether a dice roll is a bust i.e., does not allow a valid move. 

# Arguments

- `game::AbstractGame`: an abstract game object for Can't Stop
- `options`: a vector of column indices corresponding to possible choices
"""
is_bust(game::AbstractGame, options) = isempty(options)

function is_playing(game::AbstractGame)
    counts = [count(y -> id == y, values(game.players_won)) for id ∈ keys(game.pieces)]
    return all(x -> x < 3, counts)
end

function handle_bust!(game::AbstractGame, player::AbstractPlayer)
    postbust_cleanup!(deepcopy(game), player)
    return_to_start_position!(game, player)
    set_runners_false!(game, player)
    return nothing
end

function handle_stop!(game::AbstractGame, player::AbstractPlayer)
    poststop_cleanup!(deepcopy(game), player)
    set_runners_false!(game, player)
    return nothing 
end

next(idx, n) = idx == n ? 1 : idx += 1

function initialize_pieces!(game::AbstractGame, p::AbstractPlayer)
    max_rows = [3,5,7,9,11,13,11,9,7,5,3]
    return Dict(i => Piece(;id=p.id, max_row=max_rows[i-1]) for i ∈ 2:11)
end

function initialize_pieces!(game::AbstractGame, players)
    game.pieces = Dict(p.id => initialize_pieces!(game, p) for p ∈ players)
    return nothing
end

function set_runners_false!(game::AbstractGame, player)
    for p ∈ game.pieces[player.id]
        if p.is_runner 
            p.is_runner = false 
        end
    end
    return nothing
end

function return_to_start_position!(game, player)
    for p ∈ game.pieces[player.id]
        if p.is_runner 
            p.row = p.start_row
        end
    end
    return nothing
end

"""
    list_sums(outcome)

Lists all unique sum of combinations of the outcome of rolling dice

# Arguments

- `outcome`: the results of rolling the dice
"""
function list_sums(outcome)
    output = Vector{Vector{Int}}()
    for p ∈ permutations(outcome)
        s = [p[1] + p[2], p[3] + p[4]]
        if s ∉ output && reverse!(s) ∉ output 
            push!(output, reverse!(s))
        end
    end
    return output 
end

function list_options(game, outcome)
    (;runner_cols,columns_won) = game 
    all_options = list_sums(outcome)
    n_runners = length(runner_cols)
    to_keep = fill(true, length(all_options))
    split_options = Vector{Vector{Int}}()
    for (i,option) ∈ enumerate(all_options)
        filter!(x -> x ∉ columns_won, option)
        if n_runners == 3
            filter!(x -> x ∈ runner_cols, option)
        elseif n_runners == 0
            continue
        elseif n_runners < 3
            to_keep[i] = all(x -> x == option[1], option) ||
                 any(x -> x ∈ runner_cols, option)
            if !to_keep[i]
                push!(split_options, [[v] for v ∈ option]...)
            end
        end
    end
    all_options = all_options[to_keep]
    push!(all_options, split_options...)
    unique!(all_options)
    filter!(x -> !isempty(x), all_options)
    return all_options
end