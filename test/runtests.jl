using SignedDistanceFunction
using Test
using DelimitedFiles
include("../src/utils/utils.jl")
using .Utils

@testset "SignedDistanceFunction.jl" begin
    @test signedDistance2D("mock_csv_data/interface.csv", 300) == readdlm("result/interface_result_n300.csv", ',', Float64)
end


@testset "utils.jl" begin
    @test remove_equal_value_in_next_points([1 2; 2 3; 3 2; 3 2; 3 2; 1 2; 1 2]) == [1 2; 2 3; 3 2; 1 2]
    @test remove_equal_value_in_next_points([100 100; 10000 10000; 21.2 12.0]) == [100 100; 10000 10000; 21.2 12.0]
    @test remove_equal_value_in_next_points([10.112233 10.112233]) == [10.112233 10.112233]
    @test remove_equal_value_in_next_points([]) === nothing
end