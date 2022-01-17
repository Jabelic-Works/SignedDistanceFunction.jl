using DataFrames, CSV
using Profile
include("../src/sdistance.jl") # 必ずダブルクオーテーション
include("../test/draw.jl")
include("../src/SignedDistance.jl")
include("../src/environments.jl")
include("../test/APT.jl")
# include("../test/testPlots.jl")
import .Draw: parformance_graphs
using .SignedDistance
using .APT

# This script run by test.sh

# ====== Application product testing ======
# p = computing_bench(parse(Int, ARGS[1]), "./test/mock_csv_data/interface.csv")
# p = computing_bench(parse(Int, ARGS[1]), "./test/mock_csv_data/interface.csv", "multi")
# p = computing_bench(parse(Int, ARGS[1]), "./test/mock_csv_data/multiple_curves.csv", "multi")
# plots_contours([i for i = 50:50:300], "./test/mock_csv_data/interface.csv", "multi")
# plots_contours([i for i = 50:50:300], "./test/mock_csv_data/interface.csv")
# plots_wireframe([i for i = 50:50:300], "./test/mock_csv_data/interface.csv", "multi")


# ====== Debug ======
p = signedDistance2D("./test/mock_csv_data/interface.csv", parse(Int, ARGS[1]))
# DataFrame(p, :auto) |> CSV.write("./test/result/interface_result_n"*ARGS[1]*".csv", header=false)
# p = signedDistance2D("./test/mock_csv_data/interface.csv", parse(Int, ARGS[1]), "multi")
# DataFrame(p, :auto) |> CSV.write("./test/result/interface_floodfill_result_n"*ARGS[1]*".csv", header=false)
# p = signedDistance2D("./test/mock_csv_data/multiple_curves.csv", parse(Int, ARGS[1]), "multi")
# DataFrame(p, :auto) |> CSV.write("./test/result/multiple_curves_result_n"*ARGS[1]*".csv", header=false)


# ====== profiling =======

# @profile signedDistance2D("./test/mock_csv_data/interface.csv",parse(Int, ARGS[1])) 
# @profile signedDistance2D("./test/mock_csv_data/interface.csv",parse(Int, ARGS[1]), "multi")
# Profile.print()
# open("prof.txt", "w") do s
#     Profile.print(IOContext(s, :displaysize => (24, 500)))
# end

# ====== memory size =======
# p = @allocated signedDistance2D("./test/mock_csv_data/interface.csv", parse(Int, ARGS[1]), "multi")
# println("\nmemory size: ",p/(1024*1024), " MB")
# p = @allocated computing_bench(parse(Int, ARGS[1]), "./test/mock_csv_data/interface.csv", "multi")
# q = signedDistance2D( "./test/mock_csv_data/multiple_curves.csv", parse(Int, ARGS[1]), "multi")
# println("\nmemory size: ",p/(1024*1024), " MB")



