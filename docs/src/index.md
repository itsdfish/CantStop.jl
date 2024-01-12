## Overview

The purpose of this documentation is to describe the API for developing bots or models which play the board game *Can't Stop*. CantStop.jl provides two key features: (1) abstract types and methods which can be extended to implement bots with custom strategies, and (2) internal methods which can be extended to develop variations of *Can't Stop*.

## Installation

There are two methods for installing the package. Option 1 is to install without version control. In the REPL, use `]` to switch to the package mode and enter the following:

```julia
add https://github.com/itsdfish/CantStop.jl
```
Option 2 is to install via a custom registry. The advantage of this approach is that you have more control over version control, expecially if you are using a project-specfic environment. 

1. Install the registry using the directions found [here](https://github.com/itsdfish/Registry.jl).
2. Add the package by typing `]` into the REPL and then typing (or pasting):

```julia
add CantStop
```

## Basic Rules

In *Can't Stop*, the goal is to advance pieces and ultimately capture three columns. A column is capture by being the first to move a piece to the end of the column. As shown below, the board contains 11 columns labeled 2 through 12, which correspond to possible values for the sum of two six-sided dice. Sums corresponding to columns near the center have a higher probability, but also require more moves to capture. During a round, a player repeatedly makes two decisions:

1. roll dice to have a chance of advancing runners
2. select which runners to advance based on the outcome of four dice

A player can have a maximum of 3 runners on the board during each round. A runner is an active piece which can be moved if its column number is equal to the sum of a pair of dice. If the outcome of rolling the dice does not allow a runner to move (i.e., there are no sums which equal a column number of a runner), a "bust" occurs, meaning the player must return the piece to the starting position at the beginning of the round. If the player decides not to roll the dice, the runners stay at thier current position. 


![image info](https://i.redd.it/mzouqtyo2wp91.jpg)