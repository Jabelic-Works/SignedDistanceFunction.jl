#!/bin/sh

init(){
    fgrep 'processor' /proc/cpuinfo | wc -l
    echo "export JULIA_NUM_THREADS=$?" >> ~/.bashrc 
}

init
