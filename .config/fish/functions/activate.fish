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
    if command -v conda > /dev/null 2>&1; and test -d "venv/conda-meta"
        conda activate venv/
        echo "Activated conda environment from venv"
        return 0
    end
    echo "No virtual environment found. Expected .venv/bin/activate.fish, venv/bin/activate.fish, or conda environment in venv/ directory."
    return 1
end