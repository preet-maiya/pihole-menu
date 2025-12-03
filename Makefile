PROJECT_ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
PIHOLE_DIR   := $(PROJECT_ROOT)/scripts/pihole
PLUGIN       := $(PROJECT_ROOT)/plugins/pihole.1s.sh
SWIFTBAR_PLUGIN_DIR ?= $(HOME)/Library/Application\ Support/SwiftBar/Plugins

.PHONY: setup install-plugin start stop restart dns-set dns-reset docker-start docker-stop logs

setup:
	mkdir -p $(PIHOLE_DIR)/etc-pihole
	chmod +x $(PIHOLE_DIR)/*.sh $(PLUGIN)

install-plugin: setup
	mkdir -p "$(SWIFTBAR_PLUGIN_DIR)"
	ln -sf "$(PLUGIN)" "$(SWIFTBAR_PLUGIN_DIR)/pihole.1s.sh"

start:
	bash "$(PIHOLE_DIR)/pihole.sh" start

stop:
	bash "$(PIHOLE_DIR)/pihole.sh" stop

restart:
	bash "$(PIHOLE_DIR)/pihole.sh" restart

dns-set:
	bash "$(PIHOLE_DIR)/pihole.sh" set_pihole_dns

dns-reset:
	bash "$(PIHOLE_DIR)/pihole.sh" reset_pihole_dns

docker-start:
	bash "$(PIHOLE_DIR)/docker-start.sh"

docker-stop:
	bash "$(PIHOLE_DIR)/docker-stop.sh"

logs:
	cd "$(PIHOLE_DIR)" && docker compose logs -f
