"""
    simulate!(game::AbstractGame, players; is_safe=true)

Simulate CantStop until a player has won. 

# Arguments

- `game::AbstractGame`: an abstract game object for Can't Stop
- `player::AbstractPlayer`: an subtype of a abstract player

# Keywords

- `is_safe=true`: whether players safely read `game` object without modification. Set to `false` if 
    any player modifies `game` object, or might cheat. 
"""
function simulate!(game::AbstractGame, players; is_safe = true)
    initialize_pieces!(game, players)
    shuffle!(players)
    n = length(players)
    idx = 1
    while is_playing(game)
        play_round!(game, players[idx]; is_safe)
        idx = next(idx, n)
    end
end

"""
    play_round!(game::AbstractGame, player::AbstractPlayer; is_safe=true)

Play one round with a specified player. During each iteration of a round, the player makes two decision_phase

1. decide whether to roll the dice
2. decide which pairs to sum to move runners

# Arguments

- `game::AbstractGame`: an abstract game object for Can't Stop
- `player::AbstractPlayer`: an subtype of a abstract player

# Keywords

- `is_safe=true`: whether players safely read `game` object without modification. Set to `false` if 
    any player modifies `game` object, or might cheat. 
"""
function play_round!(game::AbstractGame, player::AbstractPlayer; is_safe = true)
    decision_phase!(game, player; is_safe)
    cleanup!(game, player)
    return nothing
end

"""
    decision_phase!(game::AbstractGame, player::AbstractPlayer; is_safe=true)

Implements the decision phase in which the player decides to roll the dice for the possibility of 
moving the runners. The two methods named `decide!` are called during this phase.

# Arguments

- `game::AbstractGame`: an abstract game object for Can't Stop
- `player::AbstractPlayer`: an subtype of a abstract player

# Keywords

- `is_safe=true`: whether players safely read `game` object without modification. Set to `false` if 
    any player modifies `game` object, or might cheat. 
"""
function decision_phase!(game::AbstractGame, player::AbstractPlayer; is_safe = true)
    while true
        # roll the dice 
        outcome = roll(game.dice)
        # list_options
        options = list_options(game, outcome)
        is_bust(game, options) ? (handle_bust!(game, player; is_safe); break) : nothing
        _game = is_safe ? game : deepcopy(game)
        choice = select_runners(_game, player, deepcopy(options))
        validate_choice(options, choice) ? nothing : break
        set_status!(game, player.id, choice)
        move!(game, player.id, choice)
        _game = is_safe ? game : deepcopy(game)
        risk_it = roll_again(_game, player)
        risk_it ? nothing : (handle_stop!(game, player; is_safe); break)
    end
    return nothing
end

roll(dice) = rand(1:dice.sides, dice.n)

"""
    move!(game::AbstractGame, id, c_idx)

Move runner to location determined by column and row index

# Arguments

- `game::AbstractGame`: an abstract game object
- `id`: the id of the player 
- `c_idx`: column index of position 
"""
function move!(game::AbstractGame, id, c_idx)
    for c ∈ c_idx
        game.pieces[id][c].row += 1
    end
    return nothing
end

"""
    set_status!(game::AbstractGame, id, c_idx)

Move runner to location determined by column and row index

# Arguments

- `game::AbstractGame`: an abstract game object
- `id`: the id of the player 
- `c_idx`: column index of position 
"""
function set_status!(game::AbstractGame, id, c_idx)
    for i ∈ 1:length(c_idx)
        piece = game.pieces[id][c_idx[i]]
        if !piece.is_runner
            piece.is_runner = true
            piece.start_row = piece.row
            push!(game.runner_cols, c_idx[i])
        end
    end
    return nothing
end


"""
    validate_choice(options::Vector{Vector{Int}}, choice::Vector{Int})

Determine whether a player made a valid choice.

# Arguments

- `options`: a vector of options 
- `choice`: the element from `options` selected by the player
"""
validate_choice(options::Vector{Vector{Int}}, choice::Vector{Int}) = choice ∈ options

"""
    is_bust(game::AbstractGame, options)

Checks whether a dice roll is a bust i.e., does not allow a valid move. 

# Arguments

- `game::AbstractGame`: an abstract game object for Can't Stop
- `options`: a vector of column indices corresponding to possible choices
"""
is_bust(game::AbstractGame, options) = isempty(options)

"""
    is_playing(game::AbstractGame)

# Arguments

- `game::AbstractGame`: an abstract game object for Can't Stop
"""
function is_playing(game::AbstractGame)
    counts = [count(y -> id == y, values(game.players_won)) for id ∈ keys(game.pieces)]
    return all(x -> x < 3, counts)
