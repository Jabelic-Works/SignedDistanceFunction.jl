module Draw

if STAGE == "dev"
    import Plots
    using Plots
end

function draw(_x::Array, _y::Array, _phi::Array, fig_name::Union{SubString{String},String,Nothing} = nothing)
    if STAGE != "dev"
        return
    end
    s = plot(_x, _y, _phi, st = :wireframe, title = "wireframe",grid=false)
    p = contour(_x, _y, _phi, title = "contour",grid=false)
    q = surface(_x, _y, _phi, title = "surface",grid=false)
    r = plot(_x, _y, _phi, st = :heatmap, title = "heatmap")
    plot(s, p, q, r, layout = (4, 1), size = (500, 1200))
    if fig_name !== nothing
        savefig("test/image/" * fig_name * ".png")
    else
        savefig("image/tmp_signed_distance.png")
    end
end


function draw2x2(_x::Array, _y::Array, _phi::Array, fig_name::Union{SubString{String},String,Nothing} = nothing)
    if STAGE != "dev"
        return
    end
    s = plot(_x, _y, _phi, st = :wireframe, title = "wireframe",grid=false)
    p = contour(_x, _y, _phi, title = "contour",grid=false)
    q = surface(_x, _y, _phi, title = "surface",grid=false)
    r = plot(_x, _y, _phi, st = :heatmap, title = "heatmap")
    plot(s, p, q, r, layout = (2, 2), size = (1100, 800))
    if fig_name !== nothing
        savefig("test/image/2x2" * fig_name * ".png")
    else
        savefig("image/2x2tmp_signed_distance.png")
    end
end


"""
"""
function parformance_graphs(N::Array, exe_num::Array, fig_name::Union{String,Nothing} = nothing, label_name::Union{Array,Nothing} = nothing)
    if STAGE != "dev"
        return
    end
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
if STAGE == "dev"
    precompile(draw, (Array, Array, Array, Union{SubString{String},Nothing}))
    precompile(draw2x2, (Array, Array, Array, Union{SubString{String},Nothing}))
    precompile(parformance_graphs, (Array, Array))
end
export draw, draw2x2, parformance_graphs
end