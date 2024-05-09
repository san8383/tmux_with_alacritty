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

Default prefix for tmux changed on `C + a`, so run `Prefix + I`
