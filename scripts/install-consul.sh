#!/usr/bin/env bash

# Install unzip
sudo apt-get update
sudo apt-get install -y unzip zip

# Download consul
CONSUL_VERSION=v1.2.3 
curl https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip -o consul.zip

# Install consul
unzip consul.zip
sudo chmod +x consul
sudo mv consul /usr/bin/consul