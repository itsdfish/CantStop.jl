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

@safetestset "is_valid_runner" begin

    @safetestset "unequal length" begin 
        using CantStop
        using CantStop: is_valid_runner
        using Test

        game = Game()
        push!(game.columns[2][end], :player)
        outcome = [1,2,3,4]
        columns = [2]
        rows = [1,2]
        player_id = :player 

        message = ErrorException("columns and rows do not have the same length")
        @test_throws  message is_valid_runner(game, outcome, columns, rows, player_id)
    end

    @safetestset "column error" begin 
        using CantStop
        using CantStop: is_valid_runner
        using Test

        game = Game()
        outcome = [1,2,3,4]
        columns = []
        rows = [1,2]
        player_id = :player 
        message = ErrorException("columns cannot be empty")

        @test_throws message is_valid_runner(game, outcome, columns, rows, player_id)
    end

    @safetestset "row empty error" begin 
        using CantStop
        using CantStop: is_valid_runner
        using Test

        game = Game()
        outcome = [1,2,3,4]
        columns = [3,7]
        rows = []
        player_id = :player 
        message = ErrorException("rows cannot be empty")

        @test_throws message is_valid_runner(game, outcome, columns, rows, player_id)
    end

    @safetestset "not in range" begin 
        using CantStop
        using CantStop: is_valid_runner
        using Test

        game = Game()
        outcome = [1,2,3,4]
        columns = [13,7]
        rows = [1,2]
        player_id = :player 

        message = ErrorException("$columns not in range") 

        @test_throws message is_valid_runner(game, outcome, columns, rows, player_id)
    end

    @safetestset "not in range" begin 
        using CantStop
        using CantStop: is_valid_runner
        using Test

        game = Game()
        outcome = [1,2,3,4]
        columns = [2,7]
        rows = [1,2]
        player_id = :player 

        message = ErrorException("$columns is not a valid pair for $outcome")
    
        @test_throws message is_valid_runner(game, outcome, columns, rows, player_id)
    end

    @safetestset "has been won" begin 
        using CantStop
        using CantStop: is_valid_runner
        using Test

        game = Game()
        push!(game.columns[3][end], :player)
        outcome = [1,2,3,4]
        columns = [3,7]
        rows = [1,2]
        player_id = :player 

        message = ErrorException("$columns has been won")

        @test_throws message is_valid_runner(game, outcome, columns, rows, player_id)
    end

    @safetestset "row length too large" begin 
        using CantStop
        using CantStop: is_valid_runner
        using Test

        game = Game()
        outcome = [1,2,3,4]
        columns = [2,7,3]
        rows = [1,2,2]
        player_id = :player

        message = ErrorException("length of rows cannot exceed 2")
        @test_throws message is_valid_runner(game, outcome, columns, rows, player_id)
    end

    @safetestset "row out of bounds" begin 
        using CantStop
        using CantStop: is_valid_runner
        using Test

        game = Game()
        outcome = [1,2,3,4]
        columns = [3,7]
        rows = [4,2]
        player_id = :player
        message = ErrorException("rows $rows are not valid")

        @test_throws message is_valid_runner(game, outcome, columns, rows, player_id)
    end

    @safetestset "non-contiguous runner row position" begin 
        using CantStop
        using CantStop: is_valid_runner
        using Test

        game = Game()
        outcome = [1,2,3,4]
        columns = [3,7]
        rows = [2,2]
        player_id = :player
        message = ErrorException("rows $rows are not valid")

        @test_throws message is_valid_runner(game, outcome, columns, rows, player_id)
    end

    @safetestset "wrong player_id" begin 
        using CantStop
        using CantStop: is_valid_runner
        using Test

        game = Game()
        push!(game.columns[3][1], :wrong_player)
        outcome = [1,2,3,4]
        columns = [3,7]
        rows = [2,2]
        player_id = :player
        message = ErrorException("rows $rows are not valid")

        @test_throws message is_valid_runner(game, outcome, columns, rows, player_id)
    end

    @safetestset "valid columns" begin 
        using CantStop
        using CantStop: is_valid_runner
        using Test

        game = Game()
        push!(game.columns[3][1], :player)
        outcome = [1,2,3,4]
        columns = [3,7]
        rows = [2,1]
        player_id = :player

        @test is_valid_runner(game, outcome, columns, rows, player_id)
    end
end

