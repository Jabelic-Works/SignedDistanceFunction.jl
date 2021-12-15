#= Sysimage for Developers. Sysimage.so must be written on .gitignore because it is so large file! =#
using Pkg
Pkg.add("PackageCompiler")
Pkg.add("DelimitedFiles")
Pkg.add("TimerOutputs")
Pkg.add("Test")
Pkg.add("Plots")
using PackageCompiler

PackageCompiler.create_sysimage([:CSV, :DataFrames, :Plots, :Luxor, :BenchmarkTools, :TimerOutputs, :Test]; sysimage_path="Sysimage.so")
# >>  You can use packages with 'import and using'
# $ julia -JSysimage.so
