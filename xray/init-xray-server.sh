#!/bin/sh

# Generate X25519 keys using Xray's built-in command
_x25519=$(xray x25519)
PRIVATE_KEY=$(echo "$_x25519" | awk -F': ' '/Private key/{print $2}')
PUBLIC_KEY=$(echo "$_x25519" | awk -F': ' '/Public key/{print $2}')

# Generate a unique UUID for the client
CLIENT_UUID=$(uuidgen)

# Generate a random short ID
SHORT_IDS=$(openssl rand -hex 8)

SERVER_ADDRESS=$(curl -s https://api.ipify.org?format=text)
if [ -z "$SERVER_ADDRESS" ]; then
    echo "Ошибка: Не удалось получить публичный IP-адрес"
    exit 1
fi

CONFIG_FILE="/app/xconfig.json"

sed -i "s|\${CLIENT_UUID}|$CLIENT_UUID|g" "$CONFIG_FILE"
sed -i "s|\${PRIVATE_KEY}|$PRIVATE_KEY|g" "$CONFIG_FILE"

printf "PUBLIC_KEY=%s\nCLIENT_UUID=%s\nSHORT_IDS=%s\nSERVER_ADDRESS=%s\n" "$PUBLIC_KEY" "$CLIENT_UUID" "$SHORT_IDS" "$SERVER_ADDRESS" > client-params.env
