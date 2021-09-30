#!/bin/sh

assert(){
    # input1="$1"
    # input2="$2"
    # julia src/main.jl $input1 $input2 -t auto
    # actual="$?"
    julia benchmarks/benchmarks.jl
    # if [ "$input2" = 1 ]; then
    #     echo "並列処理：分割数N=$input1 \n"
    # else
    #     echo "直列処理：分割数N=$input1 \n"
    # fi
}
assert 
