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
- `board::Dict{Int,T}`: a dictionary representing columns 2-11. Each column is a vector of symbol vectors which contain the player ids 
- `c_idx::Vector{Int}`: column indices of starting position of active piece 
- `r_idx::Vector{Int}`: row indices of starting position of active pieace
- `pieces::Dict{Symbol,Vector{Symbol}}`: inactive pieces for each player: `player_id -> pieces`
- `piece_reserve::Vector{Symbol}`: holds pieces for runners started at the beginning of the column
"""
abstract type AbstractGame end

"""
    Game{T} <: AbstractGame

# Fields 

- `dice::Dice`: an object resepresenting four dice 
- `pieces::Dict{Symbol,Vector{Symbol}}`: inactive pieces for each player: `player_id -> pieces`

# Constructor

```julia
Game(;dice=Dice(), board=make_board())
```
"""
mutable struct Game{P<:AbstractPiece} <: AbstractGame
    dice::Dice 
    pieces::Dict{Symbol, Dict{Int64, P}}
end

function Game(;dice=Dice(), piece_type=Piece)
    pieces = Dict{Symbol, Dict{Int64, piece_type}}()
    return Game(dice, pieces)
end