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
- `pieces::Vector{Symbol}`: a vector of pieces with the value id 

In addition, for a subtype `MyPlayer <: AbstractPlayer`, the API requires the following constructor to ensure 
the correct number of pieces are provided. 

# Constructor

```julia 
MyPlayer(;id) = MyPlayer(id, fill(id, 12))
```
"""
abstract type AbstractPlayer end 

"""
    AbstractGame

An abstract game type for Can't Stop. 

The following fields are required in order to work with default methods: 

# Fields 

- `dice::Dice`: an object resepresenting four dice 
- `columns::Dict{Int,T}`: a dictionary representing columns 2-12. Each column is a vector of symbol vectors which contain the player ids 
- `c_idx::Vector{Int}`: column indices of starting position of active piece 
- `r_idx::Vector{Int}`: row indices of starting position of active pieace 
"""
abstract type AbstractGame end

"""
    Game{T} <: AbstractGame

# Fields 

- `dice::Dice`: an object resepresenting four dice 
- `columns::Dict{Int,T}`: a dictionary representing columns 2-12. Each column is a vector of symbol vectors which contain the player ids 
- `c_idx::Vector{Int}`: column indices of starting position of active piece 
- `r_idx::Vector{Int}`: row indices of starting position of active pieace 
"""
mutable struct Game{T} <: AbstractGame
    dice::Dice 
    columns::Dict{Int,T}
    c_idx::Vector{Int}
    r_idx::Vector{Int}
end

function Game(;dice=Dice(), columns=make_columns())
    return Game(dice, columns, Int[], Int[])
end

function make_columns()
    spaces = [3,5,7,9,11,13,11,9,7,5,3]
    return Dict(i => [Symbol[] for _ ∈ 1:spaces[i-1]] for i ∈ 2:12)
end