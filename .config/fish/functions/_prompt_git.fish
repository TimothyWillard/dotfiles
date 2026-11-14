function _prompt_git --description "Prompt: current git branch, or detached commit"
    # Fails quietly outside a git repository.
    set -l branch (git branch --show-current 2>/dev/null)
    or return 1

    set_color yellow
    if test -n "$branch"
        echo -n "($branch) "
    else
        echo -n '(detached@'(git rev-parse --short HEAD 2>/dev/null)') '
    end
    set_color normal
end
