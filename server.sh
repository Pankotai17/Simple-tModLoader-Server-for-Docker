#!/bin/bash

files=$(curl -s https://api.github.com/repos/tModLoader/tModLoader/releases/latest | grep "browser_download_url.*tModLoader.zip" | cut -d '"' -f 4)

wget "$files" -O tModLoader.zip
unzip -o tModLoader.zip
rm tModLoader.zip
chmod u+x start-tModLoaderServer.sh

CONFIG_PATH="/usr/local/tml-server/serverconfig.txt"
WORLDS_DIR="/usr/local/tml-server/worlds"
MODS_DIR="/usr/local/tml-server/mods"
ENABLED_JSON="${MODS_DIR}/enabled.json"

mkdir -p "$WORLDS_DIR"
mkdir -p "$MODS_DIR"

if [[ ! -f "$ENABLED_JSON" ]]; then
  echo "enabled.json not found. Generating for all mods in ${MODS_DIR}..."
  
  mod_list=$(find "$MODS_DIR" -maxdepth 1 -name "*.tmod" -exec basename {} .tmod \;)
  
  if [[ -n "$mod_list" ]]; then
    echo "$mod_list" | jq -R . | jq -s . > "$ENABLED_JSON"
    echo "Generated enabled.json:"
    cat "$ENABLED_JSON"
  else
    echo "[]" > "$ENABLED_JSON"
    echo "No mods found in ${MODS_DIR}. Created empty enabled.json."
  fi
fi

rm -f "$CONFIG_PATH"

add_config() {
  local key="$1"
  local value="$2"
  if [[ -n "$value" ]]; then
    echo "${key}=${value}" >> "$CONFIG_PATH"
  fi
}

add_config "worldpath"   "$WORLDS_DIR"
add_config "modpath"     "$MODS_DIR"

add_config "worldname"   "$WORLD_NAME"
if [[ -n "$WORLD_NAME" ]]; then
  add_config "world"     "${WORLDS_DIR}/${WORLD_NAME}.wld"
fi

add_config "autocreate"  "$AUTOCREATE"
add_config "seed"        "$SEED"
add_config "difficulty"  "$DIFFICULTY"
add_config "maxplayers"  "$MAX_PLAYERS"
add_config "password"    "$PASSWORD"
add_config "motd"        "$MOTD"
add_config "language"    "$LANGUAGE"

exec ./start-tModLoaderServer.sh -config "$CONFIG_PATH" -nosteam "$@"