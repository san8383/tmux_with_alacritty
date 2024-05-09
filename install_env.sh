#!/bin/bash
sudo apt update && sudo apt install alacritty -y && sudo apt install tmux -y && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
cp zshrc ~/.zshrc
cp tmux.conf ~/.tmux.conf
mkdir ~/.local/bin/ && cp alacritty-with-tmux.sh ~/.local/bin/alacritty-with-tmux.sh # make link on that script to run tmux with allacrity on mouse click
mkdir ~/.config/alacritty/ && cp alacritty.yml ~/.config/alacritty/alacritty.yml
