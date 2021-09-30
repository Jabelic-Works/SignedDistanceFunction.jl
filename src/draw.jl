module Draw
    using Plots

    function draw(_x::Array, _y::Array, _phi::Array)
        s = plot(_x, _y, _phi, st=:wireframe)
        p = contour(_x, _y, _phi)
        q = surface(_x, _y, _phi)
        r = plot(_x, _y, _phi, st=:heatmap)
        plot(s, p, q, r, layout=(4, 1), size=(500, 1200))
        savefig("signed_distance.png")
    end

    function parformance_graphs(N::Array, exe_num::Array)
        plot(N, exe_num[:,1],title = "Benchmarks", label = "Parallel processing", legend = :topleft)
        plot!(N, exe_num[:,2], label = "Normal processing")
        xlabel!("Splits of fields")
        ylabel!("Processing time(sec.)")
        savefig("performance.png")
    end
    export draw,parformance_graphs
end