#!/bin/bash

echo "Injecting Database Outage..."

docker stop postgres

echo "Incident injected"