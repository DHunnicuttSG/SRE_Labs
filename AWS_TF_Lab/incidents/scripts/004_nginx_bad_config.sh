#!/bin/bash

cat > /opt/SRE_Labs/AWS_TF_Lab/docker/nginx/default.conf << EOF
server {

    listen 80;

    location / {

        proxy_pass http://does-not-exist;
    }
}
EOF

docker restart nginx

echo "$(date) - Nginx incident injected" \
>> /opt/SRE_Labs/AWS_TF_Lab/incidents/logs/incidents.log