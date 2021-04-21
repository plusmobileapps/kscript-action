FROM ubuntu:focal

COPY entrypoint.sh /entrypoint.sh

COPY ktest.kts /ktest.kts

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]