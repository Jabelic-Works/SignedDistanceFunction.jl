using DataFrames, CSV
using Profile
include("./sdistance.jl") # 必ずダブルクオーテーション
include("./draw.jl")
include("./LevelSet.jl")
include("./environments.jl")
import .Sdistance:computing_bench
import .Draw:parformance_graphs
using .LevelSet

# This script run by test.sh

# === profiling ===

# @profile signedDistance2D("./test/mock_csv_data/interface.csv",parse(Int, ARGS[1])) 
# @profile signedDistance2D("./test/mock_csv_data/interface.csv",parse(Int, ARGS[1]), "multi")
# Profile.print()
# open("prof.txt", "w") do s
#     Profile.print(IOContext(s, :displaysize => (24, 500)))
# end

# === memory size === 
println(JULIA_MULTI_PROCESS)
# p = @allocated computing_bench(parse(Int, ARGS[1]), "./test/mock_csv_data/interface.csv")
# p = @allocated signedDistance2D("./test/mock_csv_data/interface.csv", parse(Int, ARGS[1]), "multi")
# p =  signedDistance2D("./test/mock_csv_data/interface.csv", parse(Int, ARGS[1]))
p = @allocated computing_bench(parse(Int, ARGS[1]), "./test/mock_csv_data/interface.csv", "multi")
# p = @allocated computing_bench(parse(Int, ARGS[1]), "./test/mock_csv_data/interface3.csv","multi")
# p = @allocated computing_bench(parse(Int, ARGS[1]), "./test/mock_csv_data/mini_interface.csv", "multi")
# p = @allocated computing_bench(parse(Int, ARGS[1]), "./test/mock_csv_data/infinity_shaped.csv", "multi")
# p = @allocated computing_bench(parse(Int, ARGS[1]), "./test/mock_csv_data/double_circle.csv", "multi")
# p = @allocated computing_bench(parse(Int, ARGS[1]), "./test/mock_csv_data/multiple_curves.csv", "multi")
# p = signedDistance2D( "./test/mock_csv_data/multiple_curves.csv", parse(Int, ARGS[1]), "multi")

# DataFrame(p, :auto) |> CSV.write("./test/result/interface_result_n500.csv", header=false)
# println("\nmemory size: ",p/(1024*1024), " MB")
