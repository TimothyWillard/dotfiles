if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -Ux fish_color_command dade73
# https://stackoverflow.com/a/25563976
set -Ux LSCOLORS gxfxbEaEBxxEhEhBaDaCaD

source $HOME/.cargo/env.fish

alias lah="ls -lah"
alias rfish="source ~/.config/fish/**/*.fish"

alias mmdb="movemydockback"
alias sfdf="syncfromdotfiles"

alias gti="git"
alias igt="git"

