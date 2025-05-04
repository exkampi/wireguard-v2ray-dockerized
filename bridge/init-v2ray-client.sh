#!/bin/bash

if [ -z "$UUID" ]; then
    echo "Ошибка: Переменная UUID не установлена"
    exit 1
fi

if [ -z "$SERVER_IP" ]; then
    echo "Ошибка: Переменная SERVER_IP не установлена"
    exit 1
fi

CONFIG_FILE="/etc/v2ray/config.json"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Ошибка: Файл конфигурации $CONFIG_FILE не найден"
    exit 1
fi

jq --arg uuid "$UUID" --arg server_ip "$SERVER_IP" '.outbounds[0].settings.vnext[0].address = $server_ip | .outbounds[0].settings.vnext[0].users[0].id = $uuid' "$CONFIG_FILE" > /tmp/config.json.tmp

if [ $? -ne 0 ]; then
    echo "Ошибка при модификации конфигурационного файла"
    exit 1
fi

mv /tmp/config.json.tmp "$CONFIG_FILE"

v2ray -test -config="$CONFIG_FILE"
if [ $? -ne 0 ]; then
    echo "Ошибка в конфигурационном файле. Запуск отменен."
    exit 1
fi

exec v2ray -config="$CONFIG_FILE"