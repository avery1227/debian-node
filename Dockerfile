#
# Copyright (c) 2024 Arthur Mitchell
#
FROM        --platform=$TARGETOS/$TARGETARCH debian:bookworm-slim

LABEL       author="Arthur Mitchell" maintainer="avery627@gmail.com"

ENV         DEBIAN_FRONTEND=noninteractive

RUN      apt update && apt upgrade -y \
         && apt -y --no-install-recommends install ca-certificates curl git unzip zip tar jq wget

# Only install the needed steamcmd packages on the AMD64 build
RUN         if [ "$(uname -m)" = "x86_64" ]; then \
                dpkg --add-architecture i386 && \
                apt update && \
                apt -y install lib32gcc-s1 libsdl2-2.0-0:i386; \
            fi

# Install Node.js (LTS version)
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash - && \
    apt install -y nodejs

# Set PATH
ENV PATH="/usr/local/bin:$PATH"

# Create the server directory
RUN mkdir -p /mnt/server/resources

# Copy the installation script into the container
COPY entrypoint.sh /entrypoint.sh

# Make the entrypoint script executable
RUN chmod +x /entrypoint.sh

# Set the working directory
WORKDIR /mnt/server