using DataFrames, CSV
include("../src/sdistance.jl") # 必ずダブルクオーテーション
include("../src/draw.jl") 
include("../src/LevelSet.jl") 
import .Sdistance:computing_bench
using .LevelSet
import .Draw:parformance_graphs

function _exe()
    # _execute_times = ARGS[1] ? parse(Int, ARGS[1]) : 3
    _execute_times = parse(Int, ARGS[1])
    _phi = []
    runtime = zeros(_execute_times+1, 2)
    for i = 0:_execute_times
        _phi, runtime[i+1,1] = @timed computing_bench(300 + 200*i, 1, "./test/mock_csv_data/interface.csv")
        # signedDistance2D("./test/mock_csv_data/interface.csv",300 + 200*i)
        _phi, runtime[i+1,2] = @timed computing_bench(300 + 200*i, 2, "./test/mock_csv_data/interface.csv")
    end
    N = [300 + 200*item for item = 0:_execute_times]
    println(N, runtime)
    parformance_graphs(N, runtime)
end

_exe()

#==
N2300:  300+200i, ARG = 10
 [300, 500, 700, 900, 1100, 1300, 1500, 1700, 1900, 2100, 2300]
 [2.727736517 1.549037993; 2.430711433 4.540753791; 
 4.87217261 8.72733049; 6.970006918 11.296165896; 
 10.919117877 16.429877231; 15.524662846 28.576650596; 
 20.630861499 38.540759007; 26.182433943 51.252256581; 
 33.966169503 64.128344396; 40.489381557 75.419365612; 
 50.053971199 91.594363467]
 ==#
