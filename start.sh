#!/bin/sh
nohup ./helper.sh > monitoring.log 2>&1 &
echo $! > pid.txt
