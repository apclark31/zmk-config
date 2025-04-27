#!/bin/bash

set -e

# Root of your repo
REPO_ROOT=$(pwd)

echo "🚀 Setting up your ZMK Sofle V2 config at $REPO_ROOT"

# 1. Create west.yml
if [ ! -f "$REPO_ROOT/west.yml" ]; then
  echo "📄 Creating west.yml"
  cat << EOF > "$REPO_ROOT/west.yml"
manifest:
  projects:
    - name: zmk
      url: https://github.com/zmkfirmware/zmk.git
      revision: main
      import: app/west.yml
  self:
    path: config
EOF
else
  echo "✅ west.yml already exists, skipping"
fi

# 2. Create folders
echo "📁 Ensuring folder structure exists"
mkdir -p "$REPO_ROOT/config/keymaps/sofle"
mkdir -p "$REPO_ROOT/config/shields/sofle"

# 3. Download keymap.keymap
KEYMAP_PATH="$REPO_ROOT/config/keymaps/sofle/keymap.keymap"
if [ ! -f "$KEYMAP_PATH" ]; then
  echo "⬇️ Downloading keymap.keymap"
  curl -sSL -o "$KEYMAP_PATH" https://raw.githubusercontent.com/ergomechstore/sofle-v2-oled-zmk/main/config/keymap.keymap
else
  echo "✅ keymap.keymap already exists, skipping"
fi

# 4. Download shield.conf
SHIELD_CONF_PATH="$REPO_ROOT/config/shields/sofle/shield.conf"
if [ ! -f "$SHIELD_CONF_PATH" ]; then
  echo "⬇️ Downloading shield.conf"
  curl -sSL -o "$SHIELD_CONF_PATH" https://raw.githubusercontent.com/ergomechstore/sofle-v2-oled-zmk/main/config/shield.conf
else
  echo "✅ shield.conf already exists, skipping"
fi

# 5. Download sofle.overlay
SOFLE_OVERLAY_PATH="$REPO_ROOT/config/shields/sofle/sofle.overlay"
if [ ! -f "$SOFLE_OVERLAY_PATH" ]; then
  echo "⬇️ Downloading sofle.overlay"
  curl -sSL -o "$SOFLE_OVERLAY_PATH" https://raw.githubusercontent.com/ergomechstore/sofle-v2-oled-zmk/main/config/sofle.overlay
else
  echo "✅ sofle.overlay already exists, skipping"
fi

# 6. Clean OLED display references from sofle.overlay
echo "🧹 Cleaning OLED references from sofle.overlay if needed"
sed -i.bak '/&display_left/,/};/d' "$SOFLE_OVERLAY_PATH"
sed -i.bak '/&display_right/,/};/d' "$SOFLE_OVERLAY_PATH"
rm -f "$SOFLE_OVERLAY_PATH.bak"

echo "🎉 Setup complete!"