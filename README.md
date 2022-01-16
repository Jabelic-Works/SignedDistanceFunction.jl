# The Signed distance function

[![Build Status](https://travis-ci.com/jabelic/LevelSet.jl.svg?branch=main)](https://travis-ci.com/jabelic/LevelSet.jl)
[![Coverage](https://codecov.io/gh/jabelic/LevelSet.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/jabelic/LevelSet.jl)
[![Coverage](https://coveralls.io/repos/github/jabelic/LevelSet.jl/badge.svg?branch=main)](https://coveralls.io/github/jabelic/LevelSet.jl?branch=main)

<!-- TODO: set Package Name : LevelSet.jl-->

LevelSet.jl is a package to compute level set function.

Main features are:

- Creating a signed distance to compute the level set function of the jordan closed curve data set(2D).
- Creating a signed distance to compute the level set function of the multiple closed curve data set(2D).

<!-- レベルセット法のためのレベルセット関数を計算する際に初期値として必要な付合付き距離関数を閉曲線データから提供する。 -->

## Usage

The closed curve data must be

`signedDistance2D("XXXXXX.csv", N)`

`signedDistance2D("XXXXXX.csv", N, "multi")`

## Contribution

### Setup

#### macOS

`$ make initial`

or

`$ julia>`  
`$ Pkg(1.5)> add PackageCompiler`  
`$ Pkg(1.5)> add DelimitedFiles`  
`$ Pkg(1.5)> add TimerOutputs`  
`$ Pkg(1.5)> add Test`  
`$ Pkg(1.5)> add Plots`  
`$ julia> using PackageCompiler`  
`$ julia> PackageCompiler.create_sysimage([:CSV, :DataFrames, :Plots, :Luxor, :BenchmarkTools, :TimerOutputs, :Test]; sysimage_path="Sysimage.so")`  
`$ Pkg(1.5)> activate .`  
`$ (LevelSet)>`  
`$ julia> using LevelSet`  
`$ julia> signedDistance2D("xxxxxx.csv", N)`  


### debug

<!-- Test both Parallel and normal processing -->

`$ make test`

- usecase is in `src/main.jl` !
<!-- Benchmarks both Parallel and normal processing -->

`$ make bench`



`$julia>`

enter the Pgk mode(`]`)

`$ pkg>`

`$ pkg> activate .`

`(LevelSet) pkg>`

return the REPL(`Delete/Backspace`)

`julia> `

`julia> using LevelSet`

`julia> signedDistance2D("XXXXXX.csv", N)`

<!-- Plots sample data: 

`julia> using CSV, DataFrames, Plots, DelimitedFiles, Luxor, BenchmarkTools`

`julia> gamma = readdlm("data.csv", ',', Float64)`

`julia> plot(gamma[:, 1], gamma[:, 2], st=:scatter, title="infty_shape", markersize=2)` -->
