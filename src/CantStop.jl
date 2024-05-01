module CantStop

using Combinatorics: permutations
using Random: shuffle!

export AbstractGame
export AbstractPlayer
export Game
export Piece

export get_winner
export postbust_cleanup!
export poststop_cleanup!
export roll_again
export select_runners
export simulate!

include("structs.jl")
include("functions.jl")
include("api.jl")

end
