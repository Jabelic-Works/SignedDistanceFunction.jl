#!/bin/sh

init(){
    # Docker内なら
    THREADS=`fgrep 'processor' /proc/cpuinfo | wc -l`
    echo "export JULIA_NUM_THREADS=$THREADS" >> ~/.bashrc 
    # macなら
    # "export JULIA_NUM_THREADS="を有ればoverwrite, なければechoで追記
    julia settings.jl
}

init
