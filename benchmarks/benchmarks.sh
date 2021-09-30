#!/bin/sh

assert(){
    # input1="$1"
    julia benchmarks/benchmarks.jl $1
}
assert $1
