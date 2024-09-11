FROM debian:latest
LABEL vcs-ref="https://github.com/abegorov/linux19/linux-builder"
WORKDIR /build/linux
RUN set -eux; \
  apt-get update; \
  apt-get install -y --no-install-recommends \
    build-essential \
    bc \
    kmod \
    cpio \
    flex \
    libncurses5-dev \
    libelf-dev \
    libssl-dev \
    dwarves \
    bison \
    debhelper \
    rsync \
    rpm \
    wget \
    ca-certificates; \
  rm -rf /var/lib/apt/lists/*
COPY --chmod=0755 download /usr/local/bin/
