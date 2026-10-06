#!/bin/bash

cp \
/opt/SRE_Labs/AWS_TF_Lab/backups/default.conf \
/opt/SRE_Labs/AWS_TF_Lab/docker/nginx/default.conf

docker restart nginx

echo "$(date) - Nginx restored" \
>> /opt/SRE_Labs/AWS_TF_Lab/incidents/logs/incidents.log