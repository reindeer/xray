#!/bin/bash
set -e

function setup() {
  source .env && [ ! -z $ID ] && echo "already configured" && return

  docker compose run --rm xray xray uuid | while read uuid; do echo "ID=$uuid" | tr -d '\r' >>.env; done
  docker compose run --rm xray xray x25519 | while read line; do echo ${line/ /_} | tr -d '\r' | awk -F': ' '{print toupper($1)"="$2}'; done >> .env
  echo SHORTID=$(openssl rand -hex 8) | tr -d '\r' >> .env
  [ ! -z $DOMAIN ] || echo DOMAIN=www.amazon.com >> .env
  [ ! -z $XHTTP_PATH ] || echo XHTTP_PATH=/download >> .env
  [ ! -z $XHTTP_MODE ] || echo XHTTP_MODE=auto >> .env

  config

  cat .env
}

function config() {
  for e in $(cat .env); do $(echo export $e); done
  envsubst < config.json.tpl > config.json
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

RECONFIGURE=0
while getopts "r" o; do
    case $o in
        r)
            RECONFIGURE=1
            ;;
        *)
            echo "Unknown argument $o"
            exit 1
            ;;
    esac
done
shift $((OPTIND-1))

touch .env
touch config.json
docker compose build
(setup)
[ "$RECONFIGURE" == "1" ] && (config)
(init)
docker compose up -d
