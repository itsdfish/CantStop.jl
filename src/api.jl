"""
    select_runners(game::AbstractGame, player::AbstractPlayer, outcome, i)

# Arguments

- `game::AbstractGame`: an abstract game object 
- `player::AbstractPlayer`: an subtype of a abstract player
- `outcome`: outcome of dice roll

# Returns 

- `c_idx::Vector{Int}`: a vector of column indices
- `r_idx::Vector{Int}`: a vector of row indices
"""
function select_runners(game::AbstractGame, player::AbstractPlayer, outcome, i)
    error("select_runners not implemented for player of type $(typeof(player))")
end

"""
    take_chance(game::AbstractGame, player::AbstractPlayer)


# Arguments

- `game::AbstractGame`: an abstract game object 
- `player::AbstractPlayer`: an subtype of a abstract player

# Returns 

- `decision::Bool`: true if take chance, false otherwise
"""
function take_chance(game::AbstractGame, player::AbstractPlayer)
    error("take_chance not implemented for player of type $(typeof(player))")
end

"""
    select_positions(game::AbstractGame, player::AbstractPlayer, outcome)

# Arguments

- `game::AbstractGame`: an abstract game object 
- `player::AbstractPlayer`: an subtype of a abstract player
- `outcome`: outcome of dice roll

# Returns 

- `c_idx::Vector{Int}`: a vector of column indices
- `r_idx::Vector{Int}`: a vector of row indices
"""
function select_positions(game::AbstractGame, player::AbstractPlayer, outcome)
    error("select_columns not implemented for player of type $(typeof(player))")
end