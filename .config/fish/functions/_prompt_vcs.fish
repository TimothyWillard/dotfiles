function _prompt_vcs --description "Prompt: version control info (jj, else git)"
    # _prompt_jj fails quietly outside a jj repository.
    if type -q jj; and _prompt_jj
        return
    end
    if type -q git
        _prompt_git
    end
end
