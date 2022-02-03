using DataFrames, CSV
include("../src/sdistance.jl") # 必ずダブルクオーテーション
include("../test/draw.jl")
include("../src/SignedDistanceFunction.jl")
import .Sdistance: benchmark_floodfill, benchmark_singlecurves_isinside #,signedDistance2D
using .SignedDistanceFunction
import .Draw: parformance_graphs

@enum ExecuteKinds _multicurves _singlecurve _singlecurve_floodfill

function _exe(kinds)
    _execute_times = 2
    _phi = []
    init_N = 100
    increment_N = 200
    runtime = zeros(_execute_times + 1, 2)
    N = [init_N + increment_N * item for item = 0:_execute_times]
    if kinds == 1
        for i = 0:_execute_times
            runtime[i+1, 1] = benchmark_floodfill(init_N + increment_N * i, "./test/mock_csv_data/multiple_curves.csv")
            runtime[i+1, 2] = benchmark_floodfill(init_N + increment_N * i, "./test/mock_csv_data/multiple_curves.csv", false)
        end
        parformance_graphs(N, runtime, "multiple_curves", ["Parallel processing", "Normal processing"])
    elseif kinds == 2
        for i = 0:_execute_times
            runtime[i+1, 1] = benchmark_floodfill(init_N + increment_N * i, "./test/mock_csv_data/interface.csv")
            runtime[i+1, 2] = benchmark_floodfill(init_N + increment_N * i, "./test/mock_csv_data/interface.csv", false)
        end
        parformance_graphs(N, runtime, "interface_floodfill", ["Parallel processing", "Normal processing"])
    elseif kinds == 3
        for i = 0:_execute_times
            runtime[i+1, 1] = benchmark_singlecurves_isinside(init_N + increment_N * i, "./test/mock_csv_data/interface.csv")
            runtime[i+1, 2] = benchmark_singlecurves_isinside(init_N + increment_N * i, "./test/mock_csv_data/interface.csv", false)
        end
        parformance_graphs(N, runtime, "the jordan curve", ["Parallel processing", "Normal processing"])
    end
end

# _exe(1)
# _exe(2)
_exe(3)

#==
Jabelic test it and get it as below.

N2300:  300+200i, ARG = 10
 [300, 500, 700, 900, 1100, 1300, 1500, 1700, 1900, 2100, 2300]
 [2.727736517 1.549037993; 2.430711433 4.540753791; 
 4.87217261 8.72733049; 6.970006918 11.296165896; 
 10.919117877 16.429877231; 15.524662846 28.576650596; 
 20.630861499 38.540759007; 26.182433943 51.252256581; 
 33.966169503 64.128344396; 40.489381557 75.419365612; 
 50.053971199 91.594363467]

300+200i, ARG = 3, interface  multi-thread, single-thread
 [2.402844242 1.564786665; 2.415855251 4.372297246; 4.636160664 9.164722692; 7.243630318 11.635953353]
signedDistance2D, 300+200i, ARG = 3, interface, multi-thread only. jordan_curve(using isinside), multi_curves(using floodfill)
 [2.126074484 13.096371426; 2.496373027 125.23088408; 5.242287246 596.261015286; 7.987274914 1743.300632586]


1-3-500, interface, inpolygon
[100, 300, 500]
[1.248799153 0.530269039; 2.28104107 4.735589021; 6.293578857 11.423713058]
32

1-3-500, interface, Floodfill
[100, 300, 500][1.291998074 0.123935482; 3.388728651 5.878153884; 69.895109677 84.980423578]
32

1-3-500, multi_curves, Floodfill
[100, 300, 500][2.400877896 2.741995989; 38.038218511 92.339324457; 476.64809553 833.91326708]
32

1-3-500, multi_curves, Floodfill
[100, 300, 500][0.5009443733333333 0.891537955; 12.114947880666668 28.633708910333336; 133.44351538533337 261.82990826500003]

 ==#
