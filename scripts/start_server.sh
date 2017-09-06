#!/bin/bash

# Start Cassandra
cassandra -R &

# Start Kong
kong start

# Start Dashboard
kong-dashboard start&

# Start Web App
service supervisor start
curl -i -X POST --retry 100 --retry-delay 10 --url "http://localhost:8001/apis/" --data "name=dslib-api" --data "uris=/api" --data "upstream_url=http://localhost:5000/api/LibraryAPI"
