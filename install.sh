#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

ln -sv $DIR/tmux.conf ~/.tmux.conf
ln -sv $DIR/zshrc.sh ~/.zshrc
ln -sv $DIR/vterm.sh ~/.vterm.sh
cp $DIR/rclone.conf ~/.config/rclone/rclone.conf

read -p "Do you want to install work specific settings (work_gitconfig, workrc, etc.)? (y/n)>" -r

# install work specific settings
if [[ $REPLY = "y" ]]; then
    echo "Installing work settings..."
    ln -sv $DIR/work_gitconfig ~/.gitconfig
    ln -sv $DIR/workrc ~/.envrc
else
    echo "Installing personal settings only..."
    ln -sv $DIR/personal_gitconfig ~/.gitconfig
fi