end

function cleanup!(game::AbstractGame, player)
    set_runners_false!(game::AbstractGame, player)
    empty!(game.runner_cols)
end

"""
    handle_bust!(game::AbstractGame, player::AbstractPlayer; is_safe)

# Arguments

- `game::AbstractGame`: an abstract game object for Can't Stop
- `player::AbstractPlayer`: an subtype of a abstract player

# Keywords

- `is_safe=true`: whether players safely read `game` object without modification. Set to `false` if 
    any player modifies `game` object, or might cheat. 
"""
function handle_bust!(game::AbstractGame, player::AbstractPlayer; is_safe)
    _game = is_safe ? game : deepcopy(game)
    postbust_cleanup!(_game, player)
    return_to_start_position!(game, player)
    return nothing
end

"""
    handle_stop!(game::AbstractGame, player::AbstractPlayer; is_safe)

# Arguments

- `game::AbstractGame`: an abstract game object for Can't Stop
- `player::AbstractPlayer`: an subtype of a abstract player

# Keywords

- `is_safe=true`: whether players safely read `game` object without modification. Set to `false` if 
    any player modifies `game` object, or might cheat. 
"""
function handle_stop!(game::AbstractGame, player::AbstractPlayer; is_safe)
    _game = is_safe ? game : deepcopy(game)
    poststop_cleanup!(_game, player)
    check_winners!(game, player)
    return nothing
end

next(idx, n) = idx == n ? 1 : idx += 1

"""
    initialize_pieces!(game::AbstractGame, p::AbstractPlayer)

# Arguments

- `game::AbstractGame`: an abstract game object for Can't Stop
- `player::AbstractPlayer`: an subtype of a abstract player
"""
function initialize_pieces!(game::AbstractGame, p::AbstractPlayer)
    return Dict(i => Piece(; id = p.id, max_row = game.max_rows[i]) for i ∈ 2:12)
end

function initialize_pieces!(game::AbstractGame, players)
    game.pieces = Dict(p.id => initialize_pieces!(game, p) for p ∈ players)
    return nothing
end

"""
    set_runners_false!(game::AbstractGame, player::AbstractPlayer)

# Arguments

- `game::AbstractGame`: an abstract game object for Can't Stop
- `player::AbstractPlayer`: an subtype of a abstract player
"""
function set_runners_false!(game::AbstractGame, player::AbstractPlayer)
    for p ∈ values(game.pieces[player.id])
        p.is_runner = false
    end
    return nothing
end

"""
    return_to_start_position!(game::AbstractGame, player::AbstractPlayer)

# Arguments

- `game::AbstractGame`: an abstract game object for Can't Stop
- `player::AbstractPlayer`: an subtype of a abstract player
"""
function return_to_start_position!(game::AbstractGame, player::AbstractPlayer)
    for p ∈ values(game.pieces[player.id])
        if p.is_runner
            p.row = p.start_row
        end
    end
    return nothing
end

"""
    check_winners!(game::AbstractGame, player::AbstractPlayer)

Following a stop decision, identifies whether `player` conquered any columns. Conquered columns 
are tracked in the fields `columns_won` and `players_won` of the `game` object. 

- `game::AbstractGame`: an abstract game object for Can't Stop
- `player::AbstractPlayer`: an subtype of a abstract player
"""
function check_winners!(game::AbstractGame, player::AbstractPlayer)
    (; pieces, runner_cols, columns_won, players_won) = game
    id = player.id
    for c ∈ runner_cols
        piece = pieces[id][c]
        if piece.row ≥ piece.max_row
            push!(columns_won, c)
            players_won[c] = id
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

"""
    list_sums(outcome)

Lists all unique sum of combinations of the outcome of rolling dice

# Arguments

- `game::AbstractGame`: an abstract game object for Can't Stop
- `outcome`: the results of rolling the dice
"""
function list_options(game, outcome)
    (; runner_cols, columns_won) = game
    all_options = list_sums(outcome)
    n_runners = length(runner_cols)
    to_keep = fill(true, length(all_options))
    split_options = Vector{Vector{Int}}()
    for (i, option) ∈ enumerate(all_options)
        filter!(x -> x ∉ columns_won, option)
        if n_runners == 3
            filter!(x -> x ∈ runner_cols, option)
        elseif n_runners == 0
            continue
        elseif n_runners < 3
            to_keep[i] =
                all(x -> x == option[1], option) || any(x -> x ∈ runner_cols, option)
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
