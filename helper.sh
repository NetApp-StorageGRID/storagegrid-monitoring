#!/bin/sh

docker-compose up &

sleep 40

# Add Elasticsearch datasource to Grafana
curl -X POST 'http://admin:admin@localhost:3000/api/datasources' \
     -H 'Content-Type: application/json;charset=UTF-8' \
     --data-binary '{"name":"es-sgaudit","type":"elasticsearch","access":"proxy","url":"http://elasticsearch:9200","password":"","user":"","database":"logstash-*","basicAuth":false,"basicAuthUser":"","basicAuthPassword":"","withCredentials":false,"isDefault":false,"jsonData":{"esVersion":60,"timeField":"@timestamp"}}'

# Add StorageGRID's Prometheus datasource to Grafana
curl -X POST 'http://admin:admin@localhost:3000/api/datasources' \
     -H 'Content-Type: application/json;charset=UTF-8' \
     --data-binary '{"name":"sg-prometheus","type":"prometheus","access":"proxy","url":"http://<sg-admin-ip>:9090","password":"","user":"","basicAuth":false,"basicAuthUser":"","basicAuthPassword":"","withCredentials":false,"isDefault":false,"jsonData":{"timeInterval":"60s","queryTimeout":"60s","httpMethod":"GET"}}'

# Make sure datasource is added and initialized
sleep 3

# Import Dashboard
curl -X POST 'http://admin:admin@localhost:3000/api/dashboards/db' -H 'Content-Type: application/json;charset=UTF-8' -d @grafana/dashboards/storagegrid-webscale-monitoring.json

# Sync audit log to local directory
while true;do rsync -rtvO --include "**.log" --exclude "*.*" --append -e "ssh -p 22" admin@10.193.150.88:/var/local/audit/export/ ./audit/;sleep 5;done;
