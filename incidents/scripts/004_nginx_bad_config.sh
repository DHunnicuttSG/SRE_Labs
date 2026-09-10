#!/bin/bash

cat > /opt/SRE_Labs/docker/nginx/default.conf << EOF
server {

    listen 80;

    location / {

        proxy_pass http://does-not-exist;
    }
}
EOF

docker restart nginx

echo "$(date) - Nginx incident injected" \
>> /opt/SRE_Labs/incidents/logs/incidents.log