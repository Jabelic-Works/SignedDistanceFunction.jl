# using CSV:length
# using Plots:length
# using DataFrames:Matrix

# Pkg.add("CSV")
# using CSV, DataFrames, Plots, DelimitedFiles, Luxor # , GeometricalPredicates
using CSV, DataFrames, Plots, DelimitedFiles, Luxor, BenchmarkTools

function distance(px, py, gem) # TODO: 型
    cand = 10000.0
    for i = 1:length(gem[:,1])
        distnow = sqrt((gem[i,1] - px)^2 + (gem[i,2] - py)^2)
        if (distnow < cand)
            cand = distnow
        end
    end
    return cand
end

function draw(_x, _y, _phi)
    p = contour(_x, _y, _phi)
    # q = plot(_x, _y,_phi, st=:surface)
    q = surface(_x, _y, _phi)
    r = plot(_x, _y, _phi, st=:heatmap)
    plot(p, q, r, layout=(3, 1), size=(400, 900))
#     plot(p, q, r, layout=(1,3), size=(900,160))
    savefig("signed_distance.png")
end

function judge_(_x, _y, _gem)
    x_length = length(_x[:,1])
    return_value = zeros(Float64, x_length, x_length)
    for indexI = 1:length(_y)
        for indexJ = 1:length(_x)
            sdist = 1.0 * distance(_x[indexJ], _y[indexI], _gem)
            if isinside(Point(_x[indexJ], _y[indexI]), [Point(_gem[i,1], _gem[i,2]) for i = 1:length(_gem[:,1])])
                sdist = (-1) * sdist
            end
            return_value[indexI,indexJ] = sdist
        end
    end
    return return_value
end

function judge_para(_x, _y, _gem)
    x_length = length(_x[:,1])
    return_value = zeros(Float64, x_length, x_length)
    Threads.@threads for indexI = 1:length(_y)
        for indexJ = 1:length(_x)
            sdist = 1.0 * distance(_x[indexJ], _y[indexI], _gem)
            if isinside(Point(_x[indexJ], _y[indexI]), [Point(_gem[i,1], _gem[i,2]) for i = 1:length(_gem[:,1])])
                sdist = (-1) * sdist
            end
            return_value[indexI,indexJ] = sdist
        end
    end
    return return_value
end


# FIXME: 倍々ではなく, linearに補完数を指定できるように。

"n行目とn+1行目の間のデータを補完,境界条件を付与 (50, 2)->(100, 2)"
function complement_p(array)
    (x, y) = size(array)
    return_value = zeros(Float64, 2 * x, y)
    for i = 1:x - 1
        return_value[i * 2 - 1, :] = array[i, :]
        return_value[i * 2, :] = (array[i, :] .+ array[i + 1, :]) ./ 2
    end
    return_value[x * 2 - 1, :] = array[x, :]
    return_value[x * 2, :] = array[1, :]# Note: _gem += _gem's head line coz boundary condition. size: (N+1,2)
    return return_value
end
# function complement(array::Array{Float64,2}, times::UInt64)
function complement(array, times)
        tmp = []
    for i = 1:times
        tmp = complement_p(array)
        array = tmp
    end
    return tmp
end

function main(N=1000, para_or_serialize_process=1)
    # create the computational domain
    L = 1.5
    _phi = zeros(Float64, N + 1, N + 1)
    println("Thread数: ", Threads.nthreads())
    # ganma曲線 data 読み込みちょっと遅いかも. (50 x 2)
    # https://qiita.com/HiroyukiTachikawa/items/e01917ade931031ec6a1
    _gem = readdlm("./interface.csv", ',', Float64)
    
    _gem = complement(_gem, 2)
    println("_gen size", size(_gem))
    _x = [i for i = -L:2 * L / N:L] # len:N+1 
    _y = [i for i = -L:2 * L / N:L] # len:N+1
    
    runtime_ave = 0
    exetimes = 4

    for i = 1:exetimes
        if para_or_serialize_process == 1
            _phi, runtime = @timed judge_para(_x, _y, _gem) # parallel processing
        else
            _phi, runtime = @timed judge_(_x, _y, _gem) # serialize processing
        end
        runtime_ave += runtime
    end
    println(runtime_ave / exetimes)

    # draw(_x, _y, _phi)
end

main(parse(Int, ARGS[1]), parse(Int, ARGS[2]))
