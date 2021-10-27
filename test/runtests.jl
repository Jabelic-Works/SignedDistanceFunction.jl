using LevelSet
using Test
using DelimitedFiles

@testset "LevelSet.jl" begin
    @test signedDistance2D("mock_csv_data/interface.csv", 100) == readdlm("result/interface_result.csv", ',', Float64)
    @test signedDistance2D("mock_csv_data/multiple_curves.csv", 100, "multi") == readdlm("result/multiple_curves_result.csv", ',', Float64)
end
