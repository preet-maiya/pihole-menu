#!/usr/bin/env bash
set -euo pipefail

PIHOLE_DIR="/Users/preethammaiya/projects/SwiftBar/scripts/pihole/"
IFACE="Wi-Fi"

flush_dns() {
  sudo /usr/bin/dscacheutil  -flushcache
  sudo /usr/bin/killall -HUP mDNSResponder || true
}

case "${1:-}" in
  start|up)
    cd "$PIHOLE_DIR"
    docker compose up -d

    sudo /usr/sbin/networksetup -setdnsservers "$IFACE" 127.0.0.1
    flush_dns
    ;;

  stop|down)
    cd "$PIHOLE_DIR"
    docker compose down

    # Clear custom DNS servers (revert to default / DHCP)
    sudo /usr/sbin/networksetup -setdnsservers "$IFACE" empty
    flush_dns
    ;;

  restart)
    cd "$PIHOLE_DIR"
    docker compose down
    docker compose up -d

    sudo /usr/sbin/networksetup -setdnsservers "$IFACE" 127.0.0.1
    flush_dns
    ;;

  set_pihole_dns)
    sudo /usr/sbin/networksetup -setdnsservers "$IFACE" 127.0.0.1
    flush_dns
    ;;

  reset_pihole_dns)
    # Clear custom DNS servers (revert to default / DHCP)
    sudo /usr/sbin/networksetup -setdnsservers "$IFACE" empty
    flush_dns
    ;;

  *)
    echo "Usage: $0 {start|stop|restart}"
    exit 1
    ;;
esac
