#!/bin/bash

docker run \
--rm \
python:3.12 \
python -c '
x=[]
while True:
    x.append("A"*1000000)
'