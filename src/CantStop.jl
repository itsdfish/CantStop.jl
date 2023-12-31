module CantStop

    using Combinatorics: combinations

    export AbstractPlayer 
    export Dice 
    export Game 
    export Player

    include("structs.jl")
    include("functions.jl")

end
