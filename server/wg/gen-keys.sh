#!/bin/bash

mkdir -p ./keys
chmod 700 ./keys

wg genkey | tee ./keys/server-privatekey | wg pubkey > ./keys/server-publickey
wg genkey | tee ./keys/client-privatekey | wg pubkey > ./keys/client-publickey

chmod 600 ./keys/*-privatekey
chmod 644 ./keys/*-publickey

SERVER_PRIVATE_KEY=$(cat ./keys/server-privatekey)
SERVER_PUBLIC_KEY=$(cat ./keys/server-publickey)
CLIENT_PRIVATE_KEY=$(cat ./keys/client-privatekey)
CLIENT_PUBLIC_KEY=$(cat ./keys/client-publickey)

sed -i "s|WIREGUARD_SERVER_PRIVATE_KEY|${SERVER_PRIVATE_KEY}|g" ./wg/wg0.conf
sed -i "s|WIREGUARD_CLIENT_PUBLIC_KEY|${CLIENT_PUBLIC_KEY}|g" ./wg/wg0.conf

sed -i "s|WIREGUARD_CLIENT_PRIVATE_KEY|${CLIENT_PRIVATE_KEY}|g" ../client/client.conf
sed -i "s|WIREGUARD_SERVER_PUBLIC_KEY|${SERVER_PUBLIC_KEY}|g" ../client/client.conf
