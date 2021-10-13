# Level set function

## setup

### macOS

`$ make initial`

### docker

`$ docker-compose up -d`

`$ docker-compose exec lab bash`


when u leave

`$ docker-compose stop`

and restart.

`$ docker-compose start`


if u abandon the container and image when container is up.

`$ docker-compose down --rmi local --volumes --remove-orphans`


## dev


Test both Parallel and normal processing

`$ make test`

Benchmarks both Parallel and normal processing

`$ make bench ARG=YOUR_LOVE_NUM`



### Plots sample data

If you check the mock data(e.g. interface.csv in root)

`$ julia `  

`> _ganma = readdlm("src/infinity_shaped.csv", ',', Float64)`

`> using CSV, DataFrames, Plots, DelimitedFiles, Luxor, BenchmarkTools`  

`> plot(_ganma[:, 1], _ganma[:, 2], st=:scatter, title="infty_shape", markersize=2)`
