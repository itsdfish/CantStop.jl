using SafeTestsets

@safetestset "is_bust" begin
    using CantStop
    using CantStop: is_bust
    using Test

    game = Game()
    options = []
    @test is_bust(game, options)

    game = Game()
    options = [[3,4]]
    @test !is_bust(game, options)
end

@safetestset "next" begin 
    using CantStop
    using CantStop: next
    using Test

    n = 3 
    @test next(1, n) == 2 
    @test next(2, n) == 3
    @test next(3, n) == 1
end

@safetestset "is_playing" begin
    @safetestset "1" begin 
        using CantStop
        using CantStop: is_playing
        using Test

        game = Game()
        game.pieces[:p1] = Dict(2 => Piece(;id=:p1, max_row=8))
        game.pieces[:p2] = Dict(2 => Piece(;id=:p2, max_row=8))

        game.players_won[2] = :p1 
        game.players_won[3] = :p1 
        game.players_won[4] = :p2 
        
        @test is_playing(game)
    end

    @safetestset "2" begin 
        using CantStop
        using CantStop: is_playing
        using Test

        game = Game()
        game.pieces[:p1] = Dict(2 => Piece(;id=:p1, max_row=8))
        game.pieces[:p2] = Dict(2 => Piece(;id=:p2, max_row=8))

        game.players_won[2] = :p1 
        game.players_won[3] = :p1 
        game.players_won[4] = :p1 
        
        @test !is_playing(game)
    end
end

@safetestset "validate_choice" begin 
    @safetestset "1" begin 
        using CantStop
        using CantStop: validate_choice
        using Test
        
        options = [[3],[5,4]]
        choice = [3]
        @test validate_choice(options, choice)
    end

    @safetestset "2" begin 
        using CantStop
        using CantStop: validate_choice
        using Test

        options = [[3],[5,4]]
        choice = [5,6]
        @test !validate_choice(options, choice)
    end
end

@safetestset "list_options" begin 
    @safetestset "1" begin 
        using CantStop
        using CantStop: list_options
        using Test
        
        game = Game() 
        outcome = [1,1,2,2]
        options = list_options(game, outcome)
        @test options == [[2,4],[3,3]]
    end

    @safetestset "2" begin 
        using CantStop
        using CantStop: list_options
        using Test
        
        game = Game() 
        outcome = [1,1,2,2]
        game.columns_won = [2]
        options = list_options(game, outcome)
        @test options == [[4],[3,3]]
    end

    @safetestset "3" begin 
        using CantStop
        using CantStop: list_options
        using Test
        
        game = Game() 
        outcome = [1,1,2,2]
        game.columns_won = [2]
        game.runner_cols = [2,4]
        options = list_options(game, outcome)
        @test options == [[4],[3,3]]
    end

    @safetestset "4" begin 
        using CantStop
        using CantStop: list_options
        using Test
        
        game = Game() 
        outcome = [1,1,2,2]
        game.columns_won = [2]
        game.runner_cols = [2,4,5]
        options = list_options(game, outcome)
        @test options == [[4]]
    end

    @safetestset "5" begin 
        using CantStop
        using CantStop: list_options
        using Test
        
        game = Game() 
        outcome = [1,2,3,4]
        game.runner_cols = [3,5]
        options = list_options(game, outcome)     
        @test options == [[3,7],[5,5],[4],[6]]
    end

    @safetestset "6" begin 
        using CantStop
        using CantStop: list_options
        using Test
        
        game = Game() 
        outcome = [6,3,5,5]
        game.runner_cols = [5,7]
        options = list_options(game, outcome)     
        @test options == [[9],[10],[11],[8]]
    end

    @safetestset "7" begin 
        using CantStop
        using CantStop: list_options
        using Test
        
        game = Game() 
        outcome = [1,1,1,1]
        options = list_options(game, outcome)
        @test options == [[2,2]]
    end
end

@safetestset "return_to_start_position!" begin 
    using CantStop
    using CantStop: return_to_start_position!
    using Test
    include("test_utilities.jl")
    
    game = Game() 
    game.pieces[:p1] = Dict(2 => Piece(;id=:p1, is_runner=true, max_row=8, row=2, start_row=0),
        3 => Piece(;id=:p1, is_runner=true, max_row=10, row=3, start_row=1),
        4 => Piece(;id=:p1, is_runner=false, max_row=10, row=3, start_row=1))
    player = Player(;id=:p1)

    return_to_start_position!(game, player)   

    @test game.pieces[:p1][2].row == 0
    @test game.pieces[:p1][3].row == 1
    @test game.pieces[:p1][4].row == 3
end

@safetestset "check_winners!" begin 
    using CantStop
    using CantStop: check_winners!
    using Test
    include("test_utilities.jl")
    
    game = Game() 
    game.pieces[:p1] = Dict(2 => Piece(;id=:p1, is_runner=true, max_row=8, row=9, start_row=0),
        3 => Piece(;id=:p1, is_runner=true, max_row=10, row=3, start_row=1),
        4 => Piece(;id=:p1, is_runner=false, max_row=10, row=10, start_row=1))
    game.runner_cols = [2,3]
    player = Player(;id=:p1)

    check_winners!(game, player)   

    @test game.columns_won == [2]
    for i ∈ 2:12
        if i == 2
            @test game.players_won[i] == :p1
        else
            @test game.players_won[i] == :_
        end
    end
end

@safetestset "set_status!" begin 
    using CantStop
    using CantStop: set_status!
    using Test
    include("test_utilities.jl")
    
    game = Game() 
    game.pieces[:p1] = Dict(2 => Piece(;id=:p1, is_runner=false, max_row=8, row=9, start_row=0),
        3 => Piece(;id=:p1, is_runner=false, max_row=10, row=3, start_row=1),
        4 => Piece(;id=:p1, is_runner=true, max_row=10, row=10, start_row=1),
        5 => Piece(;id=:p1, is_runner=false, max_row=10, row=10, start_row=1))
    game.runner_cols = [4]
    player = Player(;id=:p1)

    set_status!(game, player.id, [2,3])   

    @test game.runner_cols == [4,2,3]
    for i ∈ 2:5
        if i ∈ [2,3,4]
            @test game.pieces[:p1][i].is_runner
        else
            @test !game.pieces[:p1][i].is_runner
        end
    end
end

@safetestset "move!" begin 
    using CantStop
    using CantStop: move!
    using Test
    include("test_utilities.jl")
    
    game = Game() 
    game.pieces[:p1] = Dict(2 => Piece(;id=:p1, is_runner=true, max_row=8, row=9, start_row=0),
        3 => Piece(;id=:p1, is_runner=true, max_row=10, row=1, start_row=1),
        4 => Piece(;id=:p1, is_runner=true, max_row=10, row=1, start_row=1),
        5 => Piece(;id=:p1, is_runner=false, max_row=10, row=1, start_row=1))
    game.runner_cols = [4]
    player = Player(;id=:p1)

    move!(game, player.id, [2])  

    for i ∈ 2:5
        if i == 2
            @test game.pieces[:p1][i].row == 10
        else
            @test game.pieces[:p1][i].row == 1
        end
    end
end

@safetestset "simulate!" begin 
    using CantStop
    using Test
    include("test_utilities.jl")
    
    players = [Player(id=:p1), Player(id=:p2)]
    game = Game()
    simulate!(game, players)
    @test get_winner(game) ∈ [:p1,:p2]
end