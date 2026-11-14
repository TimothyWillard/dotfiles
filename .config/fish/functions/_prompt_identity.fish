function _prompt_identity --description "Prompt: user, host (over SSH only), and working directory"
    # The user is always shown (red as root). The host only appears over SSH,
    # where it's the thing that tells you you're not on your own machine.
    if fish_is_root_user
        set_color red
    else
        set_color green
    end
    echo -n $USER

    if set -q SSH_CONNECTION
        set_color yellow
        echo -n '@'
        set_color normal
        echo -n (prompt_hostname)
    end

    set_color normal
    echo -n ' '
    set_color green
    echo -n (prompt_pwd)' '
    set_color normal
end
