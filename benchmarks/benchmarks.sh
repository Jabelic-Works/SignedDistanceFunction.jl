#!/bin/sh

assert(){
    input1="$1"
    julia benchmarks/benchmarks.jl $input1
}
assert $1
