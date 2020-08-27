#!/bin/sh

echo 'docker container running before stop'
echo "===================================="
docker ps

echo 'stop all container '
echo '=================='
docker stop $(docker ps -q)

echo 'docker container after stop'
echo "==========================="
docker ps

echo ' '
echo 'docker container list available'
echo "==============================="
docker ps -a
