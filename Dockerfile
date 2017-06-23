#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "update.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#

##FROM scratch
##ADD rootfs.tar.xz /
FROM debian:stretch-slim

# A few problems with compiling Java from source:
#  1. Oracle.  Licensing prevents us from redistributing the official JDK.
#  2. Compiling OpenJDK also requires the JDK to be installed, and it gets
#       really hairy.
# Default to UTF-8 file.encoding
ENV LANG C.UTF-8

RUN true \
	&& dpkg --add-architecture i386 \
	&& apt-get update \
	&& apt-get install -y --install-recommends \
		bzip2:i386 \
		unzip:i386 \
		xz-utils:i386 \
		iproute2:i386 \
		iputils-ping:i386 \
		net-tools:i386 \
		libxinerama1:i386 \
		libxinerama1 \
		apt-utils \
		vim \
   		firefox-esr:i386 x11-apps:i386 \
		xterm:i386 \
		x11-utils:i386 \
		openssh-client:i386 \
		xfonts-75dpi:i386 \
		xfonts-scalable:i386 \
		xfonts-100dpi:i386 \
		cups-common:i386  \
		python:i386 \
		gnutls-bin:i386  \
		gpm:i386 \
		ttf-dejavu ttf-liberation libxtst6:i386 \
		libnss3-tools:i386 \
		xpra:i386 \
	&& apt-get -y clean all \
	&& mkdir -p /home && chmod 777 /home \
	&& echo 'search office.denic.de adm.denic.de rz.denic.de denic.de' > /etc/resolvA.conf \
	&& echo 'nameserver 10.122.50.26' >>/etc/resolvA.conf \
	&& echo 'nameserver 10.122.50.25' >>/etc/resolvA.conf \
	; true

#	&& rm -rf /var/lib/apt/lists/*

ADD jdk-6u45-linux-i586.bin /usr/java/jdk6installer
RUN bash /usr/java/jdk6installer && /bin/rm /usr/java/jdk6installer && mv /jdk* /usr/java

ADD jre-8u131-linux-i586.tar.gz /usr/java
RUN ln -s /usr/java/jre1.8.0_131 /usr/java/default 
ADD jdk-7u80-linux-i586.tar.gz /usr/java
#RUN ln -s /usr/java/jdk1.7.0_80 /usr/java/default

RUN true \
	; if [ -d /usr/java/default/jre ] ; then ln -s /usr/java/default/jre /usr/java/jre; else ln -s /usr/java/default /usr/java/jre; fi \
	; ln -s /usr/java/jre/lib/i386/libnpjp2.so /usr/lib/mozilla/plugins
ADD startmeup.sh /
ADD root_CA.pem /
ADD infs_CA.pem /
ADD firefox_profile.tgz /home/.mozilla/firefox
ADD root_dot_java.tgz   /
ADD javaws7.desktop /usr/share/applications/
ADD index.html   /
RUN chmod 755 /startmeup.sh


# add a simple script that can auto-detect the appropriate JAVA_HOME value
# based on whether the JDK or only the JRE is installed
#RUN { \
#		echo '#!/bin/sh'; \
#		echo 'set -e'; \
#		echo; \
#		echo 'dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"'; \
#	} > /usr/local/bin/docker-java-home \
#	&& chmod +x /usr/local/bin/docker-java-home

#ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64

# If you're reading this and have any feedback on how this image could be
#   improved, please open an issue or a pull request so we can discuss it!

CMD ["/startmeup.sh" ]
