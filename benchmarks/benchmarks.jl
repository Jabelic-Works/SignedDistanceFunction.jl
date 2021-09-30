using DataFrames, CSV
include("../src/sdistance.jl") # 必ずダブルクオーテーション
include("../src/generate_data.jl") 
include("../src/draw.jl") 
import .Sdistance:main
import .Generate:get_mock_data
import .Draw:parformance_graphs

function _exe()
    # _execute_times = ARGS[1] ? parse(Int, ARGS[1]) : 3
    _execute_times = parse(Int, ARGS[1])

    runtime = zeros(_execute_times+1, 2)
    for i = 0:_execute_times
        runtime[i+1,1] = main(100 + 50*i, 1, "./src/interface.csv")
        runtime[i+1,2] = main(100 + 50*i, 2, "./src/interface.csv")
    end
    N = [100 + 50*item for item = 0:_execute_times]
    # println(runtime, N)
    parformance_graphs(N, runtime)
end

_exe()