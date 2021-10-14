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
# CSV.write("./src/circle.csv", df, writeheader=false)

# === profiling ===

# @profile main(parse(Int, ARGS[1]), parse(Int, ARGS[2]), "./src/interface.csv")
# Profile.print()
# open("prof.txt", "w") do s
#     Profile.print(IOContext(s, :displaysize => (24, 500)))
# end

# === memory size === 

p = @allocated main(parse(Int, ARGS[1]), parse(Int, ARGS[2]), "./src/interface.csv")
# p = @allocated main(parse(Int, ARGS[1]), parse(Int, ARGS[2]), "./src/infinity_shaped.csv")
# p = @allocated main(parse(Int, ARGS[1]), parse(Int, ARGS[2]), "./src/double_circle.csv")
println("memory size: ",p, )

# main(parse(Int, ARGS[1]), parse(Int, ARGS[2]), "./src/circle.csv")
