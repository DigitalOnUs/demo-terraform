#!/usr/bin/env bash
# Create consul user
sudo adduser --disabled-password --gecos "Consul User" consul
sudo usermod -a -G sudo consul

# Directories to configure Consul
sudo mkdir -p /etc/consul.d
sudo mkdir -p /var/consul
sudo chown consul:consul /var/consul
sudo mkdir -p /var/consul/config

sudo cp /tmp/consul.json.server /var/consul/config/consul.json.template


BINDADDR=$(ip addr show dev eth0 | grep "inet " | tail -1 | awk '{ print $2 }' | sed 's/\/.*$//')
sudo sed -e s/@@HOSTIP@@/$BINDADDR/g /var/consul/config/consul.json.template > /var/consul/config/consul.json

CONSUL_STARTUP_FLAGS="-server=true -ui -bootstrap-expect 3"

exec /usr/local/bin/consul agent -config-dir /var/consul/config -data-dir /var/consul \
      -bind $BINDADDR -node $(hostname) $joinstr $CONSUL_STARTUP_FLAGS >>/var/log/consul.log 2>&1