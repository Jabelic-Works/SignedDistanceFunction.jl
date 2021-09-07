include("./sdistance.jl") # 必ずダブルクオーテーション
import .Sdistance.main
Sdistance.main(parse(Int, ARGS[1]), parse(Int, ARGS[2]), "./interface.csv")
