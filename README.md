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

