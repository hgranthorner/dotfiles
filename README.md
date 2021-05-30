# Dotfiles

A collection of my configuration files.

## Installation

Clone the directory to your home folder. Then, cd into the cloned directory and run the extract_files script. This will symlink all of the config files and folders into your home directory.

## Vim

Boot up vim and run `:PlugInstall`.

Then move the gruvbox color scheme to the vim colors directory.

```bash
mkdir ~/.vim/colors
cp ~/.vim/vimplugins/gruvbox/colors/gruvbox.vim ~/.vim/colors/gruvbox.vim
```

Then you should be all set.
