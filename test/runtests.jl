using SafeTestsets

@safetestset "is_combination" begin
    using CantStop: is_combination
    using Test

    outcome = [1,2,3,4]
    c_idx = [3,4]

    @test is_combination(outcome, c_idx; fun = any)
    @test is_combination(outcome, c_idx; fun = all)

    outcome = [1,2,3,4]
    c_idx = [3,40]

    @test is_combination(outcome, c_idx; fun = any)
    @test !is_combination(outcome, c_idx; fun = all)

    outcome = [1,2,3,4]
    c_idx = [20,40]

    @test !is_combination(outcome, c_idx; fun = any)
    @test !is_combination(outcome, c_idx; fun = all)
end

@safetestset "is_bust" begin
    using CantStop: is_bust
    using Test

    outcome = [1,2,3,4]
    c_idx = [3,4]

    @test !is_bust(outcome, c_idx)

    outcome = [1,2,3,4]
    c_idx = [30,40]

    @test is_bust(outcome, c_idx)

    outcome = [1,2,3,4]
    c_idx = [1,30]

    @test is_bust(outcome, c_idx)
end

@safetestset "validate_runner" begin

    @safetestset "unequal length" begin 
        using CantStop
        using CantStop: validate_runner
        using Test

        game = Game()
        
        push!(game.board[2][end], :player)
        outcome = [1,2,3,4]
        c_idx = [2]
        rows = [1,2]
        player_id = :player 
        game.pieces[player_id] = fill(player_id, 12)

        message = ErrorException("columns and rows do not have the same length")
        @test_throws  message validate_runner(game, outcome, c_idx, rows, player_id)
    end

    @safetestset "column error" begin 
        using CantStop
        using CantStop: validate_runner
        using Test

        game = Game()
        outcome = [1,2,3,4]
        c_idx = []
        rows = [1,2]
        player_id = :player 
        game.pieces[player_id] = fill(player_id, 12)

        message = ErrorException("columns cannot be empty")

        @test_throws message validate_runner(game, outcome, c_idx, rows, player_id)
    end

    @safetestset "row empty error" begin 
        using CantStop
        using CantStop: validate_runner
        using Test

        game = Game()
        outcome = [1,2,3,4]
        c_idx = [3,7]
        rows = []
        player_id = :player 
        game.pieces[player_id] = fill(player_id, 12)
        message = ErrorException("rows cannot be empty")

        @test_throws message validate_runner(game, outcome, c_idx, rows, player_id)
    end

    @safetestset "not in range" begin 
        using CantStop
        using CantStop: validate_runner
        using Test

        game = Game()
        outcome = [1,2,3,4]
        c_idx = [13,7]
        rows = [1,2]
        player_id = :player 
        game.pieces[player_id] = fill(player_id, 12)

        message = ErrorException("$c_idx not in range") 

        @test_throws message validate_runner(game, outcome, c_idx, rows, player_id)
    end

    @safetestset "not in range" begin 
        using CantStop
        using CantStop: validate_runner
        using Test

        game = Game()
        outcome = [1,2,3,4]
        c_idx = [2,7]
        rows = [1,2]
        player_id = :player 
        game.pieces[player_id] = fill(player_id, 12)

        message = ErrorException("$c_idx is not a valid pair for $outcome")
    
        @test_throws message validate_runner(game, outcome, c_idx, rows, player_id)
    end

    @safetestset "valid columns" begin 
        using CantStop
        using CantStop: validate_runner
        using Test

        game = Game()
        push!(game.board[3][1], :player)
        outcome = [1,2,3,4]
        c_idx = [3,7]
        rows = [2,1]
        player_id = :player
        game.pieces[player_id] = fill(player_id, 1)

        message = ErrorException("Insufficent pieces remaining. Use active piece.")
    
        @test_throws message validate_runner(game, outcome, c_idx, rows, player_id)
    end

    @safetestset "has been won" begin 
        using CantStop
        using CantStop: validate_runner
        using Test

        game = Game()
        push!(game.board[3][end], :player)
        outcome = [1,2,3,4]
        c_idx = [3,7]
        rows = [1,2]
        player_id = :player 
        game.pieces[player_id] = fill(player_id, 12)

        message = ErrorException("$c_idx has been won")

        @test_throws message validate_runner(game, outcome, c_idx, rows, player_id)
    end

    @safetestset "row length too large" begin 
        using CantStop
        using CantStop: validate_runner
        using Test

        game = Game()
        outcome = [1,2,3,4]
        c_idx = [2,7,3]
        rows = [1,2,2]
        player_id = :player
        game.pieces[player_id] = fill(player_id, 12)

        message = ErrorException("length of rows cannot exceed 2")
        @test_throws message validate_runner(game, outcome, c_idx, rows, player_id)
    end

    @safetestset "row out of bounds" begin 
        using CantStop
        using CantStop: validate_runner
        using Test

        game = Game()
        outcome = [1,2,3,4]
        c_idx = [3,7]
        rows = [4,2]
        player_id = :player
        game.pieces[player_id] = fill(player_id, 12)

        message = ErrorException("rows $rows are not valid")
        
        @test_throws message validate_runner(game, outcome, c_idx, rows, player_id)
    end

    @safetestset "non-contiguous runner row position" begin 
        using CantStop
        using CantStop: validate_runner
        using Test

        game = Game()
        outcome = [1,2,3,4]
        c_idx = [3,7]
        rows = [2,2]
        player_id = :player
        game.pieces[player_id] = fill(player_id, 12)
        message = ErrorException("rows $rows are not valid")

        @test_throws message validate_runner(game, outcome, c_idx, rows, player_id)
    end

    @safetestset "wrong player_id" begin 
        using CantStop
        using CantStop: validate_runner
        using Test

        game = Game()
        push!(game.board[3][1], :wrong_player)
        outcome = [1,2,3,4]
        c_idx = [3,7]
        rows = [2,2]
        player_id = :player
        game.pieces[player_id] = fill(player_id, 12)

        message = ErrorException("rows $rows are not valid")

        @test_throws message validate_runner(game, outcome, c_idx, rows, player_id)
    end

    @safetestset "valid columns" begin 
        using CantStop
        using CantStop: validate_runner
        using Test

        game = Game()
        push!(game.board[3][1], :player)
        outcome = [1,2,3,4]
        c_idx = [3,7]
        rows = [2,1]
        player_id = :player
        game.pieces[player_id] = fill(player_id, 12)

        @test validate_runner(game, outcome, c_idx, rows, player_id)
    end

    @safetestset "too many runners" begin 
        using CantStop
        using CantStop: validate_runner
        using CantStop: add_runners!
        using Test
    
        game = Game()
        push!(game.board[3][1], :player)
        outcome = [1,2,3,4]
        c_idx = [3,7]
        r_idx = [2,1]
        player_id = :player
        game.pieces[player_id] = fill(player_id, 12)
    
        @test validate_runner(game, outcome, c_idx, r_idx, player_id)
        add_runners!(game, c_idx, r_idx)
    
        outcome = [1,1,2,2]
        c_idx = [2,4]
        r_idx = [1,1]
        message = ErrorException("Too many runners. You may only have 3 runners.")
        @test_throws message validate_runner(game, outcome, c_idx, r_idx, player_id)
    end
