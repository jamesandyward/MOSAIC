for chr in $(seq 1 29); do
     plink --bfile clean_data \
           --cow \
           --chr $chr \
	   --make-bed \
           --out cattle.chr$chr ;
done
