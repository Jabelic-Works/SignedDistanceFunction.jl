#!/bin/sh

# mac(catalina~)でのCLIからの実行でマルチスレッド処理を行うには
    # $ echo "export JULIA_NUM_THREADS=`sysctl -n hw.logicalcpu`" >> ~/.zshrc
    # $ source ~/.zshrc
    # terminalを新たに起動して
    # $ julia hogehuga.jl

# WSLでのこのPJの実行方法
    # make initial
    # make test

# docker-composeを使うなら
    # docker-compose up -d
    # docker-compose exec lab bash
    # make initial
    # make test


# # main.jlの呼び出し. For Debuging!
assert(){
    input1="$1"
    input2="$2"
    input3="$3"
    # julia sdistance.jl $input1 $input2 --thread `sysctl -n hw.logicalcpu`
    
    # 実行
    julia -JSysimage.so src/main.jl $input1 $input2 -t auto
    actual="$?"

    if [ "$input2" = 1 ]; then
        echo "並列処理：分割数N=$input1 \n"
    else
        echo "直列処理：分割数N=$input1 \n"
    fi
}

assert 90
assert 80
# assert 100 
# # assert 100 
# # assert 1000 
# # assert 1000 


# # Unit Test
# runtest(){
#     # painting boardのtest
#     cd painting-board; npm ci; cd ..
#     # UnitTest
#     julia -JSysimage.so --project -e 'using Pkg;Pkg.test()'
#     actual="$?"
# }

# runtest 
