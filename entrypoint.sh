#!/bin/bash

apt-get update
apt-get -y install curl zip unzip
rm -rf /var/lib/apt/lists/*

# Install SDKMAN!
curl -s "https://get.sdkman.io" | bash

source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk install java 11.0.9-zulu && \
sdk install kotlin 1.4.10
#    sdk install maven 3.6.0 && \

## run separately to better use docker build cache
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk install kscript

kscript ktest.kts /github/workspace/$1

echo "Hello $1"
time=$(date)
echo "::set-output name=time::$time"
