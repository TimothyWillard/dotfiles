function d --description "Deactivate a python venv or conda env"
    if command -v conda > /dev/null 2>&1; and set -q CONDA_PREFIX
        conda deactivate
        echo "Deactivated conda environment"
        return 0
    end
    deactivate
    echo "Deactivated virtual environment"
    return 0
end
