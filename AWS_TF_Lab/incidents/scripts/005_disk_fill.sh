#!/bin/bash

echo "$(date) - Disk Fill Incident" \
>> /opt/SRE_Labs/incidents/logs/incidents.log

fallocate -l 2G /tmp/filler.bin

echo "Disk usage increased."