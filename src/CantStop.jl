module CantStop

    using Combinatorics: combinations
    using Random: shuffle!

    export AbstractGame
    export AbstractPlayer 
    export Game 

    export get_runner_locations
    export get_active_locations
    export list_sums
    export postbust_cleanup!
    export poststop_cleanup!
    export select_positions
    export select_runners
    export simulate
    export take_chance 
    
    include("structs.jl")
    include("functions.jl")
    include("api.jl")

end
