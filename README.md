# Herbex

Simple script for interacting with Herbstluftwm hooks.

## Features

- Write cwd to `~/.cwd` whenever focus or window title changes
    - Motivation: I often need to spawn a new terminal with the same directory I'm working in, i.e. for `Git` or running/debugging project,
    so I created this small project to avoid redundant `cd`s to improve my workflow :D

## Build

1. Generate `herbex` executable: `mix escript.build`
2. Copy/move/symlink executable: `ln -s $(pwd)/herbex ~/.local/bin/`
    - Note: full path is required for symlink to work properly
3. Configure `herbstluftwm`:
    - In `herbstluftwm/autostart`:
    ```bash
    hc keybind $Mod-c spawn ~/.config/herbstluftwm/cwd_xterm.sh &
    hc keybind $Mod-Shift-c chain , split bottom 0.5 , focus d , spawn ~/.config/herbstluftwm/cwd_xterm.sh &
    ```
    - Script to launch `xterm` in dir:
    ```bash
    #!/bin/bash
    cd $(cat ~/.cwd) && exec xterm
    ```
    
