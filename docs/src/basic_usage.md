```@setup example
using CantStop
import CantStop: postbust_cleanup!
import CantStop: poststop_cleanup!
import CantStop: roll_again
import CantStop: select_runners
```

# Introduction 

In this tutorial, we provide a basic example to illustrate how to use the API for Cantstop.jl. The decision strategy of the example player is designed to be as simple as possible for illustrative purposes. As such, the strategy is to select an avaiable option at random. 

# Example 

## Dependencies 

The first step is to load the dependencies. In this simple example, the only dependency we need is `CantStop`, which is loaded via the `using` keyword. In addition, we must import a total of five methods using the keyword `import`. By importing the methods, we can define a version of each method which works with our player type. 

```@example example
using CantStop
import CantStop: postbust_cleanup!
import CantStop: poststop_cleanup!
import CantStop: roll_again
import CantStop: select_runners
```

## Make Player Type

The API for `CantStop` requires you to define your own player type, which is a subtype of `AbstractPlayer`. The example below contains three required fields: `id`, which is a unique identifier. Optionally, you may add other fields to your custom player type as needed.

```@example example
struct Player <: AbstractPlayer
    id::Symbol
end

Player(;id) = Player(id)
```

## Required Methods 

The API requires four methods to be defined for each custom type: `roll_again`, `select_runners`, `postbust_cleanup`, and `poststop_cleanup`. The first two methods concern the decision making mechanics of the player, and thus, must return required information to play the game. As illustrated below, the last two methods must also be defined, but can be blank because the interal functions do not process. The purpose is to provide an entry point to optionally update the internal state of the player following a bust or decision to stop. 

### select_runners

Each round begins with an initial roll of the dice and a decision to select runners to move. The function requires the following arguments:

- `game::AbstractGame`: a copy of the game object for Can't Stop
- `player::Player`: a n object for your player type 
- `options`: a copy of a vector of runners which can advance, e.g., `[[1,2],[3]]`

The method must return one element from the vector of options, e.g., `[1,2]`. In the simple example below, the player selects an option randomly with equal probability. 

```@example example
select_runners(game::AbstractGame, player::Player, options) = rand(options)
```

### roll_again

After moving runners, the player is presented with a decision to roll again for a chance to further advance the runners, or to stop and keep the runners in their current position. The player can make a decision based on the state of the game, which is provided in the game object. To make the player simple, it decides to continue stop with equal probability. 

```@example example
roll_again(game::AbstractGame, player::Player) = rand(Bool)
```

### postbust_cleanup 

The function `postbust_cleanup` provides an optional entry point update the state of the player following a bust. Using this function might be helpful for a player which learns from experience. For the purposes of our simple player, `postbust_cleanup` is not necessary. Thus, it simply returns `nothing`. 

```@example example 
postbust_cleanup!(game::AbstractGame, player::Player) = nothing
```

### poststop_cleanup 

The function `poststop_cleanup` provides an optional entry point update the state of the player after deciding to stop rolling the dice.  Again, `poststop_cleanup` might be useful for some custom players, but is not necessary for this simple example. As before, this function simply returns `nothing`. 

```@example example 
poststop_cleanup!(game::AbstractGame, player::Player) = nothing
```

## Run Simulation 

Now that we defined a custom player type and the four required methods, we can now simulate the game. Below, we begin by generating an instance of the default `Game` object. Next, we define a vector of two players with unique ids. Finally, we use `simulate!` so the two players play *Can't Stop* and then call `get_winner` to identify the winner. 

```@example example
game = Game()
players = [Player(id=:p1), Player(id=:p2)]
simulate!(game, players)
get_winner(game)
```