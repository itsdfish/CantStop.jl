"""
    select_runners(::Type{<:AbstractGame}, player::AbstractPlayer, board, outcome, num_roll)

During the selection phase, select runners based on the outcome of a dice roll. 

# Arguments

- `::Type{<:AbstractGame}`: an abstract game type 
- `player::AbstractPlayer`: an subtype of a abstract player
- `outcome`: outcome of dice roll
- `board::Dict{Int,T}`: a dictionary representing columns 2-12. Each row in a column is a vector of symbols which contain the player ids 
- `num_roll`: a count of dice rolls for a given round. Max is 2.

# Returns 

- `c_idx::Vector{Int}`: a vector of column indices
- `r_idx::Vector{Int}`: a vector of row indices
"""
function select_runners(::Type{<:AbstractGame}, player::AbstractPlayer, board, outcome, num_roll)
    error("select_runners not implemented for player of type $(typeof(player))")
end

"""
    take_chance(::Type{<:AbstractGame}, player::AbstractPlayer, board)

During the decision phase, decide whether to take a chance to advance the runners, or set your pieces in 
the current location of the runners. 

# Arguments

- `::Type{<:AbstractGame}`: an abstract game type 
- `player::AbstractPlayer`: an subtype of a abstract player
- `board::Dict{Int,T}`: a dictionary representing columns 2-12. Each row in a column is a vector of symbols which contain the player ids 

# Returns 

- `decision::Bool`: true if take chance, false otherwise
"""
function take_chance(::Type{<:AbstractGame}, player::AbstractPlayer, board)
    error("take_chance not implemented for player of type $(typeof(player))")
end

"""
    select_positions(::Type{<:AbstractGame}, player::AbstractPlayer, board, outcome)

During the decision phase and after deciding to take chance, select positions based on the outcome of rolling dice. 
Two column indices are determined by summing two pairs of dice. 

# Arguments

- `::Type{<:AbstractGame}`: an abstract game type 
- `player::AbstractPlayer`: an subtype of a abstract player
- `outcome`: outcome of dice roll
- `board::Dict{Int,T}`: a dictionary representing columns 2-12. Each row in a column is a vector of symbols which contain the player ids 

# Returns 

- `c_idx::Vector{Int}`: a vector of column indices
- `r_idx::Vector{Int}`: a vector of row indices
"""
function select_positions(::Type{<:AbstractGame}, player::AbstractPlayer, board, outcome)
    error("select_columns not implemented for player of type $(typeof(player))")
end

"""
    poststop_cleanup(::Type{<:AbstractGame}, player::AbstractPlayer)
    
Performs cleanup and book keeping after deciding to stop rolling during the decision phase.

# Arguments

- `::Type{<:AbstractGame}`: an abstract game type 
- `player::AbstractPlayer`: an subtype of a abstract player

# Returns 

- nothing
"""
function poststop_cleanup!(::Type{<:AbstractGame}, player::AbstractPlayer)
    error("postbust_cleanup! not implemented for player of type $(typeof(player))")
end

"""
    postbust_cleanup!(::Type{<:AbstractGame}, player::AbstractPlayer)

Performs cleanup and book keeping after a "bust" (i.e., a roll that does not provide a valid move).

# Arguments

- `::Type{<:AbstractGame}`: an abstract game type 
- `player::AbstractPlayer`: an subtype of a abstract player

# Returns 

- nothing
"""
function postbust_cleanup!(::Type{<:AbstractGame}, player::AbstractPlayer)
    error("postbust_cleanup! not implemented for player of type $(typeof(player))")
end

"""
    get_runner_locations(board)

Returns runner locations. 

# Arguments

- `board::Dict{Int,T}`: a dictionary representing columns 2-12. Each row in a column is a vector of symbols which contain the player ids 

# Returns 

- `c_idx`: column indices
- `r_idx`: row indices
"""
function get_runner_locations(board)
    c_idx = Int[]
    r_idx = Int[]
    for c ∈ keys(board)
        for r ∈ 1:length(board[c])
            if :_runner ∈ board[c][r]
                push!(c_idx, c)
                push!(r_idx, r)
                length(c_idx) == 3 ? (return c_idx, r_idx) : nothing
            end
        end
    end
    return c_idx, r_idx
end

"""
    get_active_locations(board, player_id)

Returns the location of active pieces, which includes runners. 

# Arguments

- `board::Dict{Int,T}`: a dictionary representing columns 2-12. Each row in a column is a vector of symbols which contain the player ids 
- `player_id::Symbol`: id of player

# Returns 

- `c_idx`: column indices of active positions
- `r_idx`: row indices of active positions
"""
function get_active_locations(board, player_id)
    c_idx = Int[]
    r_idx = Int[]
    for c ∈ keys(board)
        for r ∈ 1:length(board[c])
            if :_runner ∈ board[c][r] || player_id ∈ board[c][r]
                push!(c_idx, c)
                push!(r_idx, r)
                length(c_idx) == 3 ? (return c_idx, r_idx) : nothing
            end
        end
    end
    return c_idx, r_idx
end

"""
    list_sums(outcome)

Lists all unique sum of combinations of the outcome of rolling dice

# Arguments

- `outcome`: the results of rolling the dice
"""
list_sums(outcome) = unique(sum.(combinations(outcome, 2)))

"""
    is_valid_move(game, outcome, c_idx, r_idx, player_id)

Evaluates whether a proposed move is valid.

# Arguments

- `board::Dict{Int,T}`: a dictionary representing columns 2-12. Each row in a column is a vector of symbols which contain the player ids 
- `outcome`: the results of rolling the dice
- `c_idx`: column indices of proposed positions
- `r_idx`: row indices of proposed positions
- `player_id`: id of player
"""
function is_valid_move(board, outcome, c_idx, r_idx, player_id)
    if length(r_idx) ≠ length(c_idx)
        return false
    end
    if length(r_idx) > 2
        return false
    end
    if !is_in_range(c_idx)
        return false
    end
    if !is_combination(outcome, c_idx)
        return false
    end
    if has_been_won(board, c_idx)
        return false
    end
    if !rows_are_valid(board, c_idx, r_idx, player_id)
        return false
    end
    return true
end


"""
    is_valid_runner(board, outcome, c_idx, r_idx, player_id)

Evaluates whether a proposed runner is valid.

# Arguments

- `board::Dict{Int,T}`: a dictionary representing columns 2-12. Each row in a column is a vector of symbols which contain the player ids 
- `outcome`: the results of rolling the dice
- `c_idx`: column indices of proposed positions
- `r_idx`: row indices of proposed positions
- `player_id`: id of player
"""
function is_valid_runner(board, outcome, c_idx, r_idx, player_id)
    (;board) = game
    if length(r_idx) ≠ length(c_idx)
        return false
    end
    if length(r_idx) > 2
        return false
    end
    if !is_in_range(c_idx)
        return false
    end
    if !is_combination(outcome, c_idx)
        return false
    end
    if has_been_won(board, c_idx)
        return false
    end
    if !rows_are_valid(board, c_idx, r_idx, player_id)
        return false
    end
    return true
end

"""
    reserve_piece!(player::AbstractPlayer)

Tranfer piece to reserve for bookkeeping. 

# Arguments

- `player::AbstractPlayer`: an object which is a subtype of `AbstractPlayer`
"""
function reserve_piece!(player::AbstractPlayer)
    push!(player.piece_reserve, pop!(player.pieces))
    return nothing
end
# function get_location(column, player_id)
#     for c ∈ 1:length(column) 
#         player_id ∈ column[c] ? (return c) : nothing 
#     end
#     return 0 
# end