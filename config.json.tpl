{
    "log": {
        "loglevel": "info"
    },
    "dns": {
        "servers": [
            "dns"
        ]
    },
    "routing": {
        "rules": [
            {
                "type": "field",
                "port": 53,
                "outboundTag": "dns-out"
            }
        ],
        "domainStrategy": "AsIs"
    },
    "inbounds": [
        {
            "port": 443,
            "protocol": "vless",
            "tag": "vless_tls",
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
                    "dest": "www.microsoft.com:443",
                    "xver": 0,
                    "serverNames": [
                        "microsoft.com",
                        "www.microsoft.com"
                    ],
                    "privateKey": "$PRIVATE_KEY",
                    "minClientVer": "",
                    "maxClientVer": "",
                    "maxTimeDiff": 0,
                    "shortIds": [
                        "$SHORTID"
                    ]
                }
            },
            "sniffing": {
                "enabled": true,
                "destOverride": [
                    "http",
                    "tls",
                    "quic"
                ]
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
