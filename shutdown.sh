#!/bin/sh

docker-compose down
kill -9 `cat pid.txt`
rm pid.txt
rm monitoring.log
