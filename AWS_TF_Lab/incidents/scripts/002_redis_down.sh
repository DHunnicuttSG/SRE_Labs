#!/bin/bash

echo "$(date) - Injecting Redis outage" \
>> /opt/SRE_Labs/AWS_TF_Lab/incidents/logs/incidents.log

docker stop redis

echo "Redis stopped."