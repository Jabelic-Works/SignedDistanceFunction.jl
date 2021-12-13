module Sdistance
    include("./draw.jl")
    include("./inpolygon.jl")
    include("./floodfill.jl")
    include("./utils/utils.jl")
    import .Draw:draw
    import .Inpolygon:create_signed_distance_function_multiprocess,create_signed_distance_function,distanceToCurve
    import .Floodfill:signining_field
    import CSV, DataFrames, Plots, DelimitedFiles, Luxor, BenchmarkTools,TimerOutputs
    import .Utils:is_jordan_curve,interpolation
    using CSV, DataFrames, Plots, DelimitedFiles, Luxor, BenchmarkTools,TimerOutputs
    const tmr = TimerOutput();
    
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



    function benchmark_multi_floodfill(N::Int=1000, para_or_serialize_process::Int=1, _csv_datafile::String="./interface.csv", circle_n::Union{String, Nothing} = nothing)
        # create the computational domain
        L = 1.1
        _phi = zeros(Float64, N + 1, N + 1)
        
        # ganma曲線 のデータの読み込み
        _gamma = readdlm(_csv_datafile, ',', Float64)
        _gamma = interpolation(_gamma, 2 + round(Int,N/100), true)
        _x = [i for i = -L:2 * L / N:L] # len:N+1 
        _y = [i for i = -L:2 * L / N:L] # len:N+1
        runtime = 0
        exetimes = 3
        _phi, time = @timed P(_phi, _x, _y, N, L, _gamma, para_or_serialize_process)
        runtime += time
        tmpname = csvfile_name[1]
        if para_or_serialize_process ==1
            filename = "$tmpname"*"_multicurves_multiprocess_"*"$(N)"
            draw(_x, _y, _phi,filename)
        else
            _filename = "$tmpname"*"_multicurves_normalprocess_"*"$(N)"
            draw(_x, _y, _phi,_filename)
        end

        return (runtime / exetimes)
    end


    """
        N: field splits
        para_or_serialize_process: starting threads numeric
        _csv_datafile: CSV Data files
        完全に論文用、実行速度計測、描画
    """
    function computing_bench(N::Int=1000, para_or_serialize_process::Int=1, _csv_datafile::String="./interface.csv", circle_n::Union{String, Nothing} = nothing)
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
                    # _phi = @timeit tmr "create_signed_distance_function_multiprocess" create_signed_distance_function_multiprocess(_x, _y, _gamma) # parallel processing
                    _phi,time = @timed create_signed_distance_function_multiprocess(_x, _y, _gamma) # parallel processing
                    runtime += time
                else
                    # _phi = @timeit tmr "create_signed_distance_function" create_signed_distance_function(_x, _y, _gamma) # serialize processing
                    _phi,time = @timed create_signed_distance_function(_x, _y, _gamma) # serialize processing
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
            # こちらの場合はfloodfillで符号をつけるのでNは250欲しい
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
            _phi = create_signed_distance_function_multiprocess(_x, _y, _gamma) # parallel processing
            return _phi
        end
    end
    # precompile(signedDistance2D,(Union{String, DataFrame}, Int, Union{String, Nothing}))
    export signedDistance2D ,computing_bench
end
