#!/bin/sh

PARAMS_FILE="client-params.env"

if [ ! -f "$PARAMS_FILE" ]; then
    echo "Ошибка: Файл $PARAMS_FILE не найден"
    exit 1
fi

source "$PARAMS_FILE"

if [ -z "$PUBLIC_KEY" ]; then
    echo "Ошибка: Переменная PUBLIC_KEY не установлена в файле $PARAMS_FILE"
    exit 1
fi

if [ -z "$CLIENT_UUID" ]; then
    echo "Ошибка: Переменная CLIENT_UUID не установлена в файле $PARAMS_FILE"
    exit 1
fi

if [ -z "$SHORT_IDS" ]; then
    echo "Ошибка: Переменная SHORT_IDS не установлена в файле $PARAMS_FILE"
    exit 1
fi

CONFIG_FILE="/app/xconfig.json"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Ошибка: Файл конфигурации $CONFIG_FILE не найден"
    exit 1
fi

cp "$CONFIG_FILE" /tmp/config.json.tmp

sed -i 's|\${SERVER_ADDRESS}|'"$SERVER_ADDRESS"'|g' /tmp/config.json.tmp
sed -i 's|\${CLIENT_UUID}|'"$CLIENT_UUID"'|g' /tmp/config.json.tmp
sed -i 's|\${PUBLIC_KEY}|'"$PUBLIC_KEY"'|g' /tmp/config.json.tmp
#sed -i 's|\${SHORT_IDS}|'"$SHORT_IDS"'|g' /tmp/config.json.tmp

if [ $? -ne 0 ]; then
    echo "Ошибка при модификации конфигурационного файла"
    exit 1
fi

cat /tmp/config.json.tmp > "$CONFIG_FILE"
