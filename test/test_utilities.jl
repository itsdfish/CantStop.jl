import CantStop: postbust_cleanup!
import CantStop: poststop_cleanup!
import CantStop: roll_again
import CantStop: select_runners

struct Player <: AbstractPlayer
    id::Symbol
end

Player(;id) = Player(id)

roll_again(game::AbstractGame, player::Player) = rand(Bool)

select_runners(game::AbstractGame, player::Player, options) = rand(options)

postbust_cleanup!(game::AbstractGame, player::Player) = nothing

poststop_cleanup!(game::AbstractGame, player::Player) = nothing