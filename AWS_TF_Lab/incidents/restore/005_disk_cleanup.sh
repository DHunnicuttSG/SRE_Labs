#!/bin/bash

rm -f /tmp/filler.bin

echo "$(date) - Disk Incident Cleared" \
>> /opt/SRE_Labs/AWS_TF_Lab/incidents/logs/incidents.log