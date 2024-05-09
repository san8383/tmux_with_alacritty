#!/bin/bash
apt update && apt install alacritty -y && apt install tmux -y && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
cp zshrc ~/.zshrc
cp tmux.conf ~/.tmux.conf
mkdir ~/.local/bin/ && cp alacritty-with-tmux.sh ~/.local/bin/alacritty-with-tmux.sh # make link on that script to run tmux with allacrity on mouse click
cp alacritty.yml ~/.config/alacritty/alacritty.yml
