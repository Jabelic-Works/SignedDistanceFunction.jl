include("./sdistance.jl") # 必ずダブルクオーテーション
import .Sdistance:main
main(parse(Int, ARGS[1]), parse(Int, ARGS[2]), "./interface.csv")
