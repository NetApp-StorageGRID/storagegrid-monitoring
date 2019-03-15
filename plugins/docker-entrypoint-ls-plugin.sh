#!/bin/sh

bin/logstash-plugin install logstash-filter-elapsed

exec /usr/local/bin/docker-entrypoint logstash
