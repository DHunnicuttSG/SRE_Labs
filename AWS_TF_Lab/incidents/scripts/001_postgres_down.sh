#!/bin/bash

echo "$(date) - Injecting PostgreSQL outage" \
>> /opt/SRE_Labs/incidents/logs/incidents.log

docker stop postgres

echo "PostgreSQL stopped."