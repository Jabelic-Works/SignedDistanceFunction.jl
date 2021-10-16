module Sdistance
    include("./draw.jl")
    include("./inpolygon.jl")
    include("./floodfill.jl")
    import .Draw:draw
    import .Inpolygon:judge_para,judge_,distanceToCurve 
    import CSV, DataFrames, Plots, DelimitedFiles, Luxor, BenchmarkTools
    using CSV, DataFrames, Plots, DelimitedFiles, Luxor, BenchmarkTools

    # ジョルダン曲線: ねじれのない閉曲線のこと.
    """
        ジョルダン閉曲線であるかどうか
        TODO: circleが複数ある場合はスルーして欲しい
    """
    function is_ganma_Jordan_curve(_ganma)
        progression_of_differences = [sqrt((_ganma[i,1] - _ganma[i + 1,1])^2 + (_ganma[i,2] - _ganma[i + 1,2])^2) for i = 1:(length(_ganma[:, 1]) - 1)]
        ave_distance = sum(progression_of_differences) / length(progression_of_differences)
        if ave_distance * 2 < abs(_ganma[1,1] - _ganma[length(_ganma[:,1]),1])
            return true
        else
            return false
        end
    end


    # FIXME: 倍々ではなく, linearに補完数を指定できるように。

    "n行目とn+1行目の間のデータを補完,境界条件を付与 (x, 2)->(x*2-1, 2)"
    function complement_p(array::Array)
        (x, y) = size(array)
        return_value = zeros(Float64, 2 * x, y)
        for i = 1:x - 1
            return_value[i * 2 - 1, :] = array[i, :]
            return_value[i * 2, :] = (array[i, :] .+ array[i + 1, :]) ./ 2
        end
        return_value[x * 2 - 1, :] = array[x, :]
        return_value[x * 2, :] = array[1, :]# Note: _ganma += _ganma's head line coz boundary condition. size: (N+1,2)
        return return_value
    end

    """
        times回, 倍の数だけデータを補完する
    """
    function interpolation(array::Array, times::Int)
        tmp = []
        for i = 1:times
            tmp = complement_p(array)
            array = tmp
        end
        return tmp
    end

    # Multi processing, multi jordan curves.
    function makeSignedDistance(_x::Array, _y::Array, _ganma::Array)
        x_length = length(_x[:,1])
        return_value = zeros(Float64, x_length, x_length)
        Threads.@threads for indexI = 1:length(_y)
            for indexJ = 1:length(_x)
                return_value[indexI,indexJ] = 1.0 * distanceToCurve(_x[indexJ], _y[indexI], _ganma)
            end
        end
        return return_value
    end


    function main(N::Int=1000, para_or_serialize_process::Int=1, _csv_datafile::String="./interface.csv", circle_n::String = "None") # FIXME: types
        #===  case: double circle ===#
        if circle_n=="double"
            # create the computational domain
            L = 1.5
            _phi = zeros(Float64, N + 1, N + 1)
            println("Thread数: ", Threads.nthreads())
            # ganma曲線 data 読み込みちょっと遅いかも. (50 x 2)
            _ganma = readdlm(_csv_datafile, ',', Float64)
            _x = [i for i = -L:2 * L / N:L] # len:N+1 
            _y = [i for i = -L:2 * L / N:L] # len:N+1
            println("_gen size", size(_ganma))
            runtime_ave = 0
            exetimes = 4

            for i = 1:exetimes
                _phi, runtime = @timed makeSignedDistance(_x, _y, _ganma)
                runtime_ave += runtime
            end
            println("実行時間: ",runtime_ave / exetimes)
            draw(_x, _y, _phi, "double_circle_signed_distance")
            return (runtime_ave / exetimes)
        #=== case: simple circle ===#
        else
            # create the computational domain
            L = 1.5
            _phi = zeros(Float64, N + 1, N + 1)
            println("Thread数: ", Threads.nthreads())
            
            # ganma曲線 data 読み込みちょっと遅いかも. (50 x 2)
            _ganma = readdlm(_csv_datafile, ',', Float64)
            _x = [i for i = -L:2 * L / N:L] # len:N+1 
            _y = [i for i = -L:2 * L / N:L] # len:N+1
            
            is_ganma_Jordan_curve(_ganma) # TODO: 丁寧なError messageを付与

            _ganma = interpolation(_ganma, 3)
            println("_gen size", size(_ganma))

            runtime_ave = 0
            exetimes = 4

            for i = 1:exetimes
                if para_or_serialize_process == 1
                    _phi, runtime = @timed judge_para(_x, _y, _ganma) # parallel processing
                else
                    _phi, runtime = @timed judge_(_x, _y, _ganma) # serialize processing
                end
                runtime_ave += runtime
            end
            println("実行時間: ",runtime_ave / exetimes)
            draw(_x, _y, _phi, "infty_shaped_signed_distance")
            return (runtime_ave / exetimes)
        end
    end
    export main
end

# main(parse(Int, ARGS[1]), parse(Int, ARGS[2]), "./interface.csv")
