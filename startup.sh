#!/bin/sh

docker-compose up &

sleep 10

# Add Elasticsearch as datasource to Grafana
curl -X POST 'http://admin:admin@localhost:3000/api/datasources' \
     -H 'Content-Type: application/json;charset=UTF-8' \
     --data-binary '{"name":"elasticsearch","type":"elasticsearch","access":"proxy", "url":"http://elasticsearch:9200","password":"","user":"", "database":"logstash-*","basicAuth":false,"basicAuthUser":"","basicAuthPassword":"", "withCredentials":false,"isDefault":false,"jsonData":null}}'

# Import Dashboard
curl -X POST 'http://admin:admin@localhost:3000/api/dashboards/db' -H 'Content-Type: application/json;charset=UTF-8' -d @grafana/dashboards/simple.json
