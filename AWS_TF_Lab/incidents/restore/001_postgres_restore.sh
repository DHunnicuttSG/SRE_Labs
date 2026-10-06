#!/bin/bash

docker start postgres

echo "$(date) - PostgreSQL restored" \
>> /opt/SRE_Labs/incidents/logs/incidents.log