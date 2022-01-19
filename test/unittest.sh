#!/bin/bash

# Unit Test
runtest(){
    # painting boardのtest
    cd painting-board; npm ci; cd ..
    # UnitTest
    julia -JSysimage.so --project -e 'using Pkg;Pkg.test()'
    actual="$?"
}

runtest
