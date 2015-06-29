#
# Dockerfile for alyz/devbase
#

# Pull base image.
FROM debian:unstable

# set environment
ENV DEBIAN_FRONTEND noninteractive

# Install apt-utils
RUN apt-get update \
    && apt-get install -y apt-utils

# Remove systemd
RUN apt-get install -y sysvinit-core sysvinit sysvinit-utils \
    && apt-get remove -y --purge --auto-remove systemd \
    && echo -e 'Package: systemd\nPin: origin ""\nPin-Priority: -1' > /etc/apt/preferences.d/systemd \
    && echo -e '\nPackage: systemd:amd64\nPin: origin ""\nPin-Priority: -1' >> /etc/apt/preferences.d/systemd \
    && echo -e '\nPackage: systemd:i386\nPin: origin ""\nPin-Priority: -1' >> /etc/apt/preferences.d/systemd

# set timezone to EST
RUN echo 'America/New_York' > /etc/timezone \
    && dpkg-reconfigure tzdata

RUN apt-get -y dist-upgrade

# install busybox and create links to all apps in /usr/local/bbin
RUN apt-get install -y busybox-static \
    && ln -s /bin/busybox /usr/local/bin/vi \
    && ln -s /bin/busybox /usr/local/bin/wget \
    && mkdir /usr/local/bbin \
    && cd /usr/local/bbin \
    && /bin/busybox --list | /bin/busybox xargs -n 1 ln -s /bin/busybox
