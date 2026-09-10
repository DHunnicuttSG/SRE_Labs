#!/bin/bash

cat > /opt/SRE_Labs/docker/nginx/default.conf << EOF

server {

    listen 80;

    location / {

        proxy_pass http://not-a-real-server;
    }
}
EOF

docker restart nginx

echo "Bad Nginx Config Injected"