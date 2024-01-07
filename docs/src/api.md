
## Required

The API requires you to create a subtype of `AbstractPlayer` with extensions of the methods below.

### Types

```@docs 
AbstractPlayer
```

### Methods

```@docs 
select_runners
take_chance
select_positions
postbust_cleanup!
poststop_cleanup!
```

## Optional Types 

It is possible to create variations of the game by creating a new subtype of `AbstractGame` and 
defining new [internal methods](internal_methods.md) as needed. 

```@docs
AbstractGame
```

## Available Types 

```@docs 
Game
```
# Utilities

The following methods might be helpful for defining the required methods above.

```@docs
get_active_locations
get_runner_locations
is_valid_runner
list_sums
reserve_piece!
simulate
```