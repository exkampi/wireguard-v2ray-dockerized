#!/bin/sh

UUID=$(cat /proc/sys/kernel/random/uuid)
jq --arg uuid "$UUID" '.inbounds[0].settings.clients[0].id = $uuid' /app/v2ray/config.json > /tmp/config.json
mv /tmp/config.json /app/v2ray/config.json