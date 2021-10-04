using DataFrames, CSV
include("./sdistance.jl") # 必ずダブルクオーテーション
include("./generate_data.jl") 
include("./draw.jl") 
import .Sdistance:main
import .Generate:get_mock_data
import .Draw:parformance_graphs

# tmp = get_mock_data(1.5, 100)
# df = DataFrame(x=tmp[:,1], y=tmp[:,2])
# CSV.write("./src/circle.csv", df, writeheader=false)
main(parse(Int, ARGS[1]), parse(Int, ARGS[2]), "./src/interface.csv")
# main(parse(Int, ARGS[1]), parse(Int, ARGS[2]), "./src/circle.csv")
