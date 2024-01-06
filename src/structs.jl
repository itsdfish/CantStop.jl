struct Dice 
    n::Int 
    sides::Int 
end

function Dice(;n=4, sides=6)
    return Dice(n, sides)
end

"""
    AbstractPlayer

An abstract type for a player. Subtypes of `AbstractPlayer` must have the fields described below.

# Fields

- `id::Symbol`: player id
- `pieces::Vector{Symbol}`: a vector of 12 pieces where each piece has the value `id`. 

In addition, for a subtype `MyPlayer <: AbstractPlayer`, the API requires the following constructor to ensure 
the correct number of pieces are provided. 

# Constructor

```julia 
MyPlayer(;id, pieces=fill(id, 12)) = MyPlayer(id, pieces)
```
"""
abstract type AbstractPlayer end 

"""
    AbstractGame

An abstract game type for Can't Stop. 

The following fields are required in order to work with default methods: 

# Fields 

- `dice::Dice`: an object resepresenting four dice 
- `board::Dict{Int,T}`: a dictionary representing columns 2-12. Each column is a vector of symbol vectors which contain the player ids 
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
- `board::Dict{Int,T}`: a dictionary representing columns 2-12. Each row in a column is a vector of symbols which contain the player ids 
- `c_idx::Vector{Int}`: column indices of starting position of active piece 
- `r_idx::Vector{Int}`: row indices of starting position of active pieace
- `pieces::Dict{Symbol,Vector{Symbol}}`: inactive pieces for each player: `player_id -> pieces`
"""
mutable struct Game{T} <: AbstractGame
    dice::Dice 
    board::Dict{Int,T}
    c_idx::Vector{Int}
    r_idx::Vector{Int}
    pieces::Dict{Symbol,Vector{Symbol}}
    piece_reserve::Vector{Symbol}
end

function Game(;dice=Dice(), board=make_board())
    return Game(dice, board, Int[], Int[], Dict{Symbol,Vector{Symbol}}(), Symbol[])
end

function make_board()
    spaces = [3,5,7,9,11,13,11,9,7,5,3]
    return Dict(i => [Symbol[] for _ ∈ 1:spaces[i-1]] for i ∈ 2:12)
end