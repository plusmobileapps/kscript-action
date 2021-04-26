#!/bin/sh -l

KTS_FILE=$1
KSCRIPT_VERSION=$2

cd /docker-action
echo "creating docker image with kscript version: $KSCRIPT_VERSION"

# here we can make the construction of the image as customizable as we need
# and if we need parameterizable values it is a matter of sending them as inputs
docker build -t kscript-action --build-arg KSCRIPT_VERSION="$KSCRIPT_VERSION" . && docker run kscript-action $KTS_FILE