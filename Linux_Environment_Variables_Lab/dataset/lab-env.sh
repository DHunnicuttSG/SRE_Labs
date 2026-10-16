#!/usr/bin/env bash

export APP_NAME='payments-api'
export APP_ENV='production'
export APP_REGION='us-east-1'
export APP_LOG_LEVEL='warning'
export APP_CONFIG="$HOME/environment_variables_practice/config/runtime.conf"

lab_bin="$HOME/environment_variables_practice/bin"
case ":$PATH:" in
	*":$lab_bin:"*) ;;
	*) export PATH="$lab_bin:$PATH" ;;
esac
