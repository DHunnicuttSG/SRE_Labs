#!/bin/bash

case "$1" in

1)
    ./001_postgres_down.sh
    ;;

2)
    ./002_redis_down.sh
    ;;

3)
    ./003_flask_down.sh
    ;;

4)
    ./004_nginx_bad_config.sh
    ;;

5)
    ./005_disk_fill.sh
    ;;

*)
    echo "Usage: ./inject.sh [1-5]"
    ;;
esac