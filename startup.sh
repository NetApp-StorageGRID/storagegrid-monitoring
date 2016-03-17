#!/bin/sh

docker-compose up &

sleep 10

# Add Elasticsearch datasources to Grafana
curl -X POST 'http://admin:admin@localhost:3000/api/datasources' \
     -H 'Content-Type: application/json;charset=UTF-8' \
     --data-binary '{"name":"es-sgaudit","type":"elasticsearch","access":"proxy", "url":"http://elasticsearch:9200","password":"","user":"", "database":"logstash-*","basicAuth":false,"basicAuthUser":"","basicAuthPassword":"", "withCredentials":false,"isDefault":false,"jsonData":null}}'

curl -X POST 'http://admin:admin@localhost:3000/api/datasources' \
     -H 'Content-Type: application/json;charset=UTF-8' \
     --data-binary '{"name":"es-sgapi","type":"elasticsearch","access":"proxy", "url":"http://elasticsearch:9200","password":"","user":"", "database":"counters-*","basicAuth":false,"basicAuthUser":"","basicAuthPassword":"", "withCredentials":false,"isDefault":false,"jsonData":null}}'

# Make sure datasource is added and initialized
sleep 2

# Import Main Dashboard
curl -X POST 'http://admin:admin@localhost:3000/api/dashboards/db' -H 'Content-Type: application/json;charset=UTF-8' -d @grafana/dashboards/init.json
curl -X POST 'http://admin:admin@localhost:3000/api/dashboards/db' -H 'Content-Type: application/json;charset=UTF-8' -d @grafana/dashboards/storagegrid-webscale.json

# Import Next-gen Dashboard

curl -X POST 'http://admin:admin@localhost:3000/api/dashboards/db' -H 'Content-Type: application/json;charset=UTF-8' -d @grafana/dashboards/init-monitoring.json
curl -X POST 'http://admin:admin@localhost:3000/api/dashboards/db' -H 'Content-Type: application/json;charset=UTF-8' -d @grafana/dashboards/storagegrid-webscale-monitoring.json
