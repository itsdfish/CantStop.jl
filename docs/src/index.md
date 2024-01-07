## Overview

The purpose of this documentation is to describe the API for developing bots or models which play the board game *Can't Stop*. CantStop.jl provides two key features: (1) abstract types and methods which can be extended to implement bots with custom strategies, and (2) internal methods which can be extended to develop variations of *Can't Stop*.

## Basic Rules

In *Can't Stop*, the goal is to capture three columns. A column is capture by being the first to move a piece to the end of the column. As shown below, the board contains 11 columns labeled 2 through 12, which correspond to possible values for the sum of two six-sided dice. Sums corresponding to columns near the center have a higher probability, but also require more moves to capture. During a round, a player proceeds through two phases: a runner selection phase and a decision phase. During the runner selection phase, a player rolls 4 six sided dice two times. On the first roll, the player selects two pairs to decide which column to set two runners. If the player already has a piece in a given column, the runner can start in that position. Otherwise, the runner must start in the first position of the column. On the second roll, you select only additional runner, but you may move an existing runner by one row. 


![image info](https://i.redd.it/mzouqtyo2wp91.jpg)