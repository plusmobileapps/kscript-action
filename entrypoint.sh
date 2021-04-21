#!/bin/sh -l

apt-get update && \
	apt-get -y install curl zip unzip && \
    rm -rf /var/lib/apt/lists/*
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk install kotlin 
sdk install kscript

kscript ktest.kts /github/workspace/$1

echo "Hello $1"
time=$(date)
echo "::set-output name=time::$time"
