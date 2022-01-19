# Application Product Test
module APT
    include("../src/sdistance.jl")
    include("../src/environments.jl")
    include("../test/draw.jl")
    include("../src/SignedDistanceFunction.jl")
    # import .Sdistance: signedDistance2D
    using .SignedDistanceFunction
    import .Draw: draw, draw2x2
    import Plots
    using Plots

    """
        Ns: 分割数の入った配列
        _csv_datafiles: CSV Data
        circle_n: 閉曲線データの種類 {"multi", others}

        Ns[start]からNs[end]の分割数でsubdomainを分割し、
        signedDistance2D()で_csv_datafilesで与えられた閉曲線の符合付距離函数を生成、
        それらをcontoursでplot.
    """
    function plots_contours(Ns::Array, _csv_datafiles, circle_n::Union{String,Nothing} = nothing)
        plots = []
        for (i, N) in enumerate(Ns)
            _x = [i for i = -L:2*L/N:L] # len:N+1
            _y = [i for i = -L:2*L/N:L] # len:N+1
            _phi = signedDistance2D(_csv_datafiles, N, circle_n)
            push!(plots, plot(_x, _y, _phi, title = "N=$N", st = :contour))
        end
        println(plots)
        plot(plots..., size = (2300, 2500), layout = (3, 2))
        if circle_n == "multi"
            savefig("test/image/NsPlots_floodfill.png")
        else
            savefig("test/image/NsPlots_isinside.png")
        end
    end

    """
        Ns: 分割数の入った配列
        _csv_datafiles: CSV Data
        circle_n: 閉曲線データの種類 {"multi", others}

        Ns[start]からNs[end]の分割数でsubdomainを分割し、
        signedDistance2D()で_csv_datafilesで与えられた閉曲線の符合付距離函数を生成、
        それらをwireframeでplot.
    """
    function plots_wireframe(Ns::Array, _csv_datafiles, circle_n::Union{String,Nothing} = nothing)
        plots = []
        for (i, N) in enumerate(Ns)
            _x = [i for i = -L:2*L/N:L] # len:N+1
            _y = [i for i = -L:2*L/N:L] # len:N+1
            _phi = signedDistance2D(_csv_datafiles, N, circle_n)
            push!(plots, plot(_x, _y, _phi, title = "N=$N", st = :wireframe))
        end
        println(plots)
        plot(plots..., size = (2300, 2500), layout = (3, 2))
        if circle_n == "multi"
            savefig("test/image/NsPlots_floodfill_wireframe.png")
        else
            savefig("test/image/NsPlots_isinside_wireframe.png")
        end
    end


    """
    N: field splits
    _csv_datafile: CSV Data files
    circle_n: Kinds of circle data{"multi" or "single"}
    描画
    """
    function plot_for_debug(N::Int = 1000, _csv_datafile::String = "./interface.csv", circle_n::Union{String,Nothing} = nothing)
        csvfile_name = match(r"\./test/mock_csv_data/(.*)", _csv_datafile[1:end-4]).captures
        #===  case: double circle ===#
        if circle_n == "multi"
            # こちらの場合はfloodfillで付合をつけるのでNは250欲しい
            _x = [i for i = -L:2*L/N:L] # len:N+1
            _y = [i for i = -L:2*L/N:L] # len:N+1
            _phi = signedDistance2D(_csv_datafile, N, "multi")
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
            # scatter(_gamma[:,1], _gamma[:,2], markersize = 2)
            # savefig("test/image/the_data.png")
            _x = [i for i = -L:2*L/N:L] # len:N+1
            _y = [i for i = -L:2*L/N:L] # len:N+1
            _phi = signedDistance2D(_csv_datafile, N, "single")
            # DataFrame(_phi, :auto) |> CSV.write("./test/result/interface_result_tmp.csv", header = false)
            tmpname = csvfile_name[1]
            if JULIA_MULTI_PROCESS
                filename = "$tmpname" * "_jordancurve_multiprocess_" * "$(N)"
                draw(_x, _y, _phi, filename)
                # draw2x2(_x, _y, _phi, filename)
            else
                _filename = "$tmpname" * "_jordancurve_normalprocess_" * "$(N)"
                draw(_x, _y, _phi, _filename)
            end
            return _phi
        end
    end
    export plots_contours, plots_wireframe, plot_for_debug
end
