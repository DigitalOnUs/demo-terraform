#!/usr/bin/env bash

sudo iptables -I INPUT -s 0/0 -p tcp --dport 80 -j ACCEPT

sudo iptables -I INPUT -s 0/0 -p tcp --dport 8500 -j ACCEPT

# Run haproxy in a docker container
# Mount the haproxy config file
sudo docker run -d \
           --name haproxy \
           -p 80:80 \
           --restart unless-stopped \
           -v /tmp/haproxy.cfg:/usr/local/etc/haproxy/haproxy.cfg:ro \
           haproxy:1.6.5-alpine

sudo docker run -d \
           --name haproxy2 \
           -p 8500:80 \
           --restart unless-stopped \
           -v /tmp/haproxy2.cfg:/usr/local/etc/haproxy/haproxy.cfg:ro \
           haproxy:1.6.5-alpine

