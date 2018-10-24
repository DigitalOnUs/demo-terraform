#!/usr/bin/env bash

# Create an html page with the ip of this node
<<<<<<< HEAD:scripts/run-docker-web.sh
ip=$(ifconfig eth0 | grep 'inet addr' | awk '{ print substr($2,6) }')
echo "<h1>$ip $(hostname)</h1>" > /tmp/ip.html
=======
ip=$(ifconfig eth1 | grep 'inet addr' | awk '{ print substr($2,6) }')
echo "<h1>$ip $(hostname)</h1>" > /var/tmp/ip.html
>>>>>>> ea1a39c5516c6b5b64a9ea750db88ebce89af67a:packer/roles/docker/files/docker-web.sh

# Run nginx via docker
# mount the ip.html page as a volume in the root of the default nginx site
# thus we can access this page via `curl localhost:8080/ip.html`
sudo docker run -d \
           --name web \
           -p 8080:80 \
           --restart unless-stopped \
<<<<<<< HEAD:scripts/run-docker-web.sh
           -v /tmp/ip.html:/usr/share/nginx/html/ip.html:ro \
           nginx
=======
           -v /var/tmp/ip.html:/usr/share/nginx/html/ip.html:ro \
           nginx
>>>>>>> ea1a39c5516c6b5b64a9ea750db88ebce89af67a:packer/roles/docker/files/docker-web.sh
