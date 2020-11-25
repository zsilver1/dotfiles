#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

ln -sv $DIR/gitconfig ~/.gitconfig
ln -sv $DIR/tmux.conf ~/.tmux.conf
ln -sv $DIR/zshrc ~/.zshrc
ln -sv $DIR/workrc ~/.workrc
