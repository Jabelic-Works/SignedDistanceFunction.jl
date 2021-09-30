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

    function parformance_graphs(exe_num::Array, N::Array)
        plot(N, exe_num)
        savefig("performance.png")
    end
end