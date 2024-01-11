"""
    select_positions(Game::AbstractGame, player::AbstractPlayer, options)

During the selection phase, select runners based on the outcome of a dice roll. 

# Arguments

- `Game::AbstractGame`: an abstract game 
- `player::AbstractPlayer`: an subtype of a abstract player
- `options`: a vector of columns that can be selected based on outcome of rolling dice

# Returns 

- `c_idx::Vector{Int}`: a vector of selected column indices for moving runner
"""
function select_positions(Game::AbstractGame, player::AbstractPlayer, options)
    error("select_positions not implemented for player of type $(typeof(player))")
end

"""
    take_chance(Game::AbstractGame, player::AbstractPlayer)

During the decision phase, decide whether to take a chance to advance the runners, or set your pieces in 
the current location of the runners. 

# Arguments

- `Game::AbstractGame`: an abstract game 
- `player::AbstractPlayer`: an subtype of a abstract player

# Returns 

- `decision::Bool`: true if take chance, false otherwise
"""
function take_chance(Game::AbstractGame, player::AbstractPlayer)
    error("take_chance not implemented for player of type $(typeof(player))")
end

"""
    poststop_cleanup!(Game::AbstractGame, player::AbstractPlayer)
    
Performs cleanup and book keeping after deciding to stop rolling during the decision phase.

# Arguments

- `Game::AbstractGame`: an abstract game 
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

- `Game::AbstractGame`: an abstract game 
- `player::AbstractPlayer`: an subtype of a abstract player

# Returns 

- nothing
"""
function postbust_cleanup!(Game::AbstractGame, player::AbstractPlayer)
    error("postbust_cleanup! not implemented for player of type $(typeof(player))")
end