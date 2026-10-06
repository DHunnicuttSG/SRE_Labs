#!/bin/bash

echo "$(date) - Injecting PostgreSQL outage" \
>> /opt/SRE_Labs/AWS_TF_Lab/incidents/logs/incidents.log

docker stop postgres

echo "PostgreSQL stopped."