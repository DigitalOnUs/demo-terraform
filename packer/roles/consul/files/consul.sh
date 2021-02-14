#!/usr/bin/env bash

if grep client /var/tmp/consul.agent;
then
  sh /var/tmp/consul-client.sh >> /dev/null 2>&1
elif grep server /var/tmp/consul.agent;
then
  sh /var/tmp/consul-server.sh >> /dev/null 2>&1
fi
