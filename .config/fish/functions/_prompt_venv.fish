function _prompt_venv --description "Prompt: active Python virtual/conda environment"
    # The name is red when the current directory is outside the environment's
    # parent directory (i.e. the environment is active but probably not for
    # this project).
    set -l python (type -p python)

    if set -q VIRTUAL_ENV
        if string match -q -- "$VIRTUAL_ENV*" $python
            set -l venv_parent (dirname $VIRTUAL_ENV)
            if string match -q -- "$venv_parent*" (pwd)
                set_color normal
            else
                set_color red
            end
            echo -n "($VIRTUAL_ENV_PROMPT) "
            set_color normal
        end
    else if set -q CONDA_PREFIX
        if string match -q -- "$CONDA_PREFIX*" $python
            if test -d "$CONDA_DEFAULT_ENV"
                set -l conda_parent (dirname $CONDA_DEFAULT_ENV)
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
end
