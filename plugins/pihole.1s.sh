#!/bin/bash

MENU_TITLE=""
PIHOLE_SCRIPT="/Users/preethammaiya/projects/SwiftBar/scripts/pihole/pihole.sh"
DOCKER_START_SCRIPT="/Users/preethammaiya/projects/SwiftBar/scripts/pihole/docker-start.sh"
DOCKER_STOP_SCRIPT="/Users/preethammaiya/projects/SwiftBar/scripts/pihole/docker-stop.sh"
ICON_BASE="/Users/preethammaiya/projects/SwiftBar/icons/pihole"
INTERFACE_NAME="Wi-Fi"   # change here if you ever rename your interface

b64() {
  base64 -i "$1" | tr -d '\n'
}

DOCKER_ICON_B64=$(b64 "$ICON_BASE/docker.png")
DOCKER_WARN_B64=$(b64 "$ICON_BASE/docker-warn.png")
PIHOLE_ON_B64=$(b64 "$ICON_BASE/pihole-on.png")
PIHOLE_OFF_B64=$(b64 "$ICON_BASE/pihole-off.png")

# --- Check DNS configuration (is Pi-hole actually being used?) ---
DNS_RAW=$(/usr/sbin/networksetup -getdnsservers "$INTERFACE_NAME" 2>/dev/null)

if echo "$DNS_RAW" | grep -q "127.0.0.1"; then
  DNS_OK=true
  DNS_STATUS_LINE="🟢 DNS: 127.0.0.1 (Pi-hole active)"
else
  DNS_OK=false
  if echo "$DNS_RAW" | grep -qi "There aren't any DNS Servers set"; then
    DNS_STATUS_LINE="🔴 DNS: no DNS servers set"
  else
    # Could be multiple lines / servers; show briefly but mark red
    DNS_STATUS_LINE="🔴 DNS: not pointing to 127.0.0.1"
  fi
fi

# --- Check if Docker is running ---
if ! docker info >/dev/null 2>&1; then
  # Menubar: Pi-hole "off" icon (your choice)
  echo "$MENU_TITLE | image=$PIHOLE_OFF_B64"

  echo "---"
  echo "Docker is not running. | image=$DOCKER_WARN_B64"
  echo "Please start Docker Desktop first."
  echo "Start Docker Desktop | bash='$DOCKER_START_SCRIPT' terminal=false refresh=true"
  echo "---"
  echo "$DNS_STATUS_LINE"
  echo "Pi-hole controls unavailable (Docker is stopped)"
  exit 0
fi

# --- Docker is running: check Pi-hole container ---
if docker ps | grep -q "pihole"; then
  ICON_B64="$PIHOLE_ON_B64"
  STATUS="Running"
else
  ICON_B64="$PIHOLE_OFF_B64"
  STATUS="Stopped"
fi

# Menubar line: Pi-hole icon (on/off), no text
echo "$MENU_TITLE | image=$ICON_B64"

echo "---"
echo "Docker: running | image=$DOCKER_ICON_B64"
echo "Stop Docker Desktop | bash='$DOCKER_STOP_SCRIPT' terminal=false refresh=true"
echo "---"
echo "Pi-hole: $STATUS"
echo "$DNS_STATUS_LINE"
echo "---"
echo "Start Pi-hole     | bash='$PIHOLE_SCRIPT' param1=start            terminal=false refresh=true"
echo "Stop Pi-hole      | bash='$PIHOLE_SCRIPT' param1=stop             terminal=false refresh=true"
echo "Restart Pi-hole   | bash='$PIHOLE_SCRIPT' param1=restart          terminal=false refresh=true"
echo "Set Pi-hole DNS   | bash='$PIHOLE_SCRIPT' param1=set_pihole_dns   terminal=false refresh=true"
echo "Reset Pi-hole DNS | bash='$PIHOLE_SCRIPT' param1=reset_pihole_dns terminal=false refresh=true"
echo "---"
