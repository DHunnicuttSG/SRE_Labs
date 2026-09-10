#!/bin/bash

case "$1" in

postgres)
    ./restore/001_postgres_restore.sh
    ;;

redis)
    ./restore/002_redis_restore.sh
    ;;

flask)
    ./restore/003_flask_restore.sh
    ;;

nginx)
    ./restore/004_nginx_restore.sh
    ;;

disk)
    ./restore/005_disk_cleanup.sh
    ;;

*)
    echo ""
    echo "Usage:"
    echo ""
    echo "./restore.sh postgres"
    echo "./restore.sh redi*"
    echo "./restore.sh flask"
    echo "./restore.sh nginx"
    ech* "./restore.sh disk"
    ;;
esac