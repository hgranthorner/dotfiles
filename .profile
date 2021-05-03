PATH="$PATH:/Users/grant/Dev/erlang_ls/_build/default/bin"
PATH="$PATH:/Applications/CMake.app/Contents/bin"
PATH="$PATH:$HOME/.cargo/bin"
PATH="$PATH:$HOME/.emacs.d/bin"
PATH="$PATH:/Library/Developer/CommandLineTools"
PATH="$PATH:$HOME/.cabal/bin"
PATH="$PATH:/Users/grant/.ghcup/bin"
PATH="$PATH:/Users/grant/go/bin"
PATH="$PATH:/Users/grant/Applications/Sublime Text.app/Contents/SharedSupport/bin"
PATH="$PATH:/Users/grant/.local/bin"

export GO111MODULE=on
export GOPATH="/Users/grant/Dev/go"
export BASH_SILENCE_DEPRECATION_WARNING=1;

activate_venv() {
    dir=`pwd`
    while [[ ! -f $dir/.venv/bin/activate && -n $dir ]]; do
        dir=${dir%/*}
    done
    if [[ -f $dir/.venv/bin/activate ]]; then
        source $dir/.venv/bin/activate
    else
        echo 'Virtualenv not found'
    fi
}
alias em="emacsclient -c"
