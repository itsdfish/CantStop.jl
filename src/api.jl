"""
    select_runners(Game::AbstractGame, player::AbstractPlayer, options)

During the selection phase, select runners based on the outcome of a dice roll. 

# Arguments

- `game::AbstractGame`: an abstract game object for Can't Stop. The object is a copy, which means it is safe to 
    modify.
- `player::AbstractPlayer`: an subtype of a abstract player
- `options`: a vector of columns that can be selected based on outcome of rolling dice

# Returns 

- `c_idx::Vector{Int}`: a vector of selected column indices for moving runner
"""
function select_runners(Game::AbstractGame, player::AbstractPlayer, options)
    error("select_runners not implemented for player of type $(typeof(player))")
end

"""
    roll_again(Game::AbstractGame, player::AbstractPlayer)

During the decision phase, decide whether to take a chance to advance the runners, or set your pieces in 
the current location of the runners. 

# Arguments

- `game::AbstractGame`: an abstract game object for Can't Stop. The object is a copy, which means it is safe to 
    modify.
- `player::AbstractPlayer`: an subtype of a abstract player

# Returns 

- `decision::Bool`: true if take chance, false otherwise
"""
function roll_again(Game::AbstractGame, player::AbstractPlayer)
    error("roll_again not implemented for player of type $(typeof(player))")
end

"""
    poststop_cleanup!(Game::AbstractGame, player::AbstractPlayer)
    
Performs cleanup and book keeping after deciding to stop rolling during the decision phase.

# Arguments

- `game::AbstractGame`: an abstract game object for Can't Stop. The object is a copy, which means it is safe to 
    modify.
- `player::AbstractPlayer`: an subtype of a abstract player

# Returns 

- nothing
"""
function poststop_cleanup!(Game::AbstractGame, player::AbstractPlayer)
    error("postbust_cleanup! not implemented for player of type $(typeof(player))")
end

"""
    postbust_cleanup!(Game::AbstractGame, player::AbstractPlayer)

Performs cleanup and book keeping after a "bust" (i.e., a roll that does not provide a valid move).

# Arguments

- `game::AbstractGame`: an abstract game object for Can't Stop. The object is a copy, which means it is safe to 
    modify.
- `player::AbstractPlayer`: an subtype of a abstract player

# Returns 

- nothing
"""
function postbust_cleanup!(Game::AbstractGame, player::AbstractPlayer)
    error("postbust_cleanup! not implemented for player of type $(typeof(player))")
end

"""
    get_winner(game::AbstractGame)

Returns a vector of winners. If there is a tie, all winners are included in the vector. 

# Arguments

- `game::AbstractGame`: an abstract game object for Can't Stop
"""
function get_winner(game::AbstractGame)
    ids = collect(keys(game.pieces))
    counts = [count(y -> id == y, values(game.players_won)) for id ∈ ids]
    max_val = maximum(counts)
    idxs = findall(x -> x == max_val, counts)
    return ids[idxs]
end