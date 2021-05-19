#!/bin/bash

KTS_FILE=$1
KSCRIPT_VERSION=$2
JAVA_VERSION=$3
KOTLIN_VERSION=$4
FAIL_ON_FAILURE=$5
CURRENT_DIRECTORY=`pwd`

echo "Current director: $CURRENT_DIRECTORY"

# add sdk to the bash environment
source "$SDKMAN_DIR/bin/sdkman-init.sh"

# install kscript & dependencies with the provided versions
sdk install java $JAVA_VERSION
sdk install kotlin $KOTLIN_VERSION
sdk install kscript $KSCRIPT_VERSION

# run the tests with the helper script
# the project should be checked out at /github/workspace/ with the checkout action https://github.com/actions/checkout
kscript /ktest.kts /github/workspace/$KTS_FILE $FAIL_ON_FAILURE