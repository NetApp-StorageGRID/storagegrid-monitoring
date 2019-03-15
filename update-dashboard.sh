#!/bin/sh

#update dashboard file; replace first 'id' field with 'null' to avoid grafana 'dashboard not found' error on startup
curl -X GET 'http://admin:admin@localhost:3000/api/dashboards/db/storagegrid-webscale-monitoring' -H 'Content-Type: application/json;charset=UTF-8' | sed 's/\"id\":[[:digit:]]\+/\"id\":null/' > grafana/dashboards/storagegrid-webscale-monitoring.json
