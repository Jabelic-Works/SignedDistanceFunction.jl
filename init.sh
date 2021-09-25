#!/bin/sh

init(){
    THREADS=`fgrep 'processor' /proc/cpuinfo | wc -l`
    echo "export JULIA_NUM_THREADS=$THREADS" >> ~/.bashrc 
}

init
