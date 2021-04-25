#!/bin/bash

# add sdk to the bash environment
source "$SDKMAN_DIR/bin/sdkman-init.sh"

# install kscript with the provided version 
sdk install kscript $2

# run the tests with the helper script
# the project should be checked out at /github/workspace/ with the checkout action https://github.com/actions/checkout
kscript /ktest.kts /github/workspace/$1