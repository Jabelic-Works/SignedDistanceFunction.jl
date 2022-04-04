using SignedDistanceFunction
using Test
using DelimitedFiles
include("../src/utils/utils.jl")
using .Utils

@testset "SignedDistanceFunction.jl" begin
    @test signedDistance2D("mock_csv_data/interface.csv", 300) == readdlm("result/interface_result_n300.csv", ',', Float64)
end


@testset "utils.jl" begin
    @test remove_same_point([1 2; 2 3; 3 2; 3 2; 3 2; 1 2; 1 2]) == [1 2; 2 3; 3 2; 1 2]
end