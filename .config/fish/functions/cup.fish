function cup --description "Conda up, either add conda to the path or remove it if already there."
    # Exit early if not MacOS
    if test (uname) != "Darwin"
        echo "The \`cup\` function is only intended for use on MacOS."
        return 1
    end

    # Check if anaconda is on the system
    if not test -d $HOME/anaconda3
        echo "Anaconda not found at $HOME/anaconda3."
        return 1
    end
    if contains $HOME/anaconda3/bin $PATH
        # Is in path, need to remove
        set i (contains --index $HOME/anaconda3/bin $PATH)
        set -e PATH[$i]
        if contains $HOME/anaconda3/condabin $PATH
            set i (contains --index $HOME/anaconda3/condabin $PATH)
            set -e PATH[$i]
        end
    else
        # Is not in path, need to add
        source $HOME/anaconda3/etc/fish/conf.d/conda.fish
        fish_add_path --path --prepend $HOME/anaconda3/bin
    end
end
