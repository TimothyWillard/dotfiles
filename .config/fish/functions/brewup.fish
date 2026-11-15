function brewup --description "Update Homebrew and sync installed packages with ~/.Brewfile"
    # Usage: brewup [-y|--yes]
    #   -y, --yes   Don't ask before removing packages that aren't in the Brewfile.
    argparse y/yes -- $argv
    or return

    # Refresh formulae, install anything in ~/.Brewfile that's missing, then
    # upgrade everything.
    brew update
    and brew bundle install --global
    and brew upgrade

    # Without --force, `brew bundle cleanup` lists installed packages (including
    # global npm packages) that aren't in the Brewfile and asks before removing
    # them. Declining makes it exit 1, so it runs on its own line rather than
    # gating `brew cleanup`. Brew has no --yes; --force is what skips the prompt
    # (it also resets Homebrew's trust store to what the Brewfile declares).
    set -l cleanup_args --global
    if set -q _flag_yes
        set -a cleanup_args --force
    end
    brew bundle cleanup $cleanup_args
    brew cleanup
end
