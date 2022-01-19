using DataFrames, CSV
using Profile
include("../src/sdistance.jl") # 必ずダブルクオーテーション
include("../test/draw.jl")
include("../src/SignedDistanceFunction.jl")
include("../src/environments.jl")
include("../test/APT.jl")
import .Draw: parformance_graphs
using .SignedDistanceFunction
using .APT

# ====== Application product testing ======
# p = plot_for_debug(parse(Int, ARGS[2]), "./test/mock_csv_data/interface.csv")
# p = plot_for_debug(parse(Int, ARGS[2]), "./test/mock_csv_data/circle.csv")
# p = plot_for_debug(parse(Int, ARGS[2]), "./test/mock_csv_data/interface.csv", "multi")
p = plot_for_debug(parse(Int, ARGS[2]), "./test/mock_csv_data/multiple_curves.csv", "multi")
# p = plot_for_debug(parse(Int, ARGS[2]), "./test/mock_csv_data/double_circle.csv", "multi")
# plots_contours([i for i = 50:50:300], "./test/mock_csv_data/interface.csv", "multi")
# plots_contours([i for i = 50:50:300], "./test/mock_csv_data/interface.csv")
# plots_wireframe([i for i = 50:50:300], "./test/mock_csv_data/interface.csv", "multi")