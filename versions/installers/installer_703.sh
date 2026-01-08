#!/bin/bash

set -e

HYDROGEN_INSTALLER_URL="https://raw.githubusercontent.com/soulsploits/Hydrogen-Archive/main/versions/files/hydrogen_703"

HYDROGEN_M_URL="https://raw.githubusercontent.com/soulsploits/Hydrogen-Archive/main/versions/files/ui_703.zip"

ROBLOX_URL_ARM="https://setup.rbxcdn.com/mac/arm64/version-d0722e371e604117-RobloxPlayer.zip"
ROBLOX_URL_X86="https://setup.rbxcdn.com/mac/version-d0722e371e604117-RobloxPlayer.zip"

TMP_DIR="/tmp"
INSTALLER_BIN="$TMP_DIR/hydrogen_installer"

info() {
  echo "[*] $1"
}

error_exit() {
  echo "Error: $1" >&2
  exit 1
}

success() {
  echo "[✔] $1"
}

info "Killing old processes..."
ps aux | grep '/Applications/Hydrogen-M.app' | grep -v grep | awk '{print $2}' | while read pid; do
  echo "Killing PID: $pid"
  kill -9 "$pid"
done

rm -rf /Applications/Hydrogen-M.app

ps aux | grep '/Applications/Hydrogen.app' | grep -v grep | awk '{print $2}' | while read pid; do
  echo "Killing PID: $pid"
  kill -9 "$pid"
done

ps aux | grep '/Applications/Roblox.app' | grep -v grep | awk '{print $2}' | while read pid; do
  echo "Killing PID: $pid"
  kill -9 "$pid"
done

# 1. Download the Rust installer binary
info "Downloading Hydrogen installer..."
curl -fsSL "$HYDROGEN_INSTALLER_URL" -o "$INSTALLER_BIN"
chmod +x "$INSTALLER_BIN"

# 2. Run it with the appropriate arguments
info "Running installer..."
"$INSTALLER_BIN" \
  --hydrogen-url "$HYDROGEN_M_URL" \
  --roblox-url-arm "$ROBLOX_URL_ARM" \
  --roblox-url-x86 "$ROBLOX_URL_X86"

# 3. Clean up
info "Cleaning up installer binary..."
rm -f "$INSTALLER_BIN"

defaults delete com.roblox.RobloxPlayer       2>/dev/null || true
defaults delete com.roblox.RobloxStudio       2>/dev/null || true
defaults delete com.roblox.Retention          2>/dev/null || true
defaults delete com.roblox.RobloxStudioChannel 2>/dev/null || true
defaults delete com.roblox.RobloxPlayerChannel 2>/dev/null || true
killall cfprefsd 2>/dev/null || true

# 4. Done
success "Installed Hydrogen v703,"
echo "For more questions, join https://discord.gg/rMfDdfYWpx."
