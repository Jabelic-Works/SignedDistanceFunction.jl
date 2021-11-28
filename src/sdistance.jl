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
    """
    function is_jordan_curve(_gamma::Array)
        progression_of_differences = [sqrt((_gamma[i,1] - _gamma[i + 1,1])^2 + (_gamma[i,2] - _gamma[i + 1,2])^2) for i = 1:(length(_gamma[:, 1]) - 1)]
        ave_distance = sum(progression_of_differences) / length(progression_of_differences)
        if ave_distance * 2 < abs(_gamma[1,1] - _gamma[length(_gamma[:,1]),1])
            return true
        else
            return false
        end
    end

    # FIXME: 倍々ではなく, linearに補完数を指定できるように。

    "n行目とn+1行目の間のデータを補完,境界条件を付与 (x, 2)->(x*2-1, 2)"
    function complement_p(array::Array, multiple::Bool, point_space::Float64)
        (x, y) = size(array)
        return_value = Array{Float64}(undef,2 * x, y)
        if multiple
            for i = 1:x - 1
                # 点の間隔が平均以下なので、補間する -> 同一の曲線とみなす
                if sqrt(sum((array[i, :] .- array[i + 1, :]).^2)) < point_space*5 # NOTE: ここの加減が難しい. Nに依存?
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
            return_value[x * 2, :] = array[1, :] # Note: _gamma += _gamma's head line coz boundary condition. size: (N+1,2)
        end
        return return_value
    end
    # precompile()

    """
        times回, 倍の数だけデータを補完する
    """
    function interpolation(array::Array, times::Int, multiple=false)
        tmp = []
        (x, y) = size(array)
        point_space = sum([sqrt(sum((array[i, :] .- array[i + 1, :]).^2)) for i =1:x-1])/x
        for _ = 1:times
            tmp = complement_p(array, multiple, point_space)
            array = tmp
        end
        return tmp
    end
    precompile(interpolation, (Array, Int, Bool))
    
    # Multi processing, multi jordan curves.
    function makeSignedDistance(_x::Array, _y::Array, _gamma::Array, multi_or_normal=1)
        x_length = length(_x[:,1])
        return_value = zeros(Float64, x_length, x_length)
        if multi_or_normal==1
            Threads.@threads for indexI = 1:length(_y)
                for indexJ = 1:length(_x)
                    return_value[indexI,indexJ] = 1.0 * distanceToCurve(_x[indexJ], _y[indexI], _gamma)
                end
            end
        else
            for indexI = 1:length(_y)
                for indexJ = 1:length(_x)
                    return_value[indexI,indexJ] = 1.0 * distanceToCurve(_x[indexJ], _y[indexI], _gamma)
                end
            end
        end
        return return_value
    end
    precompile(makeSignedDistance, (Array, Array, Array, Int))

    function P(_phi, _x, _y, N, L, _gamma, para_or_serialize_process)
        _phi = makeSignedDistance(_x, _y, _gamma, para_or_serialize_process)
        signining_field(_phi, N+1, L, para_or_serialize_process)
        return _phi
    end
    precompile(P, (Array, Array, Array, Int, Float64, Array, Int))

    """
        N: field splits
        para_or_serialize_process: starting threads numeric
        _csv_datafile: CSV Data files
        完全に論文用、実行速度計測、描画
    """
    function computing_bench(N::Int=1000, para_or_serialize_process::Int=1, _csv_datafile::String="./interface.csv", circle_n::Union{String, Nothing} = nothing) # FIXME: types
        csvfile_name = match(r"\./test/mock_csv_data/(.*)",_csv_datafile[1:end-4]).captures
        #===  case: double circle ===#
        if circle_n=="multi"
            # こちらの場合はfloodfillで付合をつけるのでNは250欲しい

            # create the computational domain
            L = 1.1
            _phi = zeros(Float64, N + 1, N + 1)
            # println("\nThe number of threads started: ", Threads.nthreads())
            
            # ganma曲線 のデータの読み込み
            _gamma = readdlm(_csv_datafile, ',', Float64)
            _gamma = interpolation(_gamma, 2 + round(Int,N/100), true)

            # scatter(_gamma[:,1], _gamma[:,2],markersize = 2)
            # savefig("test/image/the_data.png")
            _x = [i for i = -L:2 * L / N:L] # len:N+1 
            _y = [i for i = -L:2 * L / N:L] # len:N+1
            # println("csv data size: ", size(_gamma))
            runtime = 0
            exetimes = 3

            # about timeit: https://m3g.github.io/JuliaNotes.jl/stable/memory/
            # for i = 1:exetimes
                # _phi = @timeit tmr "makeSignedDistance" makeSignedDistance(_x, _y, _gamma, para_or_serialize_process)
                # @timeit tmr "signining_field" signining_field(_phi, N+1, L, para_or_serialize_process)
                _phi, time = @timed P(_phi, _x, _y, N, L, _gamma, para_or_serialize_process)
                runtime += time
            # end
            # show(tmr) # the @timeit information on CLI
            
            tmpname = csvfile_name[1]
            if para_or_serialize_process ==1
                filename = "$tmpname"*"_multicurves_multiprocess_"*"$(N)"
                draw(_x, _y, _phi,filename)
            else
                _filename = "$tmpname"*"_multicurves_normalprocess_"*"$(N)"
                draw(_x, _y, _phi,_filename)
            end

            return (runtime / exetimes)
            # DataFrame(_phi, :auto) |> CSV.write("./test/result/hoge.csv", header=false)
            # return _phi
        
        #=== case: simple circle ===#
        else
            # create the computational domain
            L = 1.1
            _phi = zeros(Float64, N + 1, N + 1)
            # println("\nThe number of threads started: ", Threads.nthreads())
            
            # ganma曲線 のデータの読み込み
            _gamma = readdlm(_csv_datafile, ',', Float64)
            _x = [i for i = -L:2 * L / N:L] # len:N+1 
            _y = [i for i = -L:2 * L / N:L] # len:N+1
            
            is_jordan_curve(_gamma) # TODO: 丁寧なError messageを付与

            _gamma = interpolation(_gamma, 2, false)
            # println("csv data size: ", size(_gamma))
            # scatter(_gamma[:,1], _gamma[:,2], markersize = 2)
            # savefig("test/image/the_data.png")

            runtime = 0
            exetimes = 3

            # for i = 1:exetimes
                if para_or_serialize_process == 1
                    # _phi = @timeit tmr "create_signed_distance_multiprocess" create_signed_distance_multiprocess(_x, _y, _gamma) # parallel processing
                    _phi,time = @timed create_signed_distance_multiprocess(_x, _y, _gamma) # parallel processing
                    runtime += time
                else
                    # _phi = @timeit tmr "create_signed_distance" create_signed_distance(_x, _y, _gamma) # serialize processing
                    _phi,time = @timed create_signed_distance(_x, _y, _gamma) # serialize processing
                    runtime += time
                end
            # end
            # show(tmr) # the @timeit information on CLI
            
            tmpname = csvfile_name[1]
            if para_or_serialize_process ==1
                filename = "$tmpname"*"_jordancurve_multiprocess_"*"$(N)"
                draw(_x, _y, _phi,filename)
            else
                _filename = "$tmpname"*"_jordancurve_normalprocess_"*"$(N)"
                draw(_x, _y, _phi,_filename)
            end
            return _phi

            return (runtime / exetimes)
        end
    end

    """
        csv_datafile::Union{String, DataFrame}
        N::Int
        curves::Union{String, Nothing}

    """
    function signedDistance2D(csv_datafile::Union{String, DataFrame}, N::Int=100, curves::Union{String, Nothing}=nothing)
        #===  case: double circle ===#
        if curves=="multi"
            # こちらの場合はfloodfillで付合をつけるのでNは250欲しい
            # create the computational domain
            L = 1.1
            _phi = zeros(Float64, N + 1, N + 1)
            # ganma曲線 のデータの読み込み
            _gamma = readdlm(csv_datafile, ',', Float64)
            _gamma = interpolation(_gamma, 3, true)
            println("multi curves\ncsv data size: ", size(_gamma))

            _x = [i for i = -L:2 * L / N:L] # len:N+1 
            _y = [i for i = -L:2 * L / N:L] # len:N+1

            _phi = makeSignedDistance(_x, _y, _gamma)
            signining_field(_phi, N+1, L)
            return _phi
        
        #=== case: simple circle ===#
        else
            # create the computational domain
            L = 1.1
            _phi = zeros(Float64, N + 1, N + 1)
            # ganma曲線 のデータの読み込み
            _gamma = readdlm(csv_datafile, ',', Float64)
            _x = [i for i = -L:2 * L / N:L] # len:N+1 
            _y = [i for i = -L:2 * L / N:L] # len:N+1
            
            is_jordan_curve(_gamma) # TODO: 丁寧なError messageを付与
            _gamma = interpolation(_gamma, 2, false)
            println("the jordan curve\ncsv data size: ", size(_gamma))
            _phi = create_signed_distance_multiprocess(_x, _y, _gamma) # parallel processing
            return _phi
        end
    end
    # precompile(signedDistance2D,(Union{String, DataFrame}, Int, Union{String, Nothing}))
    export signedDistance2D ,computing_bench
end
