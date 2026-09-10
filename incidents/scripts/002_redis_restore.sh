#!/bin/bash

docker start redis

echo "$(date) - Redis restored" \
>> /opt/SRE_Labs/incidents/logs/incidents.log