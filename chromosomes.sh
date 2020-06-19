#!/bin/bash

### Argument is the name of the files generated from plink, if they were cattle.bed etc. then the argument would be "cattle", w/o the "".

args=("$@")
for chr in $(seq 1 29); do
     plink --bfile ${args[0]} \
           --cow \
           --chr $chr \
	   --make-bed \
           --out ${args[0]}.chr$chr ;
done
