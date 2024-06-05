function dirmtime --description "Get the max modtime of the files contained in a directory" --argument repo
    if test -z "$repo"
        set repo '.'
    end
    find $repo -type f -not -path "./.git/*" | xargs stat -f %m | sort -r | head -1 | xargs date -r
end
