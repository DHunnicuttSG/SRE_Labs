#!/usr/bin/env bash
set -euo pipefail

printf 'HEARTBEAT timestamp=%s host=%s\n' "$(/usr/bin/date -u +'%Y-%m-%dT%H:%M:%SZ')" "$(/usr/bin/hostname)"