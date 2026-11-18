# Detroit: Become Human on an M1 Mac (free)

Approach: Whisky (free Wine wrapper) + your own copy of the game on Steam/Epic.
Detroit uses Vulkan on PC, which translates to Metal via DXVK/MoltenVK.

**Not tested on real hardware by the author. Results vary; treat settings as a starting point.**

## Requirements
- Apple Silicon Mac (M1+), **16 GB RAM strongly recommended** (8 GB will likely not work)
- ~60 GB free disk (game is ~55 GB)
- Game owned on Steam or Epic

## Install
    bash setup.sh

## Bottle setup (in Whisky)
1. Create a bottle, Windows 10.
2. Bottle config: enable **DXVK**, enable **Metal HUD** (optional, shows FPS).
3. Download the Steam installer (SteamSetup.exe) and run it via "Run..." in the bottle.
4. If the Steam window is blank/black, set Steam launch args (Program settings):
   `-no-cef-sandbox -cef-disable-gpu`
5. Install Detroit: Become Human and launch.

## In-game settings for M1
- Resolution 1280x720 (or lower), fullscreen off/windowed
- Everything on Low, shadows off or low, SSAO off, anti-aliasing off
- Turn off V-sync and cap fps at 30
- Close all other apps (browser especially) before playing

## Troubleshooting
- Black screen / crash at launch: toggle DXVK, try Windows 10 vs 11 setting
- Crashes after a while: memory pressure; lower resolution, reboot Mac, close apps
- Steam won't start: apply the launch args above
- If Whisky is unmaintained/broken on your macOS version, alternatives: Sikarugir (free),
  or Heroic Games Launcher (free) if the game is on Epic.

## Fallback
If it's unplayable, free-tier cloud streaming is the only other no-cost option, but it needs
decent internet, which you said you lack.
