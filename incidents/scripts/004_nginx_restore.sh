#!/bin/bash

cp \
/opt/SRE_Labs/backups/default.conf \
/opt/SRE_Labs/docker/nginx/default.conf

docker restart nginx

echo "$(date) - Nginx restored" \
>> /opt/SRE_Labs/incidents/logs/incidents.log