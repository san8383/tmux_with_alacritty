#!/bin/bash
apt update && apt install alacritty && apt install tmux && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
git clone https://github.com/san8383/tmux_with_alacritty.git && cd tmux_with_alacritty
cp zshrc ~/.zshrc
cp tmux.conf ~/.tmux.conf
mkdir ~/.local/bin/ && cp alacritty-with-tmux.sh ~/.local/bin/alacritty-with-tmux.sh # make link on that script to run tmux with allacrity on mouse click
cp alacritty.yml ~/.config/alacritty/alacritty.yml
