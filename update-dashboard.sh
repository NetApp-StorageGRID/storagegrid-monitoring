#!/bin/sh

curl -X GET 'http://admin:admin@localhost:3000/api/dashboards/db/storagegrid-webscale' -H 'Content-Type: application/json;charset=UTF-8' > grafana/dashboards/simple.json
