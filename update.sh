#!/bin/bash

eval "$(conda shell.bash hook)"
conda activate jbook
rm -rf doc/_build
jupyter-book build doc && a=1 || a=0
if [ $a = 1 ] ; then
    git add . --all
    git commit -m "update"
    git push
    /var/www/update_pd.sh
fi
conda deactivate
