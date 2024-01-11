using SafeTestsets


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