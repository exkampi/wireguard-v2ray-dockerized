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

cp "$CONFIG_FILE" /tmp/config.json.tmp

sed -i 's/"address": "SERVER_PUBLIC_IP_REQUIRED"/"address": "'"$SERVER_IP"'"/g' /tmp/config.json.tmp
sed -i 's/"id": "UUID_REQUIRED"/"id": "'"$UUID"'"/g' /tmp/config.json.tmp

if [ $? -ne 0 ]; then
    echo "Ошибка при модификации конфигурационного файла"
    exit 1
fi

cat /tmp/config.json.tmp > "$CONFIG_FILE"

v2ray test -c "$CONFIG_FILE"
if [ $? -ne 0 ]; then
    echo "Ошибка в конфигурационном файле. Запуск отменен."
    exit 1
fi

exec v2ray run -c "$CONFIG_FILE"
