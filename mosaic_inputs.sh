#!/bin/bash

# First argument is path to haps files for example: ~/projects/data/
# Second argument is the he part of .haps filename before chrno or example: cattle.chr 
# Third argument is the name of the file containing information on the samples. 
# Fourth argument is the name of the file containing the path for the output files for example: ~/projects/data/MOSAIC/inputs/

args=("$@")
for chr in $(seq 1 29); do
    Rscript haps_to_mosaic.R \
    ${args[0]} \
    $chr \
    ${args[1]} \
    .phased.haps \
    ${args[2]} \
    ${args[3]}
done
