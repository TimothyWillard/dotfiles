if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Need to manually set SDK root for R CMD Check
if string match --quiet -- 'epid-iss-*' (hostname)
    set -Ux SDKROOT (xcrun --show-sdk-path)
end

# Fish shell color 
set -Ux fish_color_command dade73

# gpg tty for git gpg signing
set -x GPG_TTY (tty)

# Fix directory colors
if test (uname) = "Darwin"
    # https://stackoverflow.com/a/25563976
    set -Ux LSCOLORS gxfxbEaEBxxEhEhBaDaCaD
end

# Cargo fish highlighting/autocomplete
if test -f "$HOME/.cargo/env.fish"
    source $HOME/.cargo/env.fish
end

# User ~/.local/bin
if test -d "$HOME/.local/bin"
    fish_add_path ~/.local/bin
end

# Bun JS
if test -d "$HOME/.bun"
    set --export BUN_INSTALL "$HOME/.bun"
    set --export PATH $BUN_INSTALL/bin $PATH
end

# Aliases
alias lah="ls -lah"
alias lh="ls -lah"
alias rfish="source ~/.config/fish/**/*.fish; source ~/.config/fish/config.fish"
alias sfdf="syncfromdotfiles"
alias gti="git"
alias igt="git"
if test (uname) = "Darwin"
    # MacOS specific aliases
    alias gchrome='open -a "Google Chrome"'
    alias mmdb="movemydockback"
end