@safetestset "is_valid_move" begin

    @safetestset "incorrect column length" begin 
        using CantStop
        using CantStop: is_valid_move
        using Test

        game = Game()
        push!(game.columns[2][end], :player)
        outcome = [1,2,3,4]
        columns = [2]
        rows = [1,2]
        player_id = :player 

        message = ErrorException("length of row and column indices must be 2")
        @test_throws  message is_valid_move(game, outcome, columns, rows, player_id)
    end

    @safetestset "incorrect row length" begin 
        using CantStop
        using CantStop: is_valid_move
        using Test

        game = Game()
        push!(game.columns[2][end], :player)
        outcome = [1,2,3,4]
        columns = [2,3]
        rows = [1,2,4]
        player_id = :player 

        message = ErrorException("length of row and column indices must be 2")
        @test_throws  message is_valid_move(game, outcome, columns, rows, player_id)
    end

    @safetestset "not in range" begin 
        using CantStop
        using CantStop: is_valid_move
        using Test

        game = Game()
        outcome = [1,2,3,4]
        columns = [13,7]
        rows = [1,2]
        player_id = :player 

        message = ErrorException("$columns not in range") 

        @test_throws message is_valid_move(game, outcome, columns, rows, player_id)
    end

    @safetestset "not in range" begin 
        using CantStop
        using CantStop: is_valid_move
        using Test

        game = Game()
        outcome = [1,2,3,4]
        columns = [2,7]
        rows = [1,2]
        player_id = :player 

        message = ErrorException("$columns is not a valid pair for $outcome")
    
        @test_throws message is_valid_move(game, outcome, columns, rows, player_id)
    end

    @safetestset "has been won" begin 
        using CantStop
        using CantStop: is_valid_move
        using Test

        game = Game()
        push!(game.columns[3][end], :player)
        outcome = [1,2,3,4]
        columns = [3,7]
        rows = [1,2]
        player_id = :player 

        message = ErrorException("$columns has been won")

        @test_throws message is_valid_move(game, outcome, columns, rows, player_id)
    end

    @safetestset "row out of bounds" begin 
        using CantStop
        using CantStop: is_valid_move
        using Test

        game = Game()
        outcome = [1,2,3,4]
        columns = [3,7]
        rows = [4,2]
        player_id = :player
        message = ErrorException("rows $rows are not valid")

        @test_throws message is_valid_move(game, outcome, columns, rows, player_id)
    end

    @safetestset "non-contiguous runner row position" begin 
        using CantStop
        using CantStop: is_valid_move
        using Test

        game = Game()
        outcome = [1,2,3,4]
        columns = [3,7]
        rows = [2,2]
        player_id = :player
        message = ErrorException("rows $rows are not valid")

        @test_throws message is_valid_move(game, outcome, columns, rows, player_id)
    end

    @safetestset "wrong player_id" begin 
        using CantStop
        using CantStop: is_valid_move
        using Test

        game = Game()
        push!(game.columns[3][1], :wrong_player)
        outcome = [1,2,3,4]
        columns = [3,7]
        rows = [2,2]
        player_id = :player
        message = ErrorException("rows $rows are not valid")

        @test_throws message is_valid_move(game, outcome, columns, rows, player_id)
    end

    @safetestset "valid columns" begin 
        using CantStop
        using CantStop: is_valid_move
        using Test

        game = Game()
        push!(game.columns[3][1], :player)
        outcome = [1,2,3,4]
        columns = [3,7]
        rows = [2,1]
        player_id = :player

        @test is_valid_move(game, outcome, columns, rows, player_id)
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

@safetestset "replace_runners!" begin 
    using CantStop
    using CantStop: replace_runners!
    using Test

    game = Game()
    player_id = :player
    c_idx = 3
    r_idx = 2
    columns = game.columns

    push!(columns[c_idx][r_idx], :_runner)
    push!(game.c_idx, c_idx)
    push!(game.r_idx, r_idx)

    c_idx1 = 4
    r_idx1 = 5
    push!(columns[c_idx1][r_idx1], player_id)

    replace_runners!(game, player_id)

    for c ∈ keys(columns)
        for r ∈ 1:length(columns[c])
            if (r == r_idx) && (c == c_idx)
                @test player_id ∈ columns[c][r]
            elseif (r == r_idx1) && (c == c_idx1)
                @test player_id ∈ columns[c][r]
            else
                @test :_runner ∉ columns[c][r]
            end
        end
    end
end

@safetestset "remove_pieces!" begin 
    using CantStop
    using CantStop: remove_pieces!
    using Test

    game = Game()
    player_id = :player
    c_idx = 3
    r_idx = 2
    columns = game.columns

    push!(columns[c_idx][r_idx], player_id)
    push!(game.c_idx, c_idx)
    push!(game.r_idx, r_idx)

    c_idx1 = 4
    r_idx1 = 5
    player_id1 = :player1
    push!(columns[c_idx1][r_idx1], player_id1)

    remove_pieces!(game, player_id)

    for c ∈ keys(columns)
        for r ∈ 1:length(columns[c])
            if (r == r_idx1) && (c == c_idx1)
                @test player_id1 ∈ columns[c][r]
            else
                @test player_id ∉ columns[c][r]
            end
        end
    end
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

@safetestset "is_over" begin
    @safetestset "1" begin 
        using CantStop
        using CantStop: is_over
        using Test

        game = Game()
        columns = game.columns 

        push!(columns[2][end], :player1)
        push!(columns[3][end], :player1)
        push!(columns[4][end], :player1)

        @test is_over(game)
    end

    @safetestset "2" begin 
        using CantStop
        using CantStop: is_over
        using Test

        game = Game()
        columns = game.columns 

        push!(columns[2][end], :player1)
        push!(columns[3][end-1], :player1)
        push!(columns[4][end], :player1)

        @test !is_over(game)
    end

    @safetestset "3" begin 
        using CantStop
        using CantStop: is_over
        using Test

        game = Game()
        columns = game.columns 

        push!(columns[3][end], :player1)
        push!(columns[3][end], :player1)
        push!(columns[4][end], :player3)

        @test !is_over(game)
    end
end