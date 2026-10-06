#!/bin/bash

case "$1" in

postgres)
    ./scripts/001_postgres_down.sh
    ;;

redis)
    ./scripts/002_redis_down.sh
    ;;

flask)
    ./scripts/003_flask_down.sh
    ;;

nginx)
    ./scripts/004_nginx_bad_config.sh
    ;;

disk)
    ./scripts/005_disk_fill.sh
    ;;

*)
    echo ""
    echo "Usage:"
    echo ""
    echo "./inject.sh postgres"
    echo "./inject.sh redis"
    echo "./inject.sh flask"
    echo "./inject.sh nginx"
    echo "./inject.sh disk"
    ;;
esac