end

@safetestset "validate_move" begin

    @safetestset "incorrect column length" begin 
        using CantStop
        using CantStop: validate_move
        using Test

        game = Game()
        push!(game.board[2][end], :player)
        outcome = [1,2,3,4]
        c_idx = [2]
        rows = [1,2]
        player_id = :player 

        message = ErrorException("length of row and column indices must be 2")
        @test_throws  message validate_move(game, outcome, c_idx, rows, player_id)
    end

    @safetestset "incorrect row length" begin 
        using CantStop
        using CantStop: validate_move
        using Test

        game = Game()
        push!(game.board[2][end], :player)
        outcome = [1,2,3,4]
        c_idx = [2,3]
        rows = [1,2,4]
        player_id = :player 

        message = ErrorException("length of row and column indices must be 2")
        @test_throws  message validate_move(game, outcome, c_idx, rows, player_id)
    end

    @safetestset "not in range" begin 
        using CantStop
        using CantStop: validate_move
        using Test

        game = Game()
        outcome = [1,2,3,4]
        c_idx = [13,7]
        rows = [1,2]
        player_id = :player 

        message = ErrorException("$c_idx not in range") 

        @test_throws message validate_move(game, outcome, c_idx, rows, player_id)
    end

    @safetestset "not in range" begin 
        using CantStop
        using CantStop: validate_move
        using Test

        game = Game()
        outcome = [1,2,3,4]
        c_idx = [2,7]
        rows = [1,2]
        player_id = :player 

        message = ErrorException("$c_idx is not a valid pair for $outcome")
    
        @test_throws message validate_move(game, outcome, c_idx, rows, player_id)
    end

    @safetestset "has been won" begin 
        using CantStop
        using CantStop: validate_move
        using Test

        game = Game()
        push!(game.board[3][end], :player)
        outcome = [1,2,3,4]
        c_idx = [3,7]
        rows = [1,2]
        player_id = :player 

        message = ErrorException("$c_idx has been won")

        @test_throws message validate_move(game, outcome, c_idx, rows, player_id)
    end

    @safetestset "row out of bounds" begin 
        using CantStop
        using CantStop: validate_move
        using Test

        game = Game()
        outcome = [1,2,3,4]
        c_idx = [3,7]
        rows = [4,2]
        player_id = :player
        message = ErrorException("rows $rows are not valid")

        @test_throws message validate_move(game, outcome, c_idx, rows, player_id)
    end

    @safetestset "non-contiguous runner row position" begin 
        using CantStop
        using CantStop: validate_move
        using Test

        game = Game()
        outcome = [1,2,3,4]
        c_idx = [3,7]
        rows = [2,2]
        player_id = :player
        message = ErrorException("rows $rows are not valid")

        @test_throws message validate_move(game, outcome, c_idx, rows, player_id)
    end

    @safetestset "wrong player_id" begin 
        using CantStop
        using CantStop: validate_move
        using Test

        game = Game()
        push!(game.board[3][1], :wrong_player)
        outcome = [1,2,3,4]
        c_idx = [3,7]
        rows = [2,2]
        player_id = :player
        message = ErrorException("rows $rows are not valid")

        @test_throws message validate_move(game, outcome, c_idx, rows, player_id)
    end

    @safetestset "valid columns" begin 
        using CantStop
        using CantStop: validate_move
        using Test

        game = Game()
        push!(game.board[3][1], :player)
        outcome = [1,2,3,4]
        c_idx = [3,7]
        rows = [2,1]
        player_id = :player

        @test validate_move(game, outcome, c_idx, rows, player_id)
    end
