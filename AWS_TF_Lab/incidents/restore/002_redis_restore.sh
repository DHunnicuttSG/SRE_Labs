#!/bin/bash

docker start redis

echo "$(date) - Redis restored" \
>> /opt/SRE_Labs/AWS_TF_Lab/incidents/logs/incidents.log