using Pkg
# needs_pkg = ["CSV", "DataFrames", "Plots", "DelimitedFiles", "Luxor", "BenchmarkTools"]
Pkg.add("PackageCompiler")
Pkg.add("DelimitedFiles")
using PackageCompiler


PackageCompiler.create_sysimage([:CSV, :DataFrames, :Plots, :Luxor, :BenchmarkTools]; sysimage_path="system/Sysimage.so")
# then, >>  import and using
# julia -JSysimage.so
