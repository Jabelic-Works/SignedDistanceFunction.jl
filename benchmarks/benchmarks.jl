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
    # NOTE: N is for image size(N x N)
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

