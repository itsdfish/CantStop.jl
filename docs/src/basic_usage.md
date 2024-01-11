```@setup example
using CantStop
import CantStop: postbust_cleanup!
import CantStop: poststop_cleanup!
import CantStop: select_runners
import CantStop: select_positions
import CantStop: take_chance
```

# Introduction 

In this tutorial, we provide a basic example to illustrate how to use the API for Cantstop.jl.

# Example 

## Dependencies 

The first step is to load the dependencies. In this simple example, the only dependency we need is `CantStop`, which is loaded via the `using` keyword. In addition, we must import a total of five methods using the keyword `import`. By importing the methods, we can define a version of each method which works with our player type. 

```@example example
using CantStop
import CantStop: postbust_cleanup!
import CantStop: poststop_cleanup!
import CantStop: select_runners
import CantStop: select_positions
import CantStop: take_chance
```

## Make Player Type

The API for `CantStop` requires you to define your own player type, which is a subtype of `AbstractPlayer`. The example below contains three required fields: `id`, which is a unique identifier for an instance of your player type, `pieces`, which is a vector containing 11 elements of `id`, and `piece_reserve`, which contain
```@example example
struct Player <: AbstractPlayer
    id::Symbol
    pieces::Vector{Symbol}
    piece_reserve::Vector{Symbol}
end

Player(;id) = Player(id, fill(id, 11), Symbol[])
```

## Required Methods 

### select_runners 


```@example example
function select_runners(game::AbstractGame, player::Player, outcome, i)
    c_idx = Int[]
    r_idx = Int[]
    # on first attempt, 2 positions are given, but only 1 position on the second attempt
    for j ∈ 1:(3 - i)
        # columns are the sum of the first two dice and the sum of the last two dice 
        k = 2 * (j - 1) + 1
        push!(c_idx, outcome[k] + outcome[k+1])
        _idx = findfirst(x -> player.id ∈ x, game.columns[c_idx[j]])
        # if the player does not have a piece in the column, start at position 1, otherwise put
        # runner in the next position
        idx = isnothing(_idx) ? 1 : _idx + 1
        push!(r_idx, idx)
    end
    return c_idx, r_idx
end
```
### take_chance
```@example example
take_chance(game::AbstractGame, player::Player) = rand(Bool)

```

### select_positions

```@example example
function select_positions(game::AbstractGame, player::Player, outcome)
    # all possible columns
    possible_cols = list_sums(game, outcome)
    # activate columns containing a runner 
    c_idx, r_idx = get_runner_locations(game)
    # possible columns which are also active 
    matching_cols = intersect(possible_cols, c_idx)
    # get the first available active column index 
    m = findfirst(x -> x == matching_cols[1], c_idx)
    return [c_idx[m],],[r_idx[m],]
end
```

## Run Simulation 

```@example example
game = Game()

players = [Player(id=:p1), Player(id=:p2)]

#simulate(game, players)
```