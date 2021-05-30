#!/bin/bash

dotfiles="$(pwd)/"
home="$HOME/"

files=$(ls -a)
for f in $files ; do
    file="$dotfiles$f"
    link="$home$f"
    if [[ $f != "extract.sh" && $f != ".git" && $f != ".ssh"  && $f != "." && $f != ".." && $f != ".gitignore" ]]
    then
        # echo $file
        # echo $link
        ln -nfs $file $link
    fi
done

# Set up vim

## Install vim plug

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

## Make swap file folder

mkdir ~/.vim/swapfiles

