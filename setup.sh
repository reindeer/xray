#!/bin/bash

touch .env
source .env && [ ! -z $ID ] && echo "already configured" && exit 1

touch config.json
docker-compose build
docker-compose run --rm xray xray uuid | while read uuid; do echo "ID=$uuid" | tr -d '\r' >> .env; done
docker-compose run --rm xray xray x25519 | while read line; do echo ${line/ /_} | tr -d '\r' | awk -F': ' '{print toupper($1)"="$2}'; done >> .env
echo SHORTID=$(openssl rand -hex 8) | tr -d '\r' >> .env

for e in $(cat .env); do $(echo export $e); done
envsubst < config.json.tpl > config.json
