{
    "log": {
        "loglevel": "info"
    },
    "dns": {
        "servers": [
            "dns"
        ],
        "queryStrategy": "UseIPv4"
    },
    "routing": {
        "rules": [
            {
                "type": "field",
                "port": 53,
                "outboundTag": "dns-out"
            }
        ],
        "domainStrategy": "IPIfNonMatch"
    },
    "inbounds": [
        {
            "port": 443,
            "protocol": "vless",
            "settings": {
                "clients": [
                    {
                        "id": "$ID",
                        "flow": "xtls-rprx-vision"
                    }
                ],
                "decryption": "none"
            },
            "streamSettings": {
                "network": "tcp",
                "security": "reality",
                "realitySettings": {
                    "show": false,
                    "dest": "$DOMAIN:443",
                    "xver": 0,
                    "serverNames": [
                        "$DOMAIN"
                    ],
                    "privateKey": "$PRIVATE_KEY",
                    "shortIds": [
                        "$SHORTID",
                        ""
                    ]
                },
                "xhttpSettings": {
                    "host": "$DOMAIN",
                    "path": "$XHTTP_PATH",
                    "mode": "$XHTTP_MODE"
                },
                "sockopt": {
                    "tcpFastOpen": true,
                    "tcpKeepAliveInterval": 7200
                },
            },
            "sniffing": {
                "enabled": true,
                "destOverride": [
                    "http",
                    "tls"
                ],
                "metadataOnly": false,
                "routeOnly": true
            }
        }
    ],
    "outbounds": [
        {
            "protocol": "freedom",
            "tag": "direct"
        },
        {
            "protocol": "blackhole",
            "tag": "block"
        },
        {
            "protocol": "dns",
            "tag": "dns-out"
        }
    ]
}
