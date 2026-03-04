#!/bin/bash
set -e

function setup() {
  source .env && [ ! -z $ID ] && echo "already configured" && return

  docker-compose run --rm xray xray uuid | while read uuid; do echo "ID=$uuid" | tr -d '\r' >> .env; done
  docker-compose run --rm xray xray x25519 | while read line; do echo ${line/ /_} | tr -d '\r' | awk -F': ' '{print toupper($1)"="$2}'; done >> .env
  echo SHORTID=$(openssl rand -hex 8) | tr -d '\r' >> .env

  for e in $(cat .env); do $(echo export $e); done
  envsubst < config.json.tpl > config.json

  cat .env
}

function init() {
  if [[ $(sysctl -n net.core.default_qdisc) != "fq" ]]; then
      sed -i '/net.core.default_qdisc/d' /etc/sysctl.conf
      echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
  fi

  if [[ $(sysctl -n net.ipv4.tcp_congestion_control) != "bbr" ]]; then
      sed -i '/net.ipv4.tcp_congestion_control/d' /etc/sysctl.conf
      echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
  fi
  
  sysctl -p
}

touch .env
touch config.json
docker-compose build
(setup)
(init)
docker-compose up -d
