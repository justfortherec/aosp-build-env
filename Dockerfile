FROM ubuntu:16.04

MAINTAINER docker@jftr.de

# Prepare the Build Environment
RUN apt-get update \
 && apt-get install -y \
    openjdk-8-jdk \
    git-core \
    gnupg \
    flex \
    bison \
    gperf \
    build-essential \
    zip \
    curl \
    zlib1g-dev \
    gcc-multilib \
    g++-multilib \
    libc6-dev-i386 \
    lib32ncurses5-dev \
    x11proto-core-dev \
    libx11-dev \
    lib32z-dev \
    libgl1-mesa-dev \
    libxml2-utils \
    xsltproc \
    unzip \
    make \
    python-networkx \
    ca-certificates \
    sudo \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Install repo
RUN mkdir -p /usr/local/repo/bin \
 && curl --tlsv1 https://storage.googleapis.com/git-repo-downloads/repo > \
    /usr/local/repo/bin/repo \
 && chmod +x /usr/local/repo/bin/repo \
 && echo 'PATH="/usr/local/repo/bin:$PATH"' >> /etc/skel/.bashrc

# Create working directory
RUN mkdir -p /opt/aosp/
VOLUME /opt/aosp/
WORKDIR /opt/aosp/

# Run commands as user aosp
COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
