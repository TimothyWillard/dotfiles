function jj_fish_prompt
    if which jj > /dev/null 2>&1
        if jj root --quiet > /dev/null 2>&1
            # Inspired by https://gist.github.com/hroi/d0dc0e95221af858ee129fd66251897e
            jj status > /dev/null 2>&1
            set_color yellow
            echo -n '('
            set empty (jj log --ignore-working-copy --no-graph -r @ -T 'empty')
            set description (jj log --ignore-working-copy --no-graph -r @ -T 'description.first_line()')
            if test -n "$description"
                set description_length (string length -- $description)
                if test "$description_length" -gt 50
                    set description (string sub --length 47 -- $description)
                    set description "$description..."
                end
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
            set bookmark_changeid ""
            set bookmark_color CA30C7
            set bookmark_arrow ""
            if test -n "$last_bookmark_changeid"; and test -n "$next_bookmark_changeid"; and test "$last_bookmark_changeid" = "$next_bookmark_changeid"
                set bookmark_changeid $next_bookmark_changeid
                set bookmark_color FF77FF
            else if test -n "$next_bookmark_changeid"
                set bookmark_changeid $next_bookmark_changeid
            else if test -n "$last_bookmark_changeid"
                set bookmark_changeid $last_bookmark_changeid
            end
            if test -n "$bookmark_changeid"; and test -n "$changeid"
                if test "$bookmark_changeid" = "$changeid"
                    set bookmark_arrow ""
                else if test -n "$next_bookmark_changeid"; and test "$bookmark_changeid" = "$next_bookmark_changeid"
                    set bookmark_arrow (printf '\u2B06 ') # up
                else if test -n "$last_bookmark_changeid"; and test "$bookmark_changeid" = "$last_bookmark_changeid"
                    set bookmark_arrow (printf '\u2B07 ') # down
                end
            end
            set bookmark_name ""
            set bookmark_unsynced 0
            if test -n "$bookmark_changeid"
                set bookmark_output (jj bookmark list --all-remotes -r "$bookmark_changeid" --color=never | string collect)
                set local_candidates
                set remote_git_candidates
                set remote_other_candidates
                if test -n "$bookmark_output"
                    for bookmark_line in (string split -n -- "\n" $bookmark_output)
                        set trimmed_line (string trim -- $bookmark_line)
                        if test -z "$trimmed_line"
                            continue
                        end
                        if string match -qr '^\S' $bookmark_line
                            set candidate (string replace -r ':.*$' '' $trimmed_line)
                            if string match -q '*@*' $candidate
                                if string match -q '*@git'
                                    set remote_git_candidates $remote_git_candidates $candidate
                                else
                                    set remote_other_candidates $remote_other_candidates $candidate
                                end
                            else
                                set local_candidates $local_candidates $candidate
                            end
                        end
                        set lowercase_line (string lower $trimmed_line)
                        if string match -qr 'ahead by|behind by' $lowercase_line
                            set bookmark_unsynced 1
                        end
                    end
                end
                if test -n "$local_candidates"
                    set bookmark_name $local_candidates[1]
                else if test -n "$remote_git_candidates"
                    set bookmark_name $remote_git_candidates[1]
                else if test -n "$remote_other_candidates"
                    set bookmark_name $remote_other_candidates[1]
                end
            end
            echo -n ', '
            if test -n "$bookmark_name"
                set_color $bookmark_color
                if test -n "$bookmark_arrow"
                    echo -n $bookmark_arrow
                end
                echo -n $bookmark_name
                if test "$bookmark_unsynced" -eq 1
                    echo -n '*'
                end
            else
                set_color --italics yellow
                echo -n 'no bookmark'
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
end
