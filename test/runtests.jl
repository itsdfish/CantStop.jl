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

# @safetestset "move!" begin 
#     using CantStop
#     using CantStop: move!
#     using Test

#     game = Game()
#     c_idx = 3
#     r_idx = 2
#     column = game.board[3]
#     push!(column[1], :_runner)
#     move!(game, c_idx, r_idx)

#     for i ∈ 1:length(column)
#         if i == r_idx 
#             @test :_runner ∈ game.board[c_idx][i]
#         else
#             @test :_runner ∉ game.board[c_idx][i]
#         end
#     end
# end

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
end