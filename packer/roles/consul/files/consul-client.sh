#!/usr/bin/env bash
# Create consul user
sudo adduser --disabled-password --gecos "Consul User" consul
sudo usermod -a -G sudo consul
chmod +x /usr/local/bin/consul

# Directories to configure Consul
sudo mkdir -p /etc/consul.d
sudo mkdir -p /var/consul
sudo chown consul:consul /var/consul
sudo mkdir -p /var/consul/config

sudo cp /var/tmp/consul.json.client /var/consul/config/consul.json.template
BINDADDR=$(ip addr show dev eth0 | grep "inet " | tail -1 | awk '{ print $2 }' | sed 's/\/.*$//')

if [ $BINDADDR != "10.0.4.130" ]
    sudo cp /var/tmp/web.json /etc/consul.d/web.json
else 
    sudo cp /var/tmp/lb.json /etc/consul.d/lb.json
fi
    # Enable consul ports in iptables
    # SERF
    sudo iptables -I INPUT -s 0/0 -p tcp --dport 8301 -j ACCEPT

    # SERF_WAN
    sudo iptables -I INPUT -s 0/0 -p tcp --dport 8302 -j ACCEPT

    # RPC
    sudo iptables -I INPUT -s 0/0 -p tcp --dport 8400 -j ACCEPT

    sudo iptables -I INPUT -s 0/0 -p tcp --dport 8080 -j ACCEPT

sudo sed -e s/@@HOSTIP@@/$BINDADDR/g /var/consul/config/consul.json.template > /var/consul/config/consul.json

CONSUL_STARTUP_FLAGS="-server=false"

joinstr="-retry-join 10.0.4.100 -retry-join 10.0.4.174 -retry-join 10.0.4.213"

exec /usr/local/bin/consul agent -config-dir /var/consul/config -data-dir /var/consul -bind $BINDADDR -node $(hostname) $joinstr $CONSUL_STARTUP_FLAGS >>/var/log/consul.log 2>&1 &
