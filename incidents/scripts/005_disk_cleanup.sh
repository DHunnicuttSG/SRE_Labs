#!/bin/bash

rm -f /tmp/filler.bin

echo "$(date) - Disk Incident Cleared" \
>> /opt/SRE_Labs/incidents/logs/incidents.log