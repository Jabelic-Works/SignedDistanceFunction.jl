#!/bin/sh

init(){
    if [ "$(uname)" = 'Darwin' ] && [ "$SHELL" = "/bin/zsh" ]; then
        echo "export JULIA_NUM_THREADS=`sysctl -n hw.logicalcpu`" >> ~/.zshrc
    elif  [ "$SHELL" = "/bin/bash" ] && [ "$SHELL" = "/bin/zsh" ]; then
        echo "export JULIA_NUM_THREADS=`sysctl -n hw.logicalcpu`" >> ~/.bashrc
    elif [ "$(expr substr $(uname -s) 1 5)"='Linux' ] && [ "$SHELL" = "/bin/bash" ]; then
        THREADS=`fgrep 'processor' /proc/cpuinfo | wc -l`
        echo "export JULIA_NUM_THREADS=$THREADS" >> ~/.bashrc 
    else
        echo "Your platform ($(uname -a)) is not supported."
        exit 1
    fi
    julia src/settings.jl -t auto
}

init
