using Plots:length
# using DataFrames:Matrix

# using Pkg
# Pkg.add("CSV")
using CSV, DataFrames, Plots, DelimitedFiles

function distance(px, py, gem) # TODO: 型
    cand = 10000.0
    for i = 1:length(gem)    
        distnow = sqrt((gem[i,1] - px)^2 + (gem[i,2] - py)^2)
        if (distnow < cand)
            cand = distnow
        end
    end
    return cand
end

function is_inner_point(domain_x, domain_y, gem, x::Float64, y::Float64)
    _gem_x = _gem[:, 1]
    _gem_y = _gem[:, 2]
    println(domain_x[end], "  ", domain_y[end])
    println(_gem_x[end], "  ", _gem_y[end])
end

# データから近似した曲線と、与えられたデータでの曲線を比較してplotしたい
# 

function main()
    # create the computational domain
    N = 100
    L = 2.0
    _phi = zeros(Int8, N, N)
    # _gem = DataFrame(CSV.File("../interface.csv", header=false)) # ganma曲線 data ちょっと遅いかも. (49 x 2)
    _gem = readdlm("./interface.csv", ',', Float64)
    # https://qiita.com/HiroyukiTachikawa/items/e01917ade931031ec6a1
    
    # 　TODO: 刻み幅をganma曲線に合わせる
    _x = [i for i = -L:2 * L / N:L]
    _y = [i for i = -L:2 * L / N:L]

    is_inner_point(_x, _y, _gem, _x[3], _y[4])
    # for indexI = 1:length(_y)
    #     for indexJ = 1:length(_x)
    #         sdist = 1.0 * distance(_x[indexJ], _y[indexI], _gam)
    #         println(sdist)
    #         # left of relation ?
    #         # if [x[indexJ], y[indexI]] in 
    #         # println([x[indexJ], y[indexI]])
    #     end
    # end
end


main()        