#!/usr/bin/env bash
set -euo pipefail

root_usage="$(/usr/bin/df -P / | /usr/bin/awk 'NR == 2 { print $5 }')"
printf 'DAILY_HEALTH timestamp=%s root_usage=%s\n' "$(/usr/bin/date -u +'%Y-%m-%dT%H:%M:%SZ')" "$root_usage"