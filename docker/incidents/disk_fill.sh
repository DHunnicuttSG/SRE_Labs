#!/bin/bash

dd if=/dev/zero \
of=/tmp/filler.bin \
bs=100M \
count=20