#!/bin/sh

curl -k -X GET "http://admin:admin@localhost:3000/api/dashboards/db/storagegrid-webscale-monitoring" | jq '.dashboard.id = null' | jq '.dashboard' > grafana/dashboards/storagegrid-webscale-monitoring.json
