#!/bin/bash

### First argument is the name of the files generated from plink, if they were clean_data.bed etc. then the argument would be "clean_data", w/o the "".
### Second argument is the name you want the output file to be, for example "cattle", w/o the "".

args=("$@")
for chr in $(seq 1 29); do
     plink --bfile ${args[0]} \
           --cow \
           --chr $chr \
	   --make-bed \
           --out ${args[1]}.chr$chr ;
done
