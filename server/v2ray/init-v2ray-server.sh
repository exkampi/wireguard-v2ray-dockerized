#!/bin/sh

UUID=$(cat /proc/sys/kernel/random/uuid)
sed -i "s/\"id\": \"[^\"]*\"/\"id\": \"$UUID\"/" /app/v2config.json