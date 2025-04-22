function setrigr --description "Set R on path to a rig managed R installation" --argument rversion
    if not command -v rig > /dev/null
        echo "The 'rig' command is not available. Please install it first."
        return 1
    end
    if not command -v jq > /dev/null
        echo "The 'jq' command is not available. Please install it first."
        return 1
    end
    set rpath ( rig list --json | jq -r '.[] | select(.name == "'$rversion'") | .path' )
    if test -z "$rpath"
        echo "R version '$rversion' not found in rig installations. Please select a version from rig list."
        return 1
    end
    set rbin $rpath/Resources/bin/
    fish_add_path --prepend --verbose $rbin
end
