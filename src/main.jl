using DataFrames, CSV
using Profile
include("./sdistance.jl") # 必ずダブルクオーテーション
include("./generate_data.jl")
include("./draw.jl")
import .Sdistance:main
import .Generate:get_mock_data
import .Draw:parformance_graphs

# tmp = get_mock_data(1.5, 100)
# df = DataFrame(x=tmp[:,1], y=tmp[:,2])
# CSV.write("./mock_csv_data/circle.csv", df, writeheader=false)

# === profiling ===

# @profile main(parse(Int, ARGS[1]), parse(Int, ARGS[2]), "./mock_csv_data/interface.csv")
# Profile.print()
# open("prof.txt", "w") do s
#     Profile.print(IOContext(s, :displaysize => (24, 500)))
# end

# === memory size === 

# p = @allocated main(parse(Int, ARGS[1]), parse(Int, ARGS[2]), "./mock_csv_data/interface.csv")
# p = @allocated main(parse(Int, ARGS[1]), parse(Int, ARGS[2]), "./mock_csv_data/infinity_shaped.csv", "multi")
# p = @allocated main(parse(Int, ARGS[1]), parse(Int, ARGS[2]), "./mock_csv_data/double_circle.csv", "multi")
p = @allocated main(parse(Int, ARGS[1]), parse(Int, ARGS[2]), "./mock_csv_data/multiple_curves.csv", "multi")
println("\nmemory size: ",p/(1024*1024), " MB")

# main(parse(Int, ARGS[1]), parse(Int, ARGS[2]), "./mock_csv_data/circle.csv")
