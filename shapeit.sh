#!/bin/bash

### Argument is the name of the files split into individual chromosomes, if they were cattle.chr29.bed etc. then the argument would be "cattle", w/o the "".

args=("$@")
for chr in $(seq 1 29); do
	./shapeit --input-bed ${args[0]}.chr$chr.bed ${args[0]}.chr$chr.bim ${args[0]}.chr$chr.fam \
			  --output-max ${args[0]}$chr.phased.haps ${args[0]}$chr.phased.sample \
			  --effective-size ${args[1]} \ 
			  --thread 8 \
			  --seed 123456789
done
