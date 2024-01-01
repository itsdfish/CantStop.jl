using SafeTestsets

@safetestset "is_combination" begin
    using CantStop: is_combination
    using Test

    outcome = [1,2,3,4]
    columns = [3,4]

    @test is_combination(outcome, columns; fun = any)
    @test is_combination(outcome, columns; fun = all)

    outcome = [1,2,3,4]
    columns = [3,40]

    @test is_combination(outcome, columns; fun = any)
    @test !is_combination(outcome, columns; fun = all)

    outcome = [1,2,3,4]
    columns = [20,40]

    @test !is_combination(outcome, columns; fun = any)
    @test !is_combination(outcome, columns; fun = all)
end

@safetestset "is_bust" begin
    using CantStop: is_bust
    using Test

    outcome = [1,2,3,4]
    columns = [3,4]

    @test !is_bust(outcome, columns)

    outcome = [1,2,3,4]
    columns = [30,40]

    @test is_bust(outcome, columns)

    outcome = [1,2,3,4]
    columns = [1,30]

    @test is_bust(outcome, columns)
end

@safetestset "is_playing" begin
    using CantStop: is_playing
    using Test

    c_idx = []
    @test !is_playing(c_idx)

    c_idx = [3,7]
    @test is_playing(c_idx)
end

@safetestset "is_valid" begin

    @safetestset "unequal length" begin 
        using CantStop
        using CantStop: is_valid
        using Test

        game = Game()
        push!(game.columns[2][end], :player)
        outcome = [1,2,3,4]
        columns = [2]
        rows = [1,2]
        player_id = :player 

        message = ErrorException("columns and rows do not have the same length")
        @test_throws  message is_valid(game, outcome, columns, rows, player_id)
    end

    @safetestset "column error" begin 
        using CantStop
        using CantStop: is_valid
        using Test

        game = Game()
        outcome = [1,2,3,4]
        columns = []
        rows = [1,2]
        player_id = :player 
        message = ErrorException("columns cannot be empty")

        @test_throws message is_valid(game, outcome, columns, rows, player_id)
    end

    @safetestset "row empty error" begin 
        using CantStop
        using CantStop: is_valid
        using Test

        game = Game()
        outcome = [1,2,3,4]
        columns = [3,7]
        rows = []
        player_id = :player 
        message = ErrorException("rows cannot be empty")

        @test_throws message is_valid(game, outcome, columns, rows, player_id)
    end

    @safetestset "not in range" begin 
        using CantStop
        using CantStop: is_valid
        using Test

        game = Game()
        outcome = [1,2,3,4]
        columns = [13,7]
        rows = [1,2]
        player_id = :player 

        message = ErrorException("$columns not in range") 

        @test_throws message is_valid(game, outcome, columns, rows, player_id)
    end

    @safetestset "not in range" begin 
        using CantStop
        using CantStop: is_valid
        using Test

        game = Game()
        outcome = [1,2,3,4]
        columns = [2,7]
        rows = [1,2]
        player_id = :player 

        message = ErrorException("$columns is not a valid pair for $outcome")
    
        @test_throws message is_valid(game, outcome, columns, rows, player_id)
    end

    @safetestset "has been won" begin 
        using CantStop
        using CantStop: is_valid
        using Test

        game = Game()
        push!(game.columns[3][end], :player)
        outcome = [1,2,3,4]
        columns = [3,7]
        rows = [1,2]
        player_id = :player 

        message = ErrorException("$columns has been won")

        @test_throws message is_valid(game, outcome, columns, rows, player_id)
    end

    @safetestset "row length too large" begin 
        using CantStop
        using CantStop: is_valid
        using Test

        game = Game()
        outcome = [1,2,3,4]
        columns = [2,7,3]
        rows = [1,2,2]
        player_id = :player

        message = ErrorException("length of rows cannot exceed 2")
        @test_throws message is_valid(game, outcome, columns, rows, player_id)
    end

    @safetestset "row out of bounds" begin 
        using CantStop
        using CantStop: is_valid
        using Test

        game = Game()
        outcome = [1,2,3,4]
        columns = [3,7]
        rows = [4,2]
        player_id = :player
        message = ErrorException("rows $rows are not valid")

        @test_throws message is_valid(game, outcome, columns, rows, player_id)
    end

    @safetestset "non-contiguous runner row position" begin 
        using CantStop
        using CantStop: is_valid
        using Test

        game = Game()
        outcome = [1,2,3,4]
        columns = [3,7]
        rows = [2,2]
        player_id = :player
        message = ErrorException("rows $rows are not valid")

        @test_throws message is_valid(game, outcome, columns, rows, player_id)
    end

    @safetestset "wrong player_id" begin 
        using CantStop
        using CantStop: is_valid
        using Test

        game = Game()
        push!(game.columns[3][1], :wrong_player)
        outcome = [1,2,3,4]
        columns = [3,7]
        rows = [2,2]
        player_id = :player
        message = ErrorException("rows $rows are not valid")

        @test_throws message is_valid(game, outcome, columns, rows, player_id)
    end

    @safetestset "valid columns" begin 
        using CantStop
        using CantStop: is_valid
        using Test

        game = Game()
        push!(game.columns[3][1], :player)
        outcome = [1,2,3,4]
        columns = [3,7]
        rows = [2,1]
        player_id = :player

        @test is_valid(game, outcome, columns, rows, player_id)
    end
end

@safetestset "move!" begin 
    using CantStop
    using CantStop: move!
    using Test

    game = Game()
    c_idx = 3
    r_idx = 2
    column = game.columns[3]
    push!(column[1], :_runner)
    move!(game, c_idx, r_idx)

    for i ∈ 1:length(column)
        if i == r_idx 
            @test :_runner ∈ game.columns[c_idx][i]
        else
            @test :_runner ∉ game.columns[c_idx][i]
        end
    end
end
