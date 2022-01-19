module Draw
import Plots
using Plots

function draw(_x::Array, _y::Array, _phi::Array, fig_name::Union{SubString{String},String,Nothing} = nothing)
    s = plot(_x, _y, _phi, st = :wireframe, title = "wireframe")
    p = contour(_x, _y, _phi, title = "contour")
    q = surface(_x, _y, _phi, title = "surface")
    r = plot(_x, _y, _phi, st = :heatmap, title = "heatmap")
    plot(s, p, q, r, layout = (4, 1), size = (500, 1200))
    if fig_name !== nothing
        savefig("test/image/" * fig_name * ".png")
    else
        savefig("image/tmp_signed_distance.png")
    end
end
precompile(draw, (Array, Array, Array, Union{SubString{String},Nothing}))


function draw2x2(_x::Array, _y::Array, _phi::Array, fig_name::Union{SubString{String},String,Nothing} = nothing)
    s = plot(_x, _y, _phi, st = :wireframe, title = "wireframe")
    p = contour(_x, _y, _phi, title = "contour")
    q = surface(_x, _y, _phi, title = "surface")
    r = plot(_x, _y, _phi, st = :heatmap, title = "heatmap")
    plot(s, p, q, r, layout = (2, 2), size = (1100, 800))
    if fig_name !== nothing
        savefig("test/image/2x2" * fig_name * ".png")
    else
        savefig("image/2x2tmp_signed_distance.png")
    end
end
precompile(draw2x2, (Array, Array, Array, Union{SubString{String},Nothing}))


"""
"""
function parformance_graphs(N::Array, exe_num::Array, fig_name::Union{String,Nothing} = nothing, label_name::Union{Array,Nothing} = nothing)
    (row, col) = size(exe_num)
    println(row, col)
    plot(N, exe_num[:, 1], title = "Benchmarks", label = label_name[1], legend = :topleft, grid=false)
    for i = 2:col
        plot!(N, exe_num[:, i], label = label_name[i], grid=false)
    end
    xlabel!("Splits of fields")
    ylabel!("Processing time(sec.)")
    if fig_name !== nothing
        savefig("test/image/" * fig_name * "_performance.png")
    else
        savefig("test/image/performance.png")
    end
end
precompile(parformance_graphs, (Array, Array))
export draw, draw2x2, parformance_graphs
end