# The level set function

[![Build Status](https://travis-ci.com/jabelic/LevelSet.jl.svg?branch=main)](https://travis-ci.com/jabelic/LevelSet.jl)
[![Coverage](https://codecov.io/gh/jabelic/LevelSet.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/jabelic/LevelSet.jl)
[![Coverage](https://coveralls.io/repos/github/jabelic/LevelSet.jl/badge.svg?branch=main)](https://coveralls.io/github/jabelic/LevelSet.jl?branch=main)


<!-- TODO: set Package Name : LevelSet.jl-->
<!--  LevelSet.jlはレベルセット関数に関する機能を提供するpackageである -->
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

#### docker

`$ docker-compose up -d`

`$ docker-compose exec lab bash`


when u leave

`$ docker-compose stop`

and restart.

`$ docker-compose start`


if u abandon the container and image when container is up.

`$ docker-compose down --rmi local --volumes --remove-orphans`


### debug


Test both Parallel and normal processing

`$ make test`

Benchmarks both Parallel and normal processing

`$ make bench ARG=YOUR_LOVE_NUM`


### Plots sample data

If you check the mock data(e.g. interface.csv in root)

`$ julia `  

`> _gamma = readdlm("src/infinity_shaped.csv", ',', Float64)`

`> using CSV, DataFrames, Plots, DelimitedFiles, Luxor, BenchmarkTools`  

`> plot(_gamma[:, 1], _gamma[:, 2], st=:scatter, title="infty_shape", markersize=2)`

