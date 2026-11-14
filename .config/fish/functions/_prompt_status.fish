function _prompt_status --description "Prompt: last command's exit status, if non-zero" --argument-names code
    if test "$code" -ne 0
        set_color red
        echo -n "[$code] "
        set_color normal
    end
end
