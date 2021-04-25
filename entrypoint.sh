#!/bin/sh -l

# install kscript with the provided version 
sdk install kscript $2

# add kscript ot the path 
export PATH=$PATH:/usr/local/sdkman/candidates/kscript/current/bin

# run the tests with the helper script
# the project should be checked out at /github/workspace/ with the checkout action https://github.com/actions/checkout
kscript /ktest.kts /github/workspace/$1