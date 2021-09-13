using DataFrames, CSV
include("./sdistance.jl") # 必ずダブルクオーテーション
include("./generate_data.jl") 
import .Sdistance:main
import .Generate:get_mock_data
tmp = get_mock_data(1.5, 100)
df = DataFrame(x=tmp[:,1], y=tmp[:,2])
CSV.write("circle.csv", df, writeheader=false)
# main(parse(Int, ARGS[1]), parse(Int, ARGS[2]), "./interface.csv")
main(parse(Int, ARGS[1]), parse(Int, ARGS[2]), "./circle.csv")
