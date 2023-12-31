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

    outcome = [1,2,3,4]
    columns = []

    @test !is_playing(outcome, columns)

    outcome = [1,2,3,4]
    columns = [30,40]

    @test !is_playing(outcome, columns)

    outcome = [1,2,3,4]
    columns = [3,30]

    @test is_playing(outcome, columns)
end
