#!/bin/sh

assert(){
    # input1="$1"
    julia -JSysimage.so benchmarks/benchmarks.jl $1 -t auto
}
assert $1
