#!/bin/bash

echo "$(date) - Injecting Flask outage" \
>> /opt/SRE_Labs/incidents/logs/incidents.log

docker stop flask-app

echo "Flask stopped."