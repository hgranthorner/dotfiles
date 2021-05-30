# Dotfiles

A collection of my configuration files.

## Installation

Clone the directory to your home folder. Then, cd into the cloned directory and run the extract_files script. This will symlink all of the config files and folders into your home directory.

## Vim

While the configuration will all be set up for vim, you'll still need to download the vim plug package manager separately. Luckily, doing so is easy. Simply run:

```bash
 ~/.vim/autoload/plug.vim --create-dirs \
     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

```

Then boot up vim and run `:PlugInstall`.

The last thing to do is to move the gruvbox color scheme to the vim colors directory.

```bash
mkdir vim/colors
cp vim/vimplugins/gruvbox/colors/gruvbox.vim vim/colors/gruvbox.vim
```

Then you should be all set.
