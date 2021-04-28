FROM ubuntu

RUN set -x \
    && apt-get update \
    && apt-get install -y curl unzip zip ca-certificates --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

ENV SDKMAN_DIR /usr/local/sdkman

SHELL [ "/bin/bash", "-c" ]

RUN curl 'https://get.sdkman.io' | bash

RUN set -x \
    && echo "sdkman_auto_answer=true" > $SDKMAN_DIR/etc/config \
    && echo "sdkman_auto_selfupdate=false" >> $SDKMAN_DIR/etc/config \
    && echo "sdkman_insecure_ssl=false" >> $SDKMAN_DIR/etc/config

RUN source $SDKMAN_DIR/bin/sdkman-init.sh \
	&& sdk install maven \
	&& sdk install gradle

COPY entrypoint.sh /
COPY ktest.kts / 

ENV PATH="${PATH}:/usr/local/sdkman/candidates/maven/current/bin"
ENV PATH="${PATH}:/usr/local/sdkman/candidates/gradle/current/bin"

ENTRYPOINT ["/entrypoint.sh"]