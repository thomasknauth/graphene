# Start with 16.04
FROM ubuntu:16.04

# Add steps here to set up dependencies
RUN apt-get update \
    && apt-get install -y \
       apache2-utils \
       autoconf \
       build-essential \
       gawk \
       bison \
       gettext \
       git \
       libexpat1 \
       libexpat1-dev \
       libpcre3-dev \
       libxml2-dev \
       linux-headers-generic \
       linux-headers-$(uname -r) \
       net-tools \
       python \
       python-protobuf \
       python3-minimal \
       python3-pytest \
       texinfo \
       wget \
       libomp-dev \

# Add the user UID:1001, GID:1001, home at /leeroy
    && groupadd -r leeroy -g 1001 \
    && useradd -u 1001 -r -g leeroy -m -d /leeroy -c "Leeroy Jenkins" leeroy \
    && chmod 755 /leeroy \

# Make sure /leeroy can be written by leeroy
    && chown 1001 /leeroy \

# Blow away any random state
    && rm -f /leeroy/.rnd \

# Make a directory for the intel driver
    && mkdir -p /opt/intel && chown 1001 /opt/intel

# Set the working directory to leeroy home directory
WORKDIR /leeroy

# Specify the user to execute all commands below
USER leeroy

# Set environment variables.
ENV HOME /leeroy

# Define default command.
CMD ["bash"]
