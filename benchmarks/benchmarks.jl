using DataFrames, CSV
include("../src/sdistance.jl") # 必ずダブルクオーテーション
include("../src/draw.jl") 
include("../src/LevelSet.jl") 
import .Sdistance:computing_bench #,signedDistance2D
 using .LevelSet
import .Draw:parformance_graphs

function _exe()
    # _execute_times = ARGS[1] ? parse(Int, ARGS[1]) : 3
    _execute_times = parse(Int, ARGS[1])
    _phi = []
    init_N = 300
    increment_N = 100
    runtime = zeros(_execute_times+1, 2)
    for i = 0:_execute_times
        _phi, runtime[i+1,1] = @timed computing_bench(init_N + increment_N*i, 1, "./test/mock_csv_data/interface.csv")
        _phi, runtime[i+1,2] = @timed computing_bench(init_N + increment_N*i, 2, "./test/mock_csv_data/interface.csv")
        # _phi, runtime[i+1,3] = @timed computing_bench(init_N + increment_N*i, 1, "./test/mock_csv_data/interface.csv", "multi")
        # _phi, runtime[i+1,4] = @timed computing_bench(init_N + increment_N*i, 2, "./test/mock_csv_data/interface.csv", "multi")
        # _phi, runtime[i+1,1] = @timed signedDistance2D("./test/mock_csv_data/interface.csv",init_N + increment_N*i)
        # _phi, runtime[i+1,2] = @timed signedDistance2D("./test/mock_csv_data/interface.csv",init_N + increment_N*i, "multi")
    end
    N = [init_N + increment_N*item for item = 0:_execute_times]
    println(N, runtime)
    parformance_graphs(N, runtime, "interface", ["Parallel processing","Normal processing"])
    # parformance_graphs(N, runtime, "interface", ["the jordan curve","multi curves"])
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

computing_bench, 300+200i, ARG = 3, interface  multi-thread, single-thread
 [2.402844242 1.564786665; 2.415855251 4.372297246; 4.636160664 9.164722692; 7.243630318 11.635953353]
signedDistance2D, 300+200i, ARG = 3, interface, multi-thread only. jordan_curve(using isinside), multi_curves(using floodfill)
 [2.126074484 13.096371426; 2.496373027 125.23088408; 5.242287246 596.261015286; 7.987274914 1743.300632586]
 ==#
