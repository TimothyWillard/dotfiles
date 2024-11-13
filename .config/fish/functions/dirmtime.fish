function dirmtime --description "Get the max modtime of the files contained in a directory" --argument repo
    if test -z "$repo"
        set repo '.'
    end
    set curuname (uname)
    if test "$curuname" = "Darwin"
        find $repo -type f -not -path "./.git/*" \
            | xargs stat -f %m \
            | sort -r \
            | head -1 \
            | xargs date -r
    else if test "$curuname" = "Linux"
        set ts (find $repo -type f -not -path "./.git/*" | xargs stat -c %Y | sort -r | head -1)
				eval "date -d @$ts"
    else
        echo "Unsure of how to get the directory modtime on $curuname"
        return 1
    end
end
