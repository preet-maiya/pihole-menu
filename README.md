# SwiftBar Pi-hole Plugin (macOS)

A SwiftBar menubar plugin and helper scripts that start, stop, and monitor a Pi-hole container running via Docker Desktop on macOS. Data persists under `scripts/pihole/etc-pihole` so you keep your settings between container restarts.

![macOS](https://img.shields.io/badge/macOS-000?logo=apple&logoColor=white) [![SwiftBar](https://img.shields.io/badge/SwiftBar-181717?logo=github&logoColor=white)](https://github.com/swiftbar/SwiftBar) ![Pi--hole](https://img.shields.io/badge/Pi--hole-8A0303?logo=pihole&logoColor=white) ![Docker](https://img.shields.io/badge/Docker-0db7ed?logo=docker&logoColor=white)

## Prerequisites
- ![macOS](https://img.shields.io/badge/macOS-000?logo=apple&logoColor=white) macOS only: this setup uses macOS-specific network commands and paths.
- [![SwiftBar](https://img.shields.io/badge/SwiftBar-181717?logo=github&logoColor=white)](https://github.com/swiftbar/SwiftBar) SwiftBar installed and configured ([download](https://swiftbar.app/)).
- ![Docker](https://img.shields.io/badge/Docker-0db7ed?logo=docker&logoColor=white) Docker Desktop for macOS running and CLI available ([download](https://www.docker.com/products/docker-desktop/)).
- `make` and standard macOS command-line tools.

## Setup
1. Clone or place this repository anywhere on your Mac. The scripts currently point to `/Users/preethammaiya/projects/SwiftBar`; if you keep the repo elsewhere, update the absolute paths in:
   - `plugins/pihole.1s.sh` (`PIHOLE_SCRIPT`, `DOCKER_START_SCRIPT`, `DOCKER_STOP_SCRIPT`, `ICON_BASE`)
   - `scripts/pihole/pihole.sh` (`PIHOLE_DIR`)
2. Configure the correct network interface name in `plugins/pihole.1s.sh` (`INTERFACE_NAME`) and `scripts/pihole/pihole.sh` (`IFACE`) if you do not use `Wi-Fi`.
3. (Recommended) Allow the helper commands to run without password prompts by adding this via `visudo` (replace `YOUR_USERNAME`):
   ```
   YOUR_USERNAME ALL=(root) NOPASSWD: /usr/sbin/networksetup, /usr/bin/dscacheutil, /usr/bin/killall
   ```
4. Create the persistent Pi-hole data directory and ensure helper scripts are executable:
   ```bash
   make setup
   ```
5. (Optional) Symlink the plugin into SwiftBar's plugin folder (be sure SwiftBar's Plugin Directory matches `SWIFTBAR_PLUGIN_DIR`, defaulting to `~/Library/Application Support/SwiftBar/Plugins`):
   ```bash
   make install-plugin
   ```
   By default this links to `~/Library/Application Support/SwiftBar/Plugins/pihole.1s.sh`; override `SWIFTBAR_PLUGIN_DIR` if needed.
6. Review `scripts/pihole/docker-compose.yml` and set `TZ`, `FTLCONF_webserver_api_password`, and any other Pi-hole environment variables you want.

## Usage
- Start Pi-hole and point macOS DNS to it: `make start`
- Stop Pi-hole and reset DNS: `make stop`
- Restart Pi-hole: `make restart`
- Force DNS to Pi-hole without touching Docker: `make dns-set`
- Reset DNS to DHCP/default without touching Docker: `make dns-reset`
- Start or stop Docker Desktop: `make docker-start` / `make docker-stop`
- Tail container logs: `make logs`

The SwiftBar menu will show the container status and expose the same actions.

## Data location
Persistent Pi-hole data lives in `scripts/pihole/etc-pihole/` (ignored by Git). The directory is created by `make setup`; do not delete it unless you are OK losing Pi-hole configuration.
