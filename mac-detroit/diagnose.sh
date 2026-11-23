#!/usr/bin/env bash
# Collects system + Vulkan info to find out why Detroit: Become Human won't launch via MoltenVK.
# Run on your Mac:  bash diagnose.sh
# Writes a report to your Desktop. Contains hardware/OS info only (no personal files).
# UNTESTED on real hardware.
set -uo pipefail
[[ "$(uname -s)" == "Darwin" ]] || { echo "Run this on your Mac."; exit 1; }

OUT="$HOME/Desktop/detroit-diagnostics-$(date +%Y%m%d-%H%M%S).txt"
section() { printf '\n===== %s =====\n' "$1" >> "$OUT"; }
run() { section "$*"; "$@" >> "$OUT" 2>&1 || echo "(command failed: $*)" >> "$OUT"; }

: > "$OUT"
run sw_vers
run uname -m
run sysctl -n machdep.cpu.brand_string
run sysctl -n hw.memsize

if command -v brew >/dev/null; then
  for pkg in molten-vk vulkan-tools; do
    brew list --versions "$pkg" >/dev/null 2>&1 || { echo "Installing $pkg..."; brew install "$pkg"; }
  done
  PREFIX="$(brew --prefix)"
  export VK_ICD_FILENAMES="$PREFIX/etc/vulkan/icd.d/MoltenVK_icd.json"
  run brew list --versions molten-vk vulkan-tools
  if command -v vulkaninfo >/dev/null; then
    section "vulkaninfo --summary (what MoltenVK offers natively on this Mac)"
    vulkaninfo --summary >> "$OUT" 2>&1 || echo "(failed)" >> "$OUT"
    section "vulkaninfo (full, filtered: version/features/extensions of interest)"
    vulkaninfo 2>&1 | grep -E -i 'apiVersion|driverVersion|geometryShader|tessellationShader|shaderClipDistance|shaderCullDistance|sampleRateShading|depthClamp|independentBlend|fillModeNonSolid|multiDrawIndirect|drawIndirectFirstInstance|samplerAnisotropy|textureCompressionBC|VK_KHR|VK_EXT' >> "$OUT" || true
  fi
else
  echo "Homebrew not found; skipping Vulkan checks." | tee -a "$OUT"
fi

section "recent crash reports mentioning wine/detroit/sikarugir"
ls -t "$HOME/Library/Logs/DiagnosticReports" 2>/dev/null | grep -i -E 'wine|detroit|sikarugir|dxmt|steam' | head -10 >> "$OUT"

echo "Done. Report saved to: $OUT"
echo "Also capture the game launch log (see README, 'Finding the real failure')."
