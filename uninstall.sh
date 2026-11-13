#!/usr/bin/env bash

USER_HOME=$(eval echo ~$USER)
BIN_DIR="$USER_HOME/.local/bin"
SERVICE_FILE="$USER_HOME/.config/systemd/user/caelestia-pap-icons.service"
TEMPLATE_FILE="$USER_HOME/.config/matugen/templates/caelestia-papirus-color"

echo "Stopping and disabling systemd service..."
systemctl --user stop caelestia-pap-icons 2>/dev/null || true
systemctl --user disable caelestia-pap-icons 2>/dev/null || true
rm -f "$SERVICE_FILE"

echo "Removing converter script..."
rm -f "$BIN_DIR/caelestia-pap-icons"

echo "Removing theme template..."
rm -f "$TEMPLATE_FILE"

echo "Reloading systemd daemon..."
systemctl --user daemon-reload

echo "Uninstallation complete."
