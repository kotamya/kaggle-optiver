#!/bin/sh

# conda init
__conda_setup="$(CONDA_REPORT_ERRORS=false '$HOME/Anaconda3/bin/conda' shell.bash hook 2> /dev/null)"
if [ $? -eq 0 ]; then
    \eval "$__conda_setup"
else
    if [ -f "$HOME/Anaconda3/etc/profile.d/conda.sh" ]; then
        . "$HOME/Anaconda3/etc/profile.d/conda.sh"
        CONDA_CHANGEPS1=false conda activate base
    else
        \export PATH="$PATH:$HOME/Anaconda3/bin"
    fi
fi
unset __conda_setup

ENV_NAME="optiver-env"
conda update -n base -c defaults conda
conda remove -y -n $ENV_NAME --all
conda create -y -n $ENV_NAME python=3.8.8
conda activate $ENV_NAME 
conda config --append channels conda-forge
conda install -y --file ./requirements.txt
python -c 'from sklearnex import patch_sklearn; patch_sklearn()'
conda deactivate

