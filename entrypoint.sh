#!/bin/sh -l

curl -s "https://get.sdkman.io" | bash     # install sdkman
source "$HOME/.sdkman/bin/sdkman-init.sh"  # add sdkman to PATH

sdk install kotlin  
sdk install kscript

kscript ktest.kts /github/workspace/$1
echo "Hello $1"
time=$(date)
echo "::set-output name=time::$time"
