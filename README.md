# Installation
Assuming you are working in kali linux or another linux system with sudo installed and user is not root. Otherwise you need to install environment manually.

- Clone repository
`https://github.com/san8383/tmux_with_alacritty.git`
- enter a folder
`cd tmux_with_alacritty`
- make file executable
`chmod +x install_env.sh`
- run install
`./install_env.sh`

After installation reboot the system. Add an icon for running tmux in alacritty in one click and give an address for executable `~/.local/bin/alacritty-with-tmux.sh`
# First start
Run your tmux by running script `~/.local/bin/alacritty-with-tmux.sh`

With the first start you need to install tmux plugins.

Default prefix for tmux changed on `C + a`, so you have to run `Prefix + I`

# About

Based on tmux nord theme https://github.com/nordtheme/tmux

Customized with pligins for development and pentest. Mouse scrolling activated, you can copy information with selecting and pressing `y`, activated  tmux logging plugin, horizontal split set on `-`, vertical on `|`. Switchin between panes done by `Shift + arrows`

`Ctrl + l` cleares screen and tmux history.

![screenshot](https://raw.githubusercontent.com/san8383/tmux_with_alacritty/main/view.png)
