for chr in $(seq 1 29); do
	./shapeit --input-bed cattle.chr$chr.bed cattle.chr$chr.bim cattle.chr$chr.fam \
			  --output-max cattle.chr$chr.phased.haps cattle.chr$chr.phased.sample \
			  --effective-size 400 \ 
			  --thread 8 \
			  --seed 123456789
done
