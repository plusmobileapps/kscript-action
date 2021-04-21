#!/bin/bash

cd
source /root/.sdkman/bin/sdkman-init.sh && /usr/bin/env kscript ktest.kts /github/workspace/$1

echo "Hello $1"
time=$(date)
echo "::set-output name=time::$time"
