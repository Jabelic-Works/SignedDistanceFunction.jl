using Pkg
# needs_pkg = ["CSV", "DataFrames", "Plots", "DelimitedFiles", "Luxor", "BenchmarkTools"]
Pkg.add("PackageCompiler")
Pkg.add("DelimitedFiles")
Pkg.add("TimerOutputs")
Pkg.add("Test")
Pkg.add("Plots")
using PackageCompiler

PackageCompiler.create_sysimage([:CSV, :DataFrames, :Plots, :Luxor, :BenchmarkTools, :TimerOutputs, :Test]; sysimage_path="Sysimage.so")
# then, >>  import and using
# julia -JSysimage.so
