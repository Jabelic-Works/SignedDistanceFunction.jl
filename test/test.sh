#!/bin/sh

# mac(catalina~)でのCLIからの実行でマルチスレッド処理を行うには
    # $ echo "export JULIA_NUM_THREADS=`sysctl -n hw.logicalcpu`" >> ~/.zshrc
    # $ source ~/.zshrc
    # terminalを新たに起動して
    # $ julia hogehuga.jl


# main.jlの呼び出し. For Debuging.
assert(){
    input1="$1"
    input2="$2"
    input3="$3"
    # 実行
    julia -JSysimage.so test/main.jl $input1 $input2 -t auto
    actual="$?"

    if [ "$input2" = 1 ]; then
        echo "並列処理：分割数N=$input1 \n"
    else
        echo "直列処理：分割数N=$input1 \n"
    fi
}


# assert 50
# assert 100
# assert 150
# assert 200
# assert 250
assert 300
# # assert 1000

