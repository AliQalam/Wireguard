#!/bin/bash
# سكربت تثبيت Docker و WireGuard + WireGuard-UI على Ubuntu

set -e

echo "=== تحديث النظام وتثبيت المتطلبات ==="
sudo apt update && sudo apt install -y ca-certificates curl gnupg lsb-release nano

echo "=== إنشاء مجلد keyrings وتحميل مفتاح Docker ==="
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "=== إضافة مستودع Docker ==="
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "=== تثبيت Docker ==="
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

echo "=== إنشاء مجلد WireGuard-UI ==="
mkdir -p ~/wireguard-ui
cd ~/wireguard-ui

echo "=== إنشاء ملف docker-compose.yml ==="
cat > docker-compose.yml <<'EOF'
version: "3"

services:

  wireguard:
    image: linuxserver/wireguard:v1.0.20210914-ls7
    container_name: wireguard
    cap_add:
      - NET_ADMIN
    volumes:
      - ./config:/config
    ports:
      - "5000:5000"
      - "51829:51829/udp"

  wireguard-ui:
    image: ngoduykhanh/wireguard-ui:latest
    container_name: wireguard-ui
    depends_on:
      - wireguard
    cap_add:
      - NET_ADMIN
    network_mode: service:wireguard
    environment:
      - SENDGRID_API_KEY
      - EMAIL_FROM_ADDRESS
      - EMAIL_FROM_NAME
      - SESSION_SECRET
      - WGUI_USERNAME=admin
      - WGUI_PASSWORD=password
      - WG_CONF_TEMPLATE
      - WGUI_MANAGE_START=true
      - WGUI_MANAGE_RESTART=true
    logging:
      driver: json-file
      options:
        max-size: 50m
    volumes:
      - ./db:/app/db
      - ./config:/etc/wireguard
EOF

echo "=== تشغيل الحاويات ==="
sudo docker compose up -d

echo "=== تم التثبيت بنجاح! ==="
echo "يمكنك الآن الوصول إلى WireGuard-UI باستخدام المستخدم: admin وكلمة المرور: password"
echo "@star1ink_1raq"
echo "@starlink1raq_group"
