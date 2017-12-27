#!/bin/bash

cd "${0%/*}"

curl -sSL https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh | sh -s ~/.cache/dein > /dev/null

mkdir -p ~/.config/nvim && cp config/nvim/init.vim ~/.config/nvim/init.vim

nvim -c "call dein#install()" -c "qa"
