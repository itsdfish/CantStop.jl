module CantStop

    using Combinatorics: permutations
    using Random: shuffle!

    export AbstractGame
    export AbstractPlayer 
    export Game 
    export Piece


    export postbust_cleanup!
    export poststop_cleanup!
    export select_positions
    export simulate
    export take_chance 
    
    include("structs.jl")
    include("functions.jl")
    include("api.jl")

end
