#!/bin/bash

docker start flask-app

echo "$(date) - Flask restored" \
>> /opt/SRE_Labs/AWS_TF_Lab/incidents/logs/incidents.log