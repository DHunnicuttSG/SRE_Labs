#!/bin/bash

echo "$(date) - Injecting Redis outage" \
>> /opt/SRE_Labs/incidents/logs/incidents.log

docker stop redis

echo "Redis stopped."