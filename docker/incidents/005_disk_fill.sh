#!/bin/bash

echo "Filling Disk..."

fallocate -l 2G /tmp/filler.bin

echo "Disk Filled"
