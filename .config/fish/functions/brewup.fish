function brewup --description "Update Homebrew and sync installed packages with ~/.Brewfile"
    # Refresh formulae, install anything in ~/.Brewfile that's missing, then
    # upgrade everything. `brew bundle cleanup` is a dry run (no --force): it
    # only lists installed packages that aren't in the Brewfile.
    brew update
    and brew bundle install --global
    and brew upgrade
    and brew bundle cleanup --global
    and brew cleanup
end
