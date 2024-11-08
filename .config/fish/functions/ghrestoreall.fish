function ghrestoreall --description "Restore all of the changes listed by git. Very dangerous."
    for f in ( git diff --name-only )
        git restore $f
    end
end
