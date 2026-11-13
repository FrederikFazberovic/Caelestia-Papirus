#!/usr/bin/env bash
set -e

USER_HOME=$(eval echo ~$USER)
BIN_DIR="$USER_HOME/.local/bin"
SERVICE_FILE="$USER_HOME/.config/systemd/user/caelestia-pap-icons.service"
TEMPLATE_DIR="$USER_HOME/.config/matugen/templates"
CONF_DIR=$USER_HOME/.config/matugen

mkdir -p "$BIN_DIR" "$USER_HOME/.config/systemd/user" "$TEMPLATE_DIR" "$CONF_DIR"

cat >>"$CONF_DIR/config.toml" <<'EOF'

[config]

[templates.papirus-folders]
input_path = "~/.config/matugen/templates/caelestia-papirus-color"
colors_to_compare = [
    { name = "black",      color = "#4f4f4f" },
    { name = "blue",       color = "#5294e2" },
    { name = "bluegrey",   color = "#607d8b" },
    { name = "brown",      color = "#ae8e6c" },
    { name = "carmine",    color = "#a30002" },
    { name = "cyan",       color = "#00bcd4" },
    { name = "darkcyan",   color = "#45abb7" },
    { name = "deeporange", color = "#eb6637" },
    { name = "green",      color = "#87b158" },
    { name = "grey",       color = "#9e9e9e" },
    { name = "indigo",     color = "#3f51b5" },
    { name = "magenta",    color = "#e91e63" },
    { name = "nordic",     color = "#5e81ac" },
    { name = "orange",     color = "#f39c12" },
    { name = "palebrown",  color = "#b08968" },
    { name = "paleorange", color = "#e8a87c" },
    { name = "pink",       color = "#f48fb1" },
    { name = "red",        color = "#e53935" },
    { name = "teal",       color = "#009688" },
    { name = "violet",     color = "#7e57c2" },
    { name = "white",      color = "#f5f5f5" },
    { name = "yellow",     color = "#f9bd30" },
]
compare_to = "{{ colors.primary.default.hex }}"
post_hook = 'nohup sudo -n papirus-folders -C {{ closest_color }} --theme Papirus-Dark >/dev/null 2>&1 &'
index = 1
EOF

echo "Installed matugen config."

cat <<'TEMPLATESEOF' >"$TEMPLATE_DIR/caelestia-papirus-color"
[Colors]
primary = "{{ colors.primary.default.hex }}"
TEMPLATESEOF

echo "Installed template in $TEMPLATE_DIR/caelestia-papirus-color"

cat <<'BASHEOF' >"$BIN_DIR/caelestia-pap-icons"
#!/usr/bin/env bash
SOURCE="$HOME/.local/state/caelestia/wallpaper/thumbnail.jpg"

convert_theme() {
  if [ -f "$SOURCE" ]; then
    echo "changing"
    matugen image "$SOURCE"
  fi
}

last_hash=""
while true; do
  if [ -f "$SOURCE" ]; then
    current_hash=$(md5sum "$SOURCE")
    if [ "$current_hash" != "$last_hash" ]; then
      convert_theme
      last_hash="$current_hash"
    fi
  fi
  sleep 2
done
BASHEOF

chmod +x "$BIN_DIR/caelestia-pap-icons"
echo "Installed caelestia-pap-icons in $BIN_DIR"

printf "[Unit]\nDescription=Caelestia Papirus Icon converter\n\n[Service]\nExecStart=%s/caelestia-pap-icons\nRestart=always\n\n[Install]\nWantedBy=default.target\n" "$BIN_DIR" >"$SERVICE_FILE"
echo "Installed systemd service in $SERVICE_FILE"

systemctl --user daemon-reload
systemctl --user enable --now caelestia-pap-icons
echo "Service enabled and started."
echo "Installation complete."
