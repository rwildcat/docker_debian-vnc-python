#!/bin/bash
ws="."
if [ -n "$1" ]; then ws=$1; fi
sudo -u debian jupyter-notebook --no-browser --ip=0.0.0.0 --notebook-dir=$ws 
