module Sdistance
include("./draw.jl")
include("./distance_function.jl")
include("./floodfill.jl")
include("./utils/utils.jl")
include("./environments.jl")
import .Draw: draw, draw2x2
import .DistanceFunction: create_signed_distance_function_multiprocess, create_signed_distance_function, distanceToCurve, create_distance_function, create_distance_function_multiprocess
import .Floodfill: signining_field
import .Utils: is_jordan_curve, interpolation
import CSV, DataFrames, Plots, DelimitedFiles, Luxor, BenchmarkTools, TimerOutputs
using CSV, DataFrames, Plots, DelimitedFiles, Luxor, BenchmarkTools, TimerOutputs
const tmr = TimerOutput()

function P(_phi, _x, _y, N, L, _gamma)
    # _phi = create_distance_function(_x, _y, _gamma)
    _phi = create_distance_function_multiprocess(_x, _y, _gamma)
    signining_field(_phi, N + 1, L)
    return _phi
end
precompile(P, (Array, Array, Array, Int, Float64, Array))

"""
    benchmark用のためのmethod
    - floodfill使用時のmultiprocessとsingleprocessの比較
"""
function benchmark_floodfill(N::Int = 1000, _csv_datafile::String = "./interface.csv", multiprocess::Bool = true)
    exetimes = 3
    runtime = 0
    if multiprocess
        for i = 1:exetimes
            _phi, time = @timed signedDistance2D(_csv_datafile, N, "multi")
            runtime += time
        end
    else
        for i = 1:exetimes
            _phi, time = @timed signedDistance2D_singleprocess(_csv_datafile, N, "multi")
            runtime += time
        end
    end

    return (runtime / exetimes)
end


"""
benchmark用のためのmethod
- single curveの時のisinsideメソッド使用時ののmultiprocessとsingleprocessの比較
"""
function benchmark_singlecurves_isinside(N::Int = 1000, _csv_datafile::String = "./interface.csv", multiprocess::Bool = true)
    exetimes = 3
    runtime = 0
    if multiprocess
        for i = 1:exetimes
            _phi, time = @timed signedDistance2D(_csv_datafile, N, "single")
            runtime += time
        end
    else
        for i = 1:exetimes
            _phi, time = @timed signedDistance2D_singleprocess(_csv_datafile, N, "single")
            runtime += time
        end
    end

    return (runtime / exetimes)
end



"""
    N: field splits
    _csv_datafile: CSV Data files
    完全に論文用、実行速度計測、描画
"""
function computing_bench(N::Int = 1000, _csv_datafile::String = "./interface.csv", circle_n::Union{String,Nothing} = nothing)
    csvfile_name = match(r"\./test/mock_csv_data/(.*)", _csv_datafile[1:end-4]).captures
    #===  case: double circle ===#
    if circle_n == "multi"
        # こちらの場合はfloodfillで付合をつけるのでNは250欲しい
        _x = [i for i = -L:2*L/N:L] # len:N+1
        _y = [i for i = -L:2*L/N:L] # len:N+1
        _phi = signedDistance2D(_csv_datafile, N, "multi")
        # # create the computational domain
        # _phi = zeros(Float64, N + 1, N + 1)
        # # println("\nThe number of threads started: ", Threads.nthreads())

        # # ganma曲線 のデータの読み込み
        # _gamma = readdlm(_csv_datafile, ',', Float64)
        # _gamma = interpolation(_gamma, 3 + round(Int, N / 100), true)

        # # scatter(_gamma[:,1], _gamma[:,2],markersize = 2)
        # # savefig("test/image/the_data.png")

        # about timeit: https://m3g.github.io/JuliaNotes.jl/stable/memory/
        # for i = 1:exetimes
        # _phi = @timeit tmr "create_distance_function" create_distance_function(_x, _y, _gamma)
        # @timeit tmr "signining_field" signining_field(_phi, N+1, L)
        # _phi, time = @timed P(_phi, _x, _y, N, L, _gamma)
        # end
        # show(tmr) # the @timeit information on CLI

        tmpname = csvfile_name[1]
        if JULIA_MULTI_PROCESS
            filename = "$tmpname" * "_multicurves_multiprocess_" * "$(N)"
            # draw(_x, _y, _phi, filename)
            draw2x2(_x, _y, _phi, filename)
        else
            _filename = "$tmpname" * "_multicurves_normalprocess_" * "$(N)"
            draw(_x, _y, _phi, _filename)
        end

        # return (runtime / exetimes)
        # DataFrame(_phi, :auto) |> CSV.write("./test/result/interface_result_tmp.csv", header = false)
        return _phi

        #=== case: simple circle ===#
    else
        # create the computational domain
        # _phi = zeros(Float64, N + 1, N + 1)
        # # println("\nThe number of threads started: ", Threads.nthreads())

        # # ganma曲線 のデータの読み込み
        # _gamma = readdlm(_csv_datafile, ',', Float64)
        # _x = [i for i = -L:2*L/N:L] # len:N+1 
        # _y = [i for i = -L:2*L/N:L] # len:N+1

        # is_jordan_curve(_gamma) # TODO: 丁寧なError messageを付与

        # _gamma = interpolation(_gamma, 3, false)
        # println("csv data size: ", size(_gamma))
        # scatter(_gamma[:,1], _gamma[:,2], markersize = 2)
        # savefig("test/image/the_data.png")
        _x = [i for i = -L:2*L/N:L] # len:N+1
        _y = [i for i = -L:2*L/N:L] # len:N+1
        _phi = signedDistance2D(_csv_datafile, N, "single")
        # DataFrame(_phi, :auto) |> CSV.write("./test/result/interface_result_tmp.csv", header = false)
        # runtime = 0
        # exetimes = 3

        # for i = 1:exetimes
        # if JULIA_MULTI_PROCESS
        #     # _phi = @timeit tmr "create_signed_distance_function_multiprocess" create_signed_distance_function_multiprocess(_x, _y, _gamma) # parallel processing
        #     _phi, time = @timed create_signed_distance_function_multiprocess(_x, _y, _gamma) # parallel processing
        #     runtime += time
        # else
        #     # _phi = @timeit tmr "create_signed_distance_function" create_signed_distance_function(_x, _y, _gamma) # serialize processing
        #     _phi, time = @timed create_signed_distance_function(_x, _y, _gamma) # serialize processing
        #     runtime += time
        # end
        # end
        # show(tmr) # the @timeit information on CLI

        tmpname = csvfile_name[1]
        if JULIA_MULTI_PROCESS
            filename = "$tmpname" * "_jordancurve_multiprocess_" * "$(N)"
            draw(_x, _y, _phi, filename)
        else
            _filename = "$tmpname" * "_jordancurve_normalprocess_" * "$(N)"
            draw(_x, _y, _phi, _filename)
        end
        return _phi

        # return (runtime / exetimes)
    end
