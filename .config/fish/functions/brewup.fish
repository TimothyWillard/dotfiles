function brewup --description "Update Homebrew and sync installed packages with ~/.Brewfile"
    # Usage: brewup
    # Runs non-interactively: upgrades without asking and removes packages that
    # aren't in the Brewfile without asking.

    # Refresh formulae, install anything in ~/.Brewfile that's missing, then
    # upgrade everything. `brew upgrade` asks for confirmation by default
    # (Homebrew 7+); --yes skips that prompt.
    brew update
    and brew bundle install --global
    and brew upgrade --yes

    # `brew bundle cleanup` lists installed packages (including global npm
    # packages) that aren't in the Brewfile and asks before removing them.
    # Brew has no --yes here; --force is what skips the prompt (it also resets
    # Homebrew's trust store to what the Brewfile declares).
    brew bundle cleanup --global --force
    brew cleanup
end
