```@setup example
using CantStop
import CantStop: select_positions
import CantStop: select_runners
import CantStop: take_chance


```

# Introduction 


# Example 

## Dependencies 

```@example example
using CantStop
import CantStop: select_positions
import CantStop: select_runners
import CantStop: take_chance
```

## Make Player Type

```@example example
struct Player <: AbstractPlayer
    id::Symbol
    pieces::Vector{Symbol}
end
Player(;id) = Player(id, fill(id, 12))
```

## Required Methods 

### select_runners 


```@example example
function select_runners(game::AbstractGame, player::Player, outcome, i)
    error("select_runners not implemented for player of type $(typeof(player))")
end
```
### take_chance
```@example example
function take_chance(game::AbstractGame, player::Player)
    error("take_chance not implemented for player of type $(typeof(player))")
end
```

### select_positions

```@example example
function select_positions(game::AbstractGame, player::Player, outcome)
    error("select_columns not implemented for player of type $(typeof(player))")
end
```

## Run Simulation 

```@example example
game = Game()

players = [Player(id=:p1), Player(id=:p2)]

simulate(game, players)
```