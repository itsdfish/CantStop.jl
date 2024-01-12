struct Player <: AbstractPlayer
    id::Symbol
end

Player(;id) = Player(id)