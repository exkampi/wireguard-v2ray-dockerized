#!/bin/sh

UUID=$(cat /proc/sys/kernel/random/uuid)
jq --arg uuid "$UUID" '.inbounds[0].settings.clients[0].id = $uuid' /etc/v2ray/config.json > /tmp/config.json
mv /tmp/config.json /etc/v2ray/config.json
exec v2ray -config=/etc/v2ray/config.json
