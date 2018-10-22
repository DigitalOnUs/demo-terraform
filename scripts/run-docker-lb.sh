#!/usr/bin/env bash
sudo cp /tmp/haproxy.cfg  .

# Run haproxy in a docker container
# Mount the haproxy config file
sudo docker run -d \
           --name haproxy \
           -p 80:80 \
           --restart unless-stopped \
           -v haproxy.cfg:/usr/local/etc/haproxy/haproxy.cfg:ro \
           haproxy:1.6.5-alpine

