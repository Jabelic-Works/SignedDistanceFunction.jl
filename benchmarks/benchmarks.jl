using DataFrames, CSV
include("../src/sdistance.jl") # 必ずダブルクオーテーション
include("../src/generate_data.jl") 
include("../src/draw.jl") 
import .Sdistance:main
import .Generate:get_mock_data
import .Draw:parformance_graphs

function _exe()
    # tmp = get_mock_data(1.5, 100)
    # df = DataFrame(x=tmp[:,1], y=tmp[:,2])
    # CSV.write("./src/circle.csv", df, writeheader=false)
    _execute_times = 3
    runtime = zeros(_execute_times, 2)
    for i = 1:_execute_times
        runtime[i,1] = main(100*i, 1, "./src/interface.csv")
        runtime[i,2] = main(100*i, 2, "./src/interface.csv")
    end
    N = [item*100 for item = 1:_execute_times]
    println(runtime, N)
    parformance_graphs(N, runtime)
    # main(parse(Int, ARGS[1]), parse(Int, ARGS[2]), "./src/circle.csv")
end

_exe()