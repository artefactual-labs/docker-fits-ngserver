FROM ubuntu:14.04

ENV DEBIAN_FRONTEND noninteractive
ARG FITS_VERSION=0.8.4-1~14.04
ARG FITS_USER=fits

RUN set -ex \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends \
		apt-transport-https \
		curl \
		python-software-properties \
		software-properties-common \
	&& rm -rf /var/lib/apt/lists/*

RUN set -ex \
	&& curl -s https://packages.archivematica.org/GPG-KEY-archivematica | apt-key add - \
	&& add-apt-repository "deb [arch=amd64] http://packages.archivematica.org/1.6.x/ubuntu-externals trusty main" \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends \
		fits=$FITS_VERSION \
		nailgun \
	&& rm -rf /var/lib/apt/lists/*

RUN set -ex \
	&& groupadd -r fits \
	&& useradd -r -g fits fits

USER fits

ENTRYPOINT ["/usr/bin/fits-ngserver.sh", "/usr/share/maven-repo/com/martiansoftware/nailgun-server/debian/nailgun-server-debian.jar"]
