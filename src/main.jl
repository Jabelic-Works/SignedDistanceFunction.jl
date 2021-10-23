using DataFrames, CSV
using Profile
include("./sdistance.jl") # 必ずダブルクオーテーション
include("./draw.jl")
import .Sdistance:main
import .Draw:parformance_graphs

# === profiling ===

# @profile main(parse(Int, ARGS[1]), parse(Int, ARGS[2]), "./mock_csv_data/interface.csv")
# Profile.print()
# open("prof.txt", "w") do s
#     Profile.print(IOContext(s, :displaysize => (24, 500)))
# end

# === memory size === 

p = @allocated main(parse(Int, ARGS[1]), parse(Int, ARGS[2]), "./test/mock_csv_data/interface.csv")
# p = @allocated main(parse(Int, ARGS[1]), parse(Int, ARGS[2]), "./test/mock_csv_data/infinity_shaped.csv", "multi")
# p = @allocated main(parse(Int, ARGS[1]), parse(Int, ARGS[2]), "./test/mock_csv_data/double_circle.csv", "multi")
# p = @allocated main(parse(Int, ARGS[1]), parse(Int, ARGS[2]), "./test/mock_csv_data/multiple_curves.csv", "multi")
println("\nmemory size: ",p/(1024*1024), " MB")
