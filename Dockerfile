FROM        ubuntu:trusty
MAINTAINER  Andrea Bernardo Ciddio <bcandrea@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get -y install ubuntu-dev-tools \
                       debhelper \
                       cowbuilder

ENV PBUILDER_BASEPATH /var/lib/pbuilder
ENV BACKPORTS_PATH /var/lib/backports

RUN mkdir -p $PBUILDER_BASEPATH $BACKPORTS_PATH

VOLUME $BACKPORTS_PATH
VOLUME /root/.gnupg
ADD backportpackage.sh /
ENTRYPOINT ["/backportpackage.sh"]
CMD [""]
