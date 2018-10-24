#!/usr/bin/env bash

# Run haproxy in a docker container
# Mount the haproxy config file
sudo docker run -d \
           --name haproxy \
           -p 80:80 \
           --restart unless-stopped \
           -v /var/tmp/haproxy.cfg:/usr/local/etc/haproxy/haproxy.cfg:ro \
           haproxy:1.6.5-alpine

sudo docker run -d \
           --name haproxy2 \
           -p 8500:80 \
           --restart unless-stopped \
           -v /var/tmp/haproxy2.cfg:/usr/local/etc/haproxy/haproxy.cfg:ro \
           haproxy:1.6.5-alpine
