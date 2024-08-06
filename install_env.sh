#!/bin/bash

# Check if ~/.config/alacritty/ exists, if not, create it
if [ ! -d ~/.config/alacritty/ ]; then
    mkdir -p ~/.config/alacritty/
fi

# Check if ~/.local/bin/ exists, if not, create it
if [ ! -d ~/.local/bin/ ]; then
    mkdir -p ~/.local/bin/
fi

# Update and install required packages
sudo apt update && sudo apt install alacritty -y && sudo apt install tmux -y && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Copy configuration files
cp zshrc ~/.zshrc
cp tmux.conf ~/.tmux.conf
cp alacritty.toml ~/.config/alacritty/alacritty.toml

# Copy alacritty-with-tmux.sh script to ~/.local/bin/ and make it executable
cp alacritty-with-tmux.sh ~/.local/bin/alacritty-with-tmux.sh
chmod +x ~/.local/bin/alacritty-with-tmux.sh
