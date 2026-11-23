# Detroit: Become Human on an M1 Mac (free)

Approach: Sikarugir (free, maintained Wine wrapper; Whisky is unmaintained and no longer recommended) + your own copy of the game on Steam/Epic.
Detroit uses Vulkan on PC, which translates to Metal via DXVK/MoltenVK.

**Not tested on real hardware by the author. Results vary; treat settings as a starting point.**

## Requirements
- Apple Silicon Mac (M1+), **16 GB RAM strongly recommended** (8 GB will likely not work)
- ~60 GB free disk (game is ~55 GB)
- Game owned on Steam or Epic

## Install
    bash setup.sh   # still installs Whisky; switch to Sikarugir (see below)

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

## STATUS: the game may not launch at all on Apple Silicon
CodeWeavers rates it "Installs, Will Not Run" and MacGamingDB lists it unplayable on recent CrossOver,
reportedly because the game is Vulkan-only and MoltenVK (Vulkan-on-Metal) lacks something it needs.
Shaders are probably not the problem (MoltenVK already translates SPIR-V). The cause is unconfirmed.

## Finding the real failure
1. Run `bash diagnose.sh`. It writes a report to your Desktop with your Vulkan version/features.
2. Install Sikarugir, create a wrapper, install Steam and the game inside it.
3. Launch the game from Terminal with logging on, so the log is captured. Find the wrapper's executable
   with `ls "/path/to/Detroit.app/Contents/MacOS"` and run:

       MVK_CONFIG_LOG_LEVEL=4 VK_LOADER_DEBUG=all WINEDEBUG=+vulkan,err+all \
         "/path/to/Detroit.app/Contents/MacOS/<executable>" > ~/Desktop/detroit-launch.log 2>&1

   (Exact wrapper paths/options may differ; adjust as needed.)
4. Look in the log for: `VK_ERROR_`, `not supported`, `missing extension`, `vkCreateInstance`,
   `vkCreateDevice`, `feature`. Share the report and the lines around the first error.
   A log over a few MB: send only the first ~200 lines containing `err:` / `VK_ERROR` and the last 100 lines.
