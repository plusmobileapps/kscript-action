FROM ubuntu:focal

SHELL ["/bin/bash", "-c"]

RUN apt-get update && \
	apt-get -y install curl zip unzip && \
    rm -rf /var/lib/apt/lists/*

# Install SDKMAN!
RUN curl -s "https://get.sdkman.io" | bash

RUN source /root/.sdkman/bin/sdkman-init.sh && \
    sdk install java 11.0.9-zulu && \
    sdk install kotlin 1.4.10
#    sdk install maven 3.6.0 && \

ARG KSCRIPT_VERSION
ENV KSCRIPT_VERSION=$KSCRIPT_VERSION

## run separately to better use docker build cache
RUN source /root/.sdkman/bin/sdkman-init.sh && \
    sdk install kscript $KSCRIPT_VERSION

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

COPY ktest.kts /ktest.kts

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT source /root/.sdkman/bin/sdkman-init.sh && /usr/bin/env kscript ktest.kts /github/workspace/$0