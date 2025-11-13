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
            set current_bookmark_changeids (jj log --ignore-working-copy --no-graph -r '@ & bookmarks()' -T 'change_id.shortest()')
            set next_bookmark_changeids (jj log --ignore-working-copy --no-graph -r 'heads(@:: & bookmarks())' -T 'change_id.shortest()')
            set last_bookmark_changeids (jj log --ignore-working-copy --no-graph -r 'heads(::@ & bookmarks())' -T 'change_id.shortest()')
            set current_bookmark_count (count $current_bookmark_changeids)
            set next_bookmark_count (count $next_bookmark_changeids)
            set last_bookmark_count (count $last_bookmark_changeids)
            set bookmark_changeid ""
            set bookmark_relation ""
            set bookmark_color CA30C7
            set bookmark_arrow ""
            if test "$current_bookmark_count" -gt 0
                set bookmark_changeid $current_bookmark_changeids[1]
                set bookmark_relation current
                set bookmark_color FF77FF
            else if test "$next_bookmark_count" -eq 1
                set bookmark_changeid $next_bookmark_changeids[1]
                set bookmark_relation ahead
            else if test "$last_bookmark_count" -gt 0
                set bookmark_changeid $last_bookmark_changeids[1]
                set bookmark_relation behind
            end
            switch "$bookmark_relation"
                case ahead
                    set bookmark_arrow (printf '\u2B06 ') # up
                case behind
                    set bookmark_arrow (printf '\u2B07 ') # down
                case '*'
                    set bookmark_arrow ""
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
