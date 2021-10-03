#!/bin/sh

init(){
    # input1="$1"
    # echo $SHELL >> 使用中のshellの種類:   /bin/zsh
    if [ "$(uname)" = 'Darwin' ] && [ "$SHELL" = "/bin/zsh" ]; then
        echo "export JULIA_NUM_THREADS=`sysctl -n hw.logicalcpu`" >> ~/.zshrc
        # source ~/.zshrc
    elif  [ "$SHELL" = "/bin/bash" ] && [ "$SHELL" = "/bin/zsh" ]; then
        echo "export JULIA_NUM_THREADS=`sysctl -n hw.logicalcpu`" >> ~/.bashrc
        # source ~/.bashrc
    elif [ "$(expr substr $(uname -s) 1 5)"='Linux' ] && [ "$SHELL" = "/bin/bash" ]; then
        THREADS=`fgrep 'processor' /proc/cpuinfo | wc -l`
        echo "export JULIA_NUM_THREADS=$THREADS" >> ~/.bashrc 
        # source ~/.bashrc
    else
        echo "Your platform ($(uname -a)) is not supported."
        exit 1
    fi
    julia src/settings.jl -t auto
}

init
