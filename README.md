# Herbex

Simple script for interacting with Herbstluftwm hooks.

## How it works

The script is fairly simple, it listens for `focus_changed` and `window_title_changed` events
and writes the current working directory of the focused window to a file.

The reason I need this is simple:
I wanted a way to spawn terminals with the same directory as the project I'm working on,
so I don't have to manually `cd` every time.
Common reasons to do this are to use `Git` and build/run/debug the project from the CLI.
So... I spent more time on this project than all the `cd`s would have taken :P

## Build

1. Generate `herbex` executable
```bash
mix escript.build
```

2. Copy/move/symlink executable
  - Note: full path is required for symlink to work properly
```bash
ln -s $(pwd)/herbex ~/.local/bin/
```

3. Configure `herbstluftwm/autostart`
```bash
~/.local/bin/herbex &
hc keybind $Mod-c spawn ~/.config/herbstluftwm/cwd_xterm.sh &
hc keybind $Mod-Shift-c chain , split bottom 0.5 , focus d , spawn ~/.config/herbstluftwm/cwd_xterm.sh &
```

4. Script to launch `xterm` with last focused window's directory
  - Remember to `chmod +x <script>`
`~/.config/herbstluftwm/cwd_xterm.sh`
```bash
#!/bin/bash
cd $(cat ~/.cwd) && exec xterm
```
    
## Dotfiles

If you're curious:
- [grilledwindow/dotfiles](https://github.com/grilledwindow/dotfiles/tree/main)
- [herbstluftwm/autostart](https://github.com/grilledwindow/dotfiles/blob/main/.config/herbstluftwm/autostart)
- [herbstluftwm/cwd_xterm.sh](https://github.com/grilledwindow/dotfiles/blob/main/.config/herbstluftwm/cwd_xterm.sh)

