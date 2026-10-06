#!/bin/bash

docker start flask-app

echo "$(date) - Flask restored" \
>> /opt/SRE_Labs/incidents/logs/incidents.log