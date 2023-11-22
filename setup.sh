#!/bin/bash

[ -f .env ] && source .env && [ ! -z $ID ] && echo "already configured" && exit 1

touch config.json
docker-compose build
docker-compose run xray xray uuid | while read uuid; do echo "ID=$uuid" >> .env; done
docker-compose run xray xray x25519 | while read line; do echo $(echo $line | awk -F': ' '{print $1}' | tr 'a-z ' 'A-Z_')=$(echo $line | awk -F': ' '{print $2}'); done >> .env
echo SHORTID=$(openssl rand -hex 8)
source .env
envsubst < config.json.tpl > config.json
