#
# Dockerfile for alyz/devbase
#

# Pull base image.
FROM debian:stretch-20190610

# set environment
ENV DEBIAN_FRONTEND noninteractive

# Install apt-utils
RUN apt-get update \
    && apt-get install -y apt-utils

# set timezone to EST
RUN echo 'America/New_York' > /etc/timezone \
    && rm -f /etc/localtime \
    && dpkg-reconfigure tzdata

# Remove systemd to avoid bloat from all the unnecessary updates
# RUN apt-get install -y sysvinit-core sysvinit sysvinit-utils \
#     && apt-get remove -y --purge --auto-remove systemd \
#     && echo -e 'Package: systemd\nPin: origin ""\nPin-Priority: -1' > /etc/apt/preferences.d/systemd \
#     && echo -e '\nPackage: systemd:amd64\nPin: origin ""\nPin-Priority: -1' >> /etc/apt/preferences.d/systemd \
#     && echo -e '\nPackage: systemd:i386\nPin: origin ""\nPin-Priority: -1' >> /etc/apt/preferences.d/systemd

# prevent unnecessary packages from installing updates
RUN /bin/echo -e "systemd hold\nudev hold\nsystemd-sysv hold\nprocps hold" | dpkg --set-selections \
    && apt-get -y dist-upgrade

# compile busybox 1.26.2 from source
ADD http://busybox.net/downloads/busybox-1.26.2.tar.bz2 /tmp/
RUN apt-get install -y make gcc bzip2 perl \
    && cd /tmp \
    && tar -xvjf busybox-1.26.2.tar.bz2 \
    && cd /tmp/busybox-1.26.2 \
    && make defconfig \
    && sed -e "s@# CONFIG_STATIC is not set@CONFIG_STATIC=y@" -i .config \
    && make \
    && cp /tmp/busybox-1.26.2/busybox /bin/busybox \
    && apt-get remove -y --purge --auto-remove make gcc bzip2 perl \
    && rm -rf /tmp/busybox*

# set busybox suid and add all apps to /usr/local/bbin
RUN chmod 4755 /bin/busybox
RUN ln -s /bin/busybox /usr/local/bin/vi \
    && ln -s /bin/busybox /usr/local/bin/wget \
    && mkdir /usr/local/bbin \
    && cd /usr/local/bbin \
    && /bin/busybox --list | /bin/busybox xargs -n 1 ln -s /bin/busybox \
    && echo "export PATH=${PATH}:/usr/local/bbin" > /etc/profile.d/10_add_bbin_to_path.sh

# update root bash environment
RUN echo ""  >> /root/.bashrc \
    && echo "export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/bbin" >> /root/.bashrc \
    && echo 'alias d="ls -alis"' >> /root/.bashrc

# create directories for busybox crond
RUN mkdir -p /var/spool/cron/crontabs \
    && chmod 700 /var/spool/cron/crontabs

# add spawnvp helper for passthru executions
RUN echo "#!/usr/local/bbin/sh" > /usr/local/bin/spawnvp \
    && echo "if test \$# -gt 0; then \$*; fi" >> /usr/local/bin/spawnvp \
    && chmod 755 /usr/local/bin/spawnvp

# Add s6 init system
ADD https://github.com/just-containers/s6-overlay/releases/download/v1.18.1.5/s6-overlay-amd64.tar.gz /tmp/
RUN tar xzf /tmp/s6-overlay-amd64.tar.gz -C /
# workaround to handle /bin and /sbin symlinks
# RUN tar xzf /tmp/s6-overlay-amd64.tar.gz -C / --exclude="./bin" --exclude="./sbin" \
#     && tar xzf /tmp/s6-overlay-amd64.tar.gz -C /usr ./bin ./sbin
ENTRYPOINT ["/init"]

CMD ["/bin/bash","-l"]
