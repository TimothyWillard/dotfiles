if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Need to manually set SDK root for R CMD Check
if string match --quiet -- 'epid-iss-mbp*' (hostname)
    set -Ux SDKROOT (xcrun --show-sdk-path)
end

set -Ux fish_color_command dade73
# https://stackoverflow.com/a/25563976
set -Ux LSCOLORS gxfxbEaEBxxEhEhBaDaCaD
set -x GPG_TTY (tty)

source $HOME/.cargo/env.fish
fish_add_path ~/.local/bin

alias lah="ls -lah"
alias rfish="source ~/.config/fish/**/*.fish; source ~/.config/fish/config.fish"

alias mmdb="movemydockback"
alias sfdf="syncfromdotfiles"

alias gti="git"
alias igt="git"

alias pyink="$HOME/venvs/pyink_venv/bin/python -m pyink"

alias gchrome='open -a "Google Chrome"'
