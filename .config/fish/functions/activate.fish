function activate --description "Activate Python virtual environment from .venv or venv directory"
    if test -f ".venv/bin/activate.fish"
        source .venv/bin/activate.fish
        echo "Activated virtual environment from .venv"
        return 0
    end
    if test -f "venv/bin/activate.fish"
        source venv/bin/activate.fish
        echo "Activated virtual environment from venv"
        return 0
    end
    echo "No virtual environment found. Expected .venv/bin/activate.fish or venv/bin/activate.fish in current directory."
    return 1
end