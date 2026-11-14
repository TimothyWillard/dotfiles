if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Fish shell color (global, not universal, so this file is the source of truth)
set -g fish_color_command dade73

# Fix directory colors
if test (uname) = "Darwin"
    # https://stackoverflow.com/a/25563976
    set -gx LSCOLORS gxfxbEaEBxxEhEhBaDaCaD
end

# Homebrew (Apple Silicon)
if test -d /opt/homebrew/bin
    fish_add_path /opt/homebrew/bin
end

# Cargo fish highlighting/autocomplete
if test -f "$HOME/.cargo/env.fish"
    source $HOME/.cargo/env.fish
end

# User ~/.local/bin
if test -d "$HOME/.local/bin"
    fish_add_path --append "$HOME/.local/bin"
end

# Disable venv prompt
set -x VIRTUAL_ENV_DISABLE_PROMPT 1

# Aliases
alias lah="ls -lah"
alias a="activate"
if test (uname) = "Darwin"
    # MacOS specific aliases
    alias gchrome='open -a "Google Chrome"'
    alias mmdb="movemydockback"
    alias o="open ."
	# Replace sed with gsed if installed
    if which gsed > /dev/null 2>&1
        alias sed="gsed"
    end
end
