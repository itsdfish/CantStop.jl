"""
    select_runners(game::Type{<:AbstractGame}, player::AbstractPlayer, board, outcome, num_roll)

# Arguments

- `game::Type{<:AbstractGame}`: an abstract game type 
- `player::AbstractPlayer`: an subtype of a abstract player
- `outcome`: outcome of dice roll
- `board`: a dictionary containing keys to columns. Each row in column is a vector of symbols.
- `num_roll`: a count of dice rolls for a given round. Max is 2.

# Returns 

- `c_idx::Vector{Int}`: a vector of column indices
- `r_idx::Vector{Int}`: a vector of row indices
"""
function select_runners(game::Type{<:AbstractGame}, player::AbstractPlayer, board, outcome, num_roll)
    error("select_runners not implemented for player of type $(typeof(player))")
end

"""
    take_chance(game::Type{<:AbstractGame}, player::AbstractPlayer, board)


# Arguments

- `game::Type{<:AbstractGame}`: an abstract game type 
- `player::AbstractPlayer`: an subtype of a abstract player
- `board`: a dictionary containing keys to columns. Each row in column is a vector of symbols.

# Returns 

- `decision::Bool`: true if take chance, false otherwise
"""
function take_chance(game::Type{<:AbstractGame}, player::AbstractPlayer, board)
    error("take_chance not implemented for player of type $(typeof(player))")
end

"""
    select_positions(game::Type{<:AbstractGame}, player::AbstractPlayer, board, outcome)

# Arguments

- `game::Type{<:AbstractGame}`: an abstract game type 
- `player::AbstractPlayer`: an subtype of a abstract player
- `outcome`: outcome of dice roll
- `board`: a dictionary containing keys to columns. Each row in column is a vector of symbols.

# Returns 

- `c_idx::Vector{Int}`: a vector of column indices
- `r_idx::Vector{Int}`: a vector of row indices
"""
function select_positions(game::Type{<:AbstractGame}, player::AbstractPlayer, board, outcome)
    error("select_columns not implemented for player of type $(typeof(player))")
end