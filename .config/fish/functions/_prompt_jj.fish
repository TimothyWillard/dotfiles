function _prompt_jj --description "Prompt: jj working-copy info"
    # All the data comes from one call to the `prompt` alias in the jj config
    # (.config/jj/config.toml): tab-separated rows for the working copy ("cur")
    # and the nearest bookmark ahead of / behind it. This function only decides
    # what to show and how to color it. Fails quietly outside a jj repository.
    set -l rows (jj prompt 2>/dev/null)
    or return 1

    set -l cur
    set -l ahead
    set -l behind
    for row in $rows
        set -l f (string split \t -- $row)
        switch $f[1]
            case cur
                set cur $f
            case ahead
                set -a ahead $f[7]
            case behind
                set -a behind $f[7]
        end
    end
    test (count $cur) -ge 6; or return 1

    set -l is_empty $cur[2]
    set -l has_conflict $cur[3]
    set -l description $cur[4]
    set -l change_id $cur[5]
    set -l commit_id $cur[6]

    # Which bookmark to show: one on the working copy, else the single one
    # ahead of it, else the nearest one behind it.
    set -l bookmark
    set -l relation
    set -l bookmark_color CA30C7
    if test -n "$cur[7]"
        set bookmark (string split ' ' -- $cur[7])[1]
        set relation current
        set bookmark_color FF77FF
    else if test (count $ahead) -eq 1
        set bookmark (string split ' ' -- $ahead[1])[1]
        set relation ahead
    else if test (count $behind) -gt 0
        set bookmark (string split ' ' -- $behind[1])[1]
        set relation behind
    end

    set_color yellow
    echo -n '('

    if test -n "$description"
        if test (string length -- $description) -gt 50
            set description (string sub --length 47 -- $description)...
        end
        echo -n $description
    else if test "$is_empty" = true
        set_color --italics 60FA67
        echo -n empty
        set_color normal
        set_color yellow
    else
        set_color --italics yellow
        echo -n 'no description'
        set_color normal
        set_color yellow
    end

    if test -n "$change_id"
        echo -n ', '
        set_color FF77FF
        echo -n $change_id
        set_color yellow
    end
    if test -n "$commit_id"
        echo -n ', '
        set_color 6871FF
        echo -n $commit_id
        set_color yellow
    end

    echo -n ', '
    if test -n "$bookmark"
        set_color $bookmark_color
        switch $relation
            case ahead
                echo -n (printf '⬆ ')
            case behind
                echo -n (printf '⬇ ')
        end
        # A trailing `*` (added by the jj template) means it differs from its remote.
        echo -n $bookmark
    else
        set_color --italics yellow
        echo -n 'no bookmark'
        set_color normal
    end

    set_color yellow
    if test "$has_conflict" = true
        echo -n ', '
        set_color FF6E67
        echo -n conflict
        set_color yellow
    end
    echo -n ') '
    set_color normal
end
