#!/bin/bash

echo "$(date) - Injecting Flask outage" \
>> /opt/SRE_Labs/AWS_TF_Lab/incidents/logs/incidents.log

docker stop flask-app

echo "Flask stopped."