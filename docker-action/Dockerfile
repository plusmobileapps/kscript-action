FROM ubuntu

RUN set -x \
    && apt-get update \
    && apt-get install -y curl unzip zip ca-certificates --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

ENV SDKMAN_DIR /usr/local/sdkman

ARG KSCRIPT_VERSION=3.0.2
ARG JAVA_VERSION=11.0.9-zulu
ARG KOTLIN_VERSION=1.4.31
ARG MAVEN_VERSION=3.8.1
ARG GRADLE_VERSION=7.0

ENV KSCRIPT_VERSION=$KSCRIPT_VERSION
ENV JAVA_VERSION=$JAVA_VERSION
ENV KOTLIN_VERSION=$KOTLIN_VERSION
ENV MAVEN_VERSION=$MAVEN_VERSION
ENV GRADLE_VERSION=$GRADLE_VERSION

SHELL [ "/bin/bash", "-c" ]

RUN curl 'https://get.sdkman.io' | bash

RUN set -x \
    && echo "sdkman_auto_answer=true" > $SDKMAN_DIR/etc/config \
    && echo "sdkman_auto_selfupdate=false" >> $SDKMAN_DIR/etc/config \
    && echo "sdkman_insecure_ssl=false" >> $SDKMAN_DIR/etc/config

RUN source $SDKMAN_DIR/bin/sdkman-init.sh \
	&& sdk install java $JAVA_VERSION \
	&& sdk install kotlin $KOTLIN_VERSION \
	&& sdk install maven $MAVEN_VERSION \
	&& sdk install kscript $KSCRIPT_VERSION \
	&& sdk install gradle $GRADLE_VERSION

COPY github/workspace /github/workspace
COPY entrypoint.sh /
COPY ktest.kts / 

ENV PATH="${PATH}:/usr/local/sdkman/candidates/java/current/bin"
ENV PATH="${PATH}:/usr/local/sdkman/candidates/kotlin/current/bin"
ENV PATH="${PATH}:/usr/local/sdkman/candidates/kscript/current/bin"
ENV PATH="${PATH}:/usr/local/sdkman/candidates/gradle/current/bin"

ENTRYPOINT ["/entrypoint.sh"]