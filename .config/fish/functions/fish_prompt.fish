function fish_prompt
    # Status helper
    set -l last_status $status
    # Display the virtual environment
    if set -q VIRTUAL_ENV
        if string match -q -- "$VIRTUAL_ENV*" (which python)
            echo -n "($VIRTUAL_ENV_PROMPT) "
        end
    else if set -q CONDA_PREFIX
        if string match -q -- "$CONDA_PREFIX*" (which python)
            if test -d "$CONDA_DEFAULT_ENV"
                echo -n '(C '(basename (dirname $CONDA_DEFAULT_ENV))'/'(basename $CONDA_DEFAULT_ENV)') '
            else
                echo -n "(C $CONDA_DEFAULT_ENV) "
            end
        end
    end
    # Who am I and where am I
    if not string match -r -q -- "^(epid-iss.*|MacBookPro)\$" (prompt_hostname)
        set_color green
        echo -n (whoami)
        set_color yellow
        echo -n '@'
        set_color normal
        echo -n (prompt_hostname)' '
    end
    set_color green
    echo -n (prompt_pwd)' '
    set_color normal
    # Git branch
    if which git > /dev/null 2>&1
        if git rev-parse --is-inside-work-tree > /dev/null 2>&1
            set_color yellow
            echo -n '('(git symbolic-ref --short HEAD)') '
            set_color normal
        end
    end
    # Display last status
    if test $last_status -ne 0
        set_color red
        echo -n "[$last_status] "
        set_color normal
    end
    # Done
    echo -n '> '
end
