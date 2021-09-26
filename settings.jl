using Pkg
# PackageCompilerを使う
needs_pkg = ["CSV", "DataFrames", "Plots", "DelimitedFiles", "Luxor", "BenchmarkTools"]
exists_pkg = keys(Pkg.installed())
install_pkg = [item for item in needs_pkg if !(item in exists_pkg)&& item != "DelimitedFiles"]
for item in install_pkg
    Pkg.add(item)
end