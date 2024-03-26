#!/bin/bash

# https://docs.docker.com/engine/install/ubuntu/
# https://docs.docker.com/engine/install/linux-postinstall/

# Update packages, upgrade system and install dependencies
apt-get update
apt-get install --no-install-recommends --no-install-suggests --yes \
  curl \
  ca-certificates \
  unzip \
  xz-utils

# Add Docker's official GPG key
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install the Docker packages
apt-get update
apt-get install --no-install-recommends --no-install-suggests --yes \
  docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-buildx-plugin \
  docker-compose-plugin

# Clean packages cache
apt-get autoremove --purge
apt-get autoclean
apt-get clean
rm -rf /var/lib/apt/lists/*

# Create the docker group and add the user
# groupadd docker # Already created by the packages
usermod -aG docker vagrant
