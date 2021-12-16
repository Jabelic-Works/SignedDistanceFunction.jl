# Application Product Test
module APT
    include("../src/sdistance.jl")
    include("../src/environments.jl")
    import .Sdistance:computing_bench,signedDistance2D
    import Plots
    using Plots
    function plots_contours(Ns::Array,  _csv_datafiles, circle_n::Union{String, Nothing} = nothing)
        plots = []
        for (i, N) in enumerate(Ns)
            _x = [i for i = -L:2 * L / N:L] # len:N+1
            _y = [i for i = -L:2 * L / N:L] # len:N+1
            _phi = signedDistance2D(_csv_datafiles, N, circle_n)
            push!(plots, plot(_x, _y, _phi, title="N=$N",st=:contour))
        end
        println(plots)
        plot(plots...)
        savefig("test/image/NsPlots.png")
    end
    export plots_contours
end
