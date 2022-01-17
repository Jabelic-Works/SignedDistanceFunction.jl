# Application Product Test
module APT
include("../src/sdistance.jl")
include("../src/environments.jl")
import .Sdistance: computing_bench, signedDistance2D
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
export plots_contours, plots_wireframe
end
