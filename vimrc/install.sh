#!/bin/bash

mkdir -p ~/.vim/swap
mkdir -p ~/.vim/backup
mkdir -p ~/.vim/undo

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cat "$DIR/vimrc" > ~/.vimrc
