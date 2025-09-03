# Herbex

Simple script for interacting with Herbstluftwm hooks.

## Features

- Write cwd to `~/.cwd` whenever focus or window title changes
    - Motivation: I often need to spawn a new terminal with the same directory I'm working in, i.e. for `Git` or running/debugging project,
    so I created this small project to avoid redundant `cd`s to improve my workflow :D

## Build

1. Generate `herbex` executable
```bash
mix escript.build
```

2. Copy/move/symlink executable
```bash
ln -s $(pwd)/herbex ~/.local/bin/
```
  - Note: full path is required for symlink to work properly

3. Configure `herbstluftwm/autostart`
```bash
~/.local/bin/herbex &
hc keybind $Mod-c spawn ~/.config/herbstluftwm/cwd_xterm.sh &
hc keybind $Mod-Shift-c chain , split bottom 0.5 , focus d , spawn ~/.config/herbstluftwm/cwd_xterm.sh &
```

4. Script to launch `xterm` with last focused window's directory
`~/.config/herbstluftwm/cwd_xterm.sh`
```bash
#!/bin/bash
cd $(cat ~/.cwd) && exec xterm
```
  - Remember to `chmod +x <script>`
    