end

"""
    csv_datafile::Union{String, DataFrame}
    N::Int
    curves::Union{String, Nothing}
"""
function signedDistance2D(csv_datafile::Union{String,DataFrame}, N::Int = 100, curves::Union{String,Nothing} = nothing)
    #===  case: double circle ===#
    if curves == "multi"
        # こちらの場合はfloodfillで符号をつけるのでNは250欲しい
        # create the computational domain
        _phi = zeros(Float64, N + 1, N + 1)
        # ganma曲線 のデータの読み込み
        _gamma = readdlm(csv_datafile, ',', Float64)
        _gamma = interpolation(_gamma, 3 + floor(Int, N / 250), true)
        println("multi curves\ncsv data size: ", size(_gamma))

        _x = [i for i = -L:2*L/N:L] # len:N+1 
        _y = [i for i = -L:2*L/N:L] # len:N+1

        _phi = create_distance_function_multiprocess(_x, _y, _gamma)
        signining_field(_phi, N + 1, L)
        return _phi

        #=== case: simple circle ===#
    else
        # create the computational domain
        _phi = zeros(Float64, N + 1, N + 1)
        # ganma曲線 のデータの読み込み
        _gamma = readdlm(csv_datafile, ',', Float64)
        _x = [i for i = -L:2*L/N:L] # len:N+1 
        _y = [i for i = -L:2*L/N:L] # len:N+1

        is_jordan_curve(_gamma) # TODO: 丁寧なError messageを付与
        if length(_gamma) <= 50
            _gamma = interpolation(_gamma, 1 + floor(Int, N / 200), false)
        elseif length(_gamma) <= 100
            _gamma = interpolation(_gamma, 1 + floor(Int, N / 400), false)
        end
        println("the jordan curve\ncsv data size: ", size(_gamma))
        _phi = create_signed_distance_function_multiprocess(_x, _y, _gamma) # parallel processing
        return _phi
    end
end

function signedDistance2D_singleprocess(csv_datafile::Union{String,DataFrame}, N::Int = 100, curves::Union{String,Nothing} = nothing)
    #===  case: double circle ===#
    if curves == "multi"
        # create the computational domain
        _phi = zeros(Float64, N + 1, N + 1)
        # ganma曲線 のデータの読み込み
        _gamma = readdlm(csv_datafile, ',', Float64)
        _gamma = interpolation(_gamma, 3 + floor(Int, N / 250), true)
        println("multi curves\ncsv data size: ", size(_gamma))

        _x = [i for i = -L:2*L/N:L] # len:N+1 
        _y = [i for i = -L:2*L/N:L] # len:N+1

        _phi = create_distance_function(_x, _y, _gamma)
        signining_field(_phi, N + 1, L, false)
        return _phi

        #=== case: simple circle ===#
    else
        # create the computational domain
        _phi = zeros(Float64, N + 1, N + 1)
        # ganma曲線 のデータの読み込み
        _gamma = readdlm(csv_datafile, ',', Float64)
        _x = [i for i = -L:2*L/N:L] # len:N+1 
        _y = [i for i = -L:2*L/N:L] # len:N+1

        is_jordan_curve(_gamma) # TODO: 丁寧なError messageを付与
        if length(_gamma) <= 50
            _gamma = interpolation(_gamma, 1 + floor(Int, N / 200), false)
        elseif length(_gamma) <= 100
            _gamma = interpolation(_gamma, 1 + floor(Int, N / 400), false)
        end
        println("the jordan curve\ncsv data size: ", size(_gamma))
        _phi = create_signed_distance_function(_x, _y, _gamma) # single processing
        return _phi
    end
end
# precompile(signedDistance2D,(Union{String, DataFrame}, Int, Union{String, Nothing}))
export signedDistance2D, computing_bench, benchmark_floodfill, benchmark_singlecurves_isinside
end
