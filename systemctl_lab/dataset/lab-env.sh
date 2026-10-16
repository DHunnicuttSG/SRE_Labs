#!/usr/bin/env bash

lab_bin="$HOME/systemctl_practice/bin"
case ":$PATH:" in
  *":$lab_bin:"*) ;;
  *) export PATH="$lab_bin:$PATH" ;;
esac
