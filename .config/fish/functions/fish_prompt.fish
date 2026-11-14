function fish_prompt --description "Shell prompt"
    # Must be captured before anything else runs.
    set -l last_status $status

    _prompt_venv
    _prompt_identity
    _prompt_vcs
    _prompt_status $last_status

    echo -n '> '
end
