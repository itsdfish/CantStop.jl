"""
    Dice
    
An object for rolling dice. 

# Fields 

- `n::Int`: number of rolls 
- `sides::Int`: number of sides per die

# Constructors 

```julia
Dice(4, 6)
Dice(;n=4, sides=6)
```
"""
struct Dice 
    n::Int 
    sides::Int 
end

function Dice(;n=4, sides=6)
    return Dice(n, sides)
end

abstract type AbstractPiece end

mutable struct Piece <: AbstractPiece 
    id::Symbol 
    row::Int 
    is_runner::Bool
    max_row::Int 
    start_row::Int
end

Piece(;id, row=0, is_runner=false, max_row, start_row=0) = Piece(id, row, is_runner, max_row, start_row)

"""
    AbstractPlayer

An abstract type for a player. Subtypes of `AbstractPlayer` must have the fields described below.

# Fields

- `id::Symbol`: player id
- `pieces::Vector{Symbol}`: a vector of 11 pieces where each piece has the value `id`. 
- `piece_reserve::Vector{Symbol}`: an optional vector for keeping track of pieces which will replace runners unless a bust occurs

In addition, for a subtype `MyPlayer <: AbstractPlayer`, the API requires the following constructor to ensure 
the correct number of pieces are provided. 

# Constructor

```julia 
MyPlayer(;id, pieces=fill(id, 11)) = MyPlayer(id, pieces)
```
"""
abstract type AbstractPlayer end 

"""
    AbstractGame

An abstract game type for Can't Stop. 

The following fields are required in order to work with default methods: 

# Fields 

- `dice::Dice`: an object resepresenting four dice 
- `pieces::Dict{Symbol,Vector{Symbol}}`: inactive pieces for each player: `player_id -> pieces`
- `columns_won::Vector{Int}`: a vector of indices for columns won
- `max_rows::Dict{Int,Int}`: maximum number of rows for each column
- `players_won::Dict{Int,Symbol}`: indicates which player won a given column. A value of `:_` indicates no 
    player has won the column
"""
abstract type AbstractGame end

"""
    Game{P<:AbstractPiece} <: AbstractGame

The default game object for CantStop. 

# Fields 

- `dice::Dice`: an object resepresenting four dice 
- `pieces::Dict{Symbol,Vector{Symbol}}`: inactive pieces for each player: `player_id -> pieces`
- `columns_won::Vector{Int}`: a vector of indices for columns won
- `max_rows::Dict{Int,Int}`: maximum number of rows for each column
- `players_won::Dict{Int,Symbol}`: indicates which player won a given column. A value of `:_` indicates no 
    player has won the column

# Constructor

```julia
Game(;dice=Dice(), piece_type=Piece)
```
"""
mutable struct Game{P<:AbstractPiece} <: AbstractGame
    dice::Dice 
    pieces::Dict{Symbol, Dict{Int64, P}}
    columns_won::Vector{Int}
    players_won::Dict{Int,Symbol}
    max_rows::Dict{Int,Int}
    runner_cols::Vector{Int}
end

function Game(;dice=Dice(), piece_type=Piece)
    pieces = Dict{Symbol, Dict{Int64, piece_type}}()
    players_won = Dict(i => :_ for i ∈ 2:12)
    _max_rows = [3,5,7,9,11,13,11,9,7,5,3]
    max_rows = Dict(i => _max_rows[i-1] for i ∈ 2:12)
    return Game(dice, pieces, Int[], players_won, max_rows, Int[])
end