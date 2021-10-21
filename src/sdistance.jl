module Sdistance
    include("./draw.jl")
    include("./inpolygon.jl")
    include("./floodfill.jl")
    import .Draw:draw
    import .Inpolygon:create_signed_distance_multiprocess,create_signed_distance,distanceToCurve
    import .Floodfill:signining_field
    import CSV, DataFrames, Plots, DelimitedFiles, Luxor, BenchmarkTools,TimerOutputs
    using CSV, DataFrames, Plots, DelimitedFiles, Luxor, BenchmarkTools,TimerOutputs
    const tmr = TimerOutput();

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
    function complement_p(array::Array, multiple,point_space)
        (x, y) = size(array)
        return_value = Array{Float64}(undef,2 * x, y)
        if multiple
            # point_space = 0
            # _index = 0
            for i = 1:x - 1
                # tmp = sqrt(sum((array[i, :] .- array[i + 1, :]).^2))
                # 点の間隔が平均以下なので、補間する -> 同一の曲線とみなす
                # if tmp < point_space*10/_index
                if sqrt(sum((array[i, :] .- array[i + 1, :]).^2)) < point_space*5 # ここの加減が難しい. Nに依存?
                    # point_space += tmp
                    # _index += 1
                    return_value[i * 2 - 1, :] = array[i, :]
                    return_value[i * 2, :] = (array[i, :] .+ array[i + 1, :]) ./ 2
                # 点の間隔が離れているので違う曲線とみる
                else
                    return_value[i * 2 - 1, :] = array[i, :]
                    return_value[i * 2, :] = array[i, :]
                end
            end
            return_value[x * 2 - 1, :] = array[x, :]
            return_value[x * 2, :] = array[x, :]
        else
            for i = 1:x - 1
                # 点の間隔が平均以下なので、補間する -> 同一の曲線とみなす
                return_value[i * 2 - 1, :] = array[i, :]
                return_value[i * 2, :] = (array[i, :] .+ array[i + 1, :]) ./ 2
            end
            return_value[x * 2 - 1, :] = array[x, :]
            return_value[x * 2, :] = array[1, :]# Note: _ganma += _ganma's head line coz boundary condition. size: (N+1,2)
        end
        return return_value
    end

    """
        times回, 倍の数だけデータを補完する
    """
    function interpolation(array::Array, times::Int, multiple=false)
        tmp = []
        (x, y) = size(array)
        point_space = sum([sqrt(sum((array[i, :] .- array[i + 1, :]).^2)) for i =1:x-1])/x
        for _ = 1:times
            tmp = complement_p(array,multiple, point_space)
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
            println("The number of threads started: ", Threads.nthreads())
            
            # ganma曲線 のデータの読み込み
            _ganma = readdlm(_csv_datafile, ',', Float64)
            _ganma = interpolation(_ganma, 3,true)

            scatter(_ganma[:,1], _ganma[:,2],markersize = 2)
            savefig("image/the_data.png")
            _x = [i for i = -L:2 * L / N:L] # len:N+1 
            _y = [i for i = -L:2 * L / N:L] # len:N+1
            println("_gen size", size(_ganma))
            runtime_ave = 0
            exetimes = 1

            # about timeit: https://m3g.github.io/JuliaNotes.jl/stable/memory/
            for i = 1:exetimes
                _phi = @timeit tmr "makeSignedDistance" makeSignedDistance(_x, _y, _ganma)
                @timeit tmr "signining_field" signining_field(_phi, N+1, L)
            end
            show(tmr)
            draw(_x, _y, _phi, "double_circle_signed_distance")
            return (runtime_ave / exetimes)
        #=== case: simple circle ===#
        else
            # create the computational domain
            L = 1.5
            _phi = zeros(Float64, N + 1, N + 1)
            println("The number of threads started: ", Threads.nthreads())
            
            # ganma曲線 のデータの読み込み
            _ganma = readdlm(_csv_datafile, ',', Float64)
            _x = [i for i = -L:2 * L / N:L] # len:N+1 
            _y = [i for i = -L:2 * L / N:L] # len:N+1
            
            is_ganma_Jordan_curve(_ganma) # TODO: 丁寧なError messageを付与

            _ganma = interpolation(_ganma, 3, false)
            println("_gen size", size(_ganma))
            scatter(_ganma[:,1], _ganma[:,2],markersize = 2)
            savefig("image/the_data.png")

            runtime_ave = 0
            exetimes = 4

            for i = 1:exetimes
                if para_or_serialize_process == 1
                    _phi, runtime = @timed create_signed_distance_multiprocess(_x, _y, _ganma) # parallel processing
                else
                    _phi, runtime = @timed create_signed_distance(_x, _y, _ganma) # serialize processing
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
