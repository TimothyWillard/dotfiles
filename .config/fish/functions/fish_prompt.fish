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
            set branchname (git branch --show-current)
            set_color yellow
            if test -n "$branchname"
                echo -n '('(git symbolic-ref --short HEAD)') '
            else
                echo -n '(detached@'(git rev-parse --short HEAD)') '
            end
            set_color normal
        end
    end
    # JJ revset
    if which jj > /dev/null 2>&1
        if jj root --quiet > /dev/null 2>&1
            # Inspired by https://gist.github.com/hroi/d0dc0e95221af858ee129fd66251897e
            jj status > /dev/null 2>&1
            set_color yellow
            echo -n '('
            set empty (jj log --ignore-working-copy --no-graph -r @ -T 'empty')
            set description (jj log --ignore-working-copy --no-graph -r @ -T 'description.first_line()')
            if test -n "$description"
                echo -n $description
            else if "$empty" = "true"
                set_color --italics 60FA67
                echo -n 'empty'
                set_color normal
                set_color yellow
            else
                set_color --italics yellow
                echo -n 'no description'
                set_color normal
                set_color yellow
            end
            set changeid (jj log --ignore-working-copy --no-graph -r @ -T 'change_id.shortest()')
            if test -n "$changeid"
                echo -n ', '
                set_color FF77FF
                echo -n $changeid
                set_color yellow
            end
            set commitid (jj log --ignore-working-copy --no-graph -r @ -T 'commit_id.shortest()')
            if test -n "$commitid"
                echo -n ', '
                set_color 6871FF
                echo -n $commitid
                set_color yellow
            end
            set last_bookmark_changeid (jj log --ignore-working-copy --no-graph -r 'heads(::@ & bookmarks())' -T 'change_id.shortest()')
            set next_bookmark_changeid (jj log --ignore-working-copy --no-graph -r 'heads(@:: & bookmarks())' -T 'change_id.shortest()')
            set bookmark_name ""
            if test -n "$last_bookmark_changeid"; and test -n "$next_bookmark_changeid"; and test "$last_bookmark_changeid" = "$next_bookmark_changeid"
                echo -n ', '
                set_color FF77FF
                set bookmark_name (jj bookmark list -r "$next_bookmark_changeid" -T 'name')
            else if test -n "$next_bookmark_changeid"
                echo -n ', '
                set_color CA30C7
                set bookmark_name (jj bookmark list -r "$next_bookmark_changeid" -T 'name')
            else if test -n "$last_bookmark_changeid"
                echo -n ', '
                set_color CA30C7
                set bookmark_name (jj bookmark list -r "$last_bookmark_changeid" -T 'name')
            end
            if test -n "$bookmark_name"
                # This treatment of bookmark names is a bit of a hack. Basically, if the
                # bookmark name is a repeated string we assume that there are local
                # changes. This is because `jj bookmark list` will distinguish between
                # local and remote bookmarks, but repeat the name with the template 
                # above. This is not a perfect solution, but it works for my use case.
                set bookmark_name_base (string match -rg '^(.+)\1$' "$bookmark_name")
                if test -n "$bookmark_name_base"
                    echo -n $bookmark_name_base
                    echo -n '*'
                else
                    echo -n $bookmark_name
                end
            else
                set_color --italics yellow
                echo -n ', no bookmark'
                set_color normal
            end
            set_color yellow
            set conflict (jj log --ignore-working-copy --no-graph -r @ -T 'conflict')
            if "$conflict" = "true"
                echo -n ', '
                set_color FF6E67
                echo -n 'conflict'
                set_color yellow
            end
            echo -n ') '
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