end

@safetestset "move!" begin 
    using CantStop
    using CantStop: move!
    using Test

    game = Game()
    c_idx = 3
    r_idx = 2
    column = game.board[3]
    push!(column[1], :_runner)
    move!(game, c_idx, r_idx)

    for i ∈ 1:length(column)
        if i == r_idx 
            @test :_runner ∈ game.board[c_idx][i]
        else
            @test :_runner ∉ game.board[c_idx][i]
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
    board = game.board

    push!(board[c_idx][r_idx], :_runner)
    push!(game.c_idx, c_idx)
    push!(game.r_idx, r_idx)

    c_idx1 = 4
    r_idx1 = 5
    push!(board[c_idx1][r_idx1], player_id)

    replace_runners!(game, player_id)

    for c ∈ keys(board)
        for r ∈ 1:length(board[c])
            if (r == r_idx) && (c == c_idx)
                @test player_id ∈ board[c][r]
            elseif (r == r_idx1) && (c == c_idx1)
                @test player_id ∈ board[c][r]
            else
                @test :_runner ∉ board[c][r]
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
    board = game.board

    push!(board[c_idx][r_idx], player_id)
    push!(game.c_idx, c_idx)
    push!(game.r_idx, r_idx)

    c_idx1 = 4
    r_idx1 = 5
    player_id1 = :player1
    push!(board[c_idx1][r_idx1], player_id1)

    remove_pieces!(game, player_id)

    for c ∈ keys(board)
        for r ∈ 1:length(board[c])
            if (r == r_idx1) && (c == c_idx1)
                @test player_id1 ∈ board[c][r]
            else
                @test player_id ∉ board[c][r]
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
        using CantStop: is_playing
        using Test

        game = Game()
        board = game.board 

        push!(board[2][end], :player1)
        push!(board[3][end], :player1)
        push!(board[4][end], :player1)

        @test !is_playing(game)
    end

    @safetestset "2" begin 
        using CantStop
        using CantStop: is_playing
        using Test

        game = Game()
        board = game.board 

        push!(board[2][end], :player1)
        push!(board[3][end-1], :player1)
        push!(board[4][end], :player1)

        @test is_playing(game)
    end

    @safetestset "3" begin 
        using CantStop
        using CantStop: is_playing
        using Test

        game = Game()
        board = game.board 

        push!(board[3][end], :player1)
        push!(board[3][end], :player1)
        push!(board[4][end], :player3)

        @test is_playing(game)
    end
end

@safetestset "return_to_reserve!" begin 
    using CantStop
    using CantStop: return_to_reserve!
    using Test

    game = Game()
    player_id = :p1
    game.pieces[player_id] = fill(player_id, 9)
    push!(game.piece_reserve, fill(player_id, 3)...)

    return_to_reserve!(game, player_id)

    @test length(game.pieces[player_id]) == 12
    @test isempty(game.piece_reserve)
end

@safetestset "add_pieces_to_reserve!" begin 
    using CantStop
    using CantStop: add_pieces_to_reserve!
    using Test

    game = Game()
    player_id = :p1
    c_idx = [1,2]
    r_idx = [1,2]
    game.pieces[player_id] = fill(player_id, 12)

    add_pieces_to_reserve!(game, player_id, c_idx, r_idx)

    @test length(game.pieces[player_id]) == 11
    @test length(game.piece_reserve) == 1
end

# @safetestset "add_runners!" begin 
#     using CantStop
#     using CantStop: validate_runner
#     using Test

#     game = Game()
#     push!(game.board[3][1], :player)
#     outcome = [1,2,3,4]
#     c_idx = [3,7]
#     rows = [2,1]
#     player_id = :player
#     game.pieces[player_id] = fill(player_id, 12)

#     @test validate_runner(game, outcome, c_idx, rows, player_id)
#     add_runners!(game, c_idx, r_idx)

#     outcome = [1,1,2,2]
#     c_idx = [2,4]
#     rows = [1,1]
#     message = Message("Too many runners. You may only have 3 runners.")
#     validate_runner(game, outcome, c_idx, rows, player_id)
# end