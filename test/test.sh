#!/bin/sh

# mac(catalina~)でのCLIからの実行でマルチスレッド処理を行うには
    # $ echo "export JULIA_NUM_THREADS=`sysctl -n hw.logicalcpu`" >> ~/.zshrc
    # $ source ~/.zshrc
    # terminalを新たに起動して
    # $ julia hogehuga.jl

assert(){
    input1="$1"
    input2="$2"

    if [ "$input1" = "plot" ]; then
        julia -JSysimage.so test/plot_for_debug.jl $input1 $input2 -t auto
        echo "分割数N=$input2 \n"
        actual="$?"
    else
        julia -JSysimage.so test/main.jl $input1 $input2 -t auto
        actual="$?"
        echo "分割数N=$input1 \n"
    fi

}

assert $1 300
