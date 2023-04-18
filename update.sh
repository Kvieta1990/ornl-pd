#!/bin/bash

eval "$(conda shell.bash hook)"
conda activate jbook
jupyter-book build doc && a=1 || a=0
if [ $a = 1 ] ; then
    git add . --all
    git commit -m "update"
    git push
    ssh iris2 /mnt/Iris2_ExtL/Packages/update_pd.sh
fi
conda deactivate
