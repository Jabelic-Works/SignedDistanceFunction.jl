#!/bin/zsh

# mac(catalina~)
    # terminalからの実行でマルチスレッド処理を行うには
    # $ vi ~/.zshrc
    # export JULIA_NUM_THREADS=`sysctl -n hw.logicalcpu` を書き加える
    # $ source ~/.zshrc
    # terminalを新たに起動して
    # $ julia hogehuga.jl

    # ないしは
    # $ julia hoge.jl arg1 arg2 -t auto
    # これでもよし(req: Julia 1.5~)
#

assert(){
    input1="$1"
    input2="$2"
    input3="$3"
    # julia sdistance.jl $input1 $input2 --thread `sysctl -n hw.logicalcpu`
    # julia sdistance.jl $input1 $input2
    julia main.jl $input1 $input2 -t auto
    actual="$?"

    if [ "$input2" = 1 ]; then
        echo "並列処理：分割数N=$input1 \n"
    else
        echo "直列処理：分割数N=$input1 \n"
    fi
}

# assert 100 1
# assert 100 2
assert 100 1
# assert 1000 1
# assert 1000 2
