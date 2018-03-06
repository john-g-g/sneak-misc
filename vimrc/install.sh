#!/bin/sh

mkdir -p ~/.vim/swap
mkdir -p ~/.vim/backup
mkdir -p ~/.vim/undo
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
if [[ ! -e ~/.vimrc ]]; then
    cat "$DIR/vimrc" > ~/.vimrc
fi
