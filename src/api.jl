"""
    select_runners(Game::AbstractGame, player::AbstractPlayer, options)

During the selection phase, select runners based on the outcome of a dice roll. 

# Arguments

- `game::AbstractGame`: an abstract game object for Can't Stop. The object can be modified if `is_safe=false` is set 
    in `simulate!`.
- `player::AbstractPlayer`: an subtype of a abstract player
- `options`: a vector of runners which can advance. For example, if the roll is `[1,1,2,2]` and runners can be used in columns 2,3, and 4, then the options would be `[[2,4],[3,3]]`.
    If a runner cannot be moved in column 2, then the options would be `[[4],[3,3]]`.

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

- `game::AbstractGame`: an abstract game object for Can't Stop. The object can be modified if `is_safe=false` is set 
    in `simulate!`.
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

- `game::AbstractGame`: an abstract game object for Can't Stop. The object can be modified if `is_safe=false` is set 
    in `simulate!`.
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

- `game::AbstractGame`: an abstract game object for Can't Stop. The object can be modified if `is_safe=false` is set 
    in `simulate!`.
- `player::AbstractPlayer`: an subtype of a abstract player

# Returns 

- nothing
"""
function postbust_cleanup!(Game::AbstractGame, player::AbstractPlayer)
    error("postbust_cleanup! not implemented for player of type $(typeof(player))")
end

"""
    get_winner(game::AbstractGame)

Returns the winner of the game. 

# Arguments

- `game::AbstractGame`: an abstract game object for Can't Stop
"""
function get_winner(game::AbstractGame)
    ids = collect(keys(game.pieces))
    counts = [count(y -> id == y, values(game.players_won)) for id ∈ ids]
    max_val = maximum(counts)
    idxs = findfirst(x -> x == max_val, counts)
    return ids[idxs]
end