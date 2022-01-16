#!/bin/sh

assert(){
    # input1="$1"
    julia -JSysimage.so benchmarks/benchmarks.jl -t auto
}
assert
