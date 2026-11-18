#!/usr/bin/env bash
# Setup helper for running Detroit: Become Human on an Apple Silicon Mac, for free.
# Installs Rosetta 2 and Whisky (free Wine wrapper). UNTESTED on real hardware.
# Run on your Mac:  bash setup.sh
set -euo pipefail

[[ "$(uname -s)" == "Darwin" ]] || { echo "Run this on your Mac, not Linux."; exit 1; }
[[ "$(uname -m)" == "arm64" ]] || { echo "This script targets Apple Silicon (M1+)."; exit 1; }

RAM_GB=$(( $(sysctl -n hw.memsize) / 1024 / 1024 / 1024 ))
echo "Detected ${RAM_GB} GB RAM."
if (( RAM_GB < 16 )); then
  echo "WARNING: with ${RAM_GB} GB the game will likely swap heavily and be unplayable."
  read -r -p "Continue anyway? [y/N] " a; [[ "$a" =~ ^[Yy]$ ]] || exit 0
fi

echo "Installing Rosetta 2 (needed by Wine)..."
softwareupdate --install-rosetta --agree-to-license || true

if ! command -v brew >/dev/null; then
  echo "Homebrew not found. Install it from https://brew.sh then re-run this script."
  exit 1
fi

echo "Installing Whisky..."
brew install --cask whisky

cat <<'MSG'

Done. Next steps (see README.md for details):
 1. Open Whisky -> Create Bottle (Windows 10).
 2. Install Steam into the bottle, then install Detroit: Become Human.
 3. Apply the settings tweaks in README.md and launch.
MSG
