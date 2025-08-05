function fish_prompt
    # Status helper
    set -l last_status $status
    # Display the virtual environment
    if set -q VIRTUAL_ENV
        if string match -q -- "$VIRTUAL_ENV*" (which python)
            set venv_parent (dirname $VIRTUAL_ENV)
            if string match -q -- "$venv_parent*" (pwd)
                set_color normal
            else
                set_color red
            end
            echo -n "($VIRTUAL_ENV_PROMPT) "
            set_color normal
        end
    else if set -q CONDA_PREFIX
        if string match -q -- "$CONDA_PREFIX*" (which python)
            if test -d "$CONDA_DEFAULT_ENV"
                set conda_parent (dirname $CONDA_DEFAULT_ENV)
                if string match -q -- "$conda_parent*" (pwd)
                    set_color normal
                else
                    set_color red
                end
                echo -n '(C '(basename (dirname $CONDA_DEFAULT_ENV))'/'(basename $CONDA_DEFAULT_ENV)') '
                set_color normal
            else
                echo -n "(C $CONDA_DEFAULT_ENV) "
            end
        end
    end
    # Who am I and where am I
    if not type -q computername; or not string match -r -q -- "^(epid_is.*|epid-iss.*|MacBookPro)\$" (computername)
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
    # Display the current branch or repository info
    if which jj > /dev/null 2>&1; and jj root --quiet > /dev/null 2>&1
        # jj repository info
        jj_fish_prompt
    else if which git > /dev/null 2>&1; and git rev-parse --is-inside-work-tree > /dev/null 2>&1
        # git repository info
        set branchname (git branch --show-current)
        set_color yellow
        if test -n "$branchname"
            echo -n '('(git symbolic-ref --short HEAD)') '
        else
            echo -n '(detached@'(git rev-parse --short HEAD)') '
        end
        set_color normal
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
