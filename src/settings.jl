#= Sysimage for Developers. Sysimage.so must be written on .gitignore because it is so large file! =#
include("./environments.jl")

using Pkg
Pkg.add("DelimitedFiles")
Pkg.add("Test")

if STAGE == "dev"
    Pkg.add("PackageCompiler")
    Pkg.add("TimerOutputs")
    Pkg.add("Plots")
    using PackageCompiler
    PackageCompiler.create_sysimage([:CSV, :DataFrames, :Plots, :Luxor, :BenchmarkTools, :TimerOutputs, :Test]; sysimage_path="Sysimage.so")
end

# >>  You can use packages with 'import and using'
# $ julia -JSysimage.so
