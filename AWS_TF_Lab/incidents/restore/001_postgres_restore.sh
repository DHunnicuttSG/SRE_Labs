#!/bin/bash

docker start postgres

echo "$(date) - PostgreSQL restored" \
>> /opt/SRE_Labs/AWS_TF_Lab/incidents/logs/incidents.log