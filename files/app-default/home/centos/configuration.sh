#!/bin/bash

# Copy all terraform-generated files onto the filesystem.

sudo cp -r /tmp/configuration/* /

# Source environment variables.

source environment_variables.sh

# Perform YUM installs.

sudo yum -y install epel-release
sudo yum -y install \
  gcc \
  python-devel \
  python-pip \
  unzip \
  zip

# Perform PIP installs.

sudo pip install \
  pyRFC3339 \
  pysparkling \
  requests

# Reload the systemd database.

sudo systemctl daemon-reload

# TODO: Now do the real work...