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