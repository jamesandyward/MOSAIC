# MOSAIC
*Instructions and description of scripts, etc. needed to run MOSAIC.*

*All scripts mentioned can be found in this repository.*

#### Installation of MOSAIC ####
On the server use the following command in the directory that contains the file:

```
R CMD INSTALL -l rlib MOSAIC_1.3.7.tar.gz
```

#### Inputs ####
There should be a folder with 4 types of input file:

* <u>phased haplotypes</u>: "pop.genofile.chr" in the format #snps rows and #haps columns.

* <u>pop names</u>: "sample.names" format unimportant apart from first column should have all the population names.

* <u>snp files</u>: "snpfile.chr" #snps rows and 6 columns of rsID, chr, distance, position, allele ?, allele ?. 

* <u>recombination map</u>: "rates.chr" 3 rows of #sites, position, cumulative recombination rate (in centiMorgans). 



#### Generating Input Files ####

##### 1. Phased haplotypes, SNP files and sample names
Generating these files will require several steps to get it to the format needed to get MOSAIC working. 

In order to generate the phased haplotypes we will need to use the [SHAPEIT](https://mathgen.stats.ox.ac.uk/genetics_software/shapeit/) software for phasing.

Before running SHAPEIT SNPs will have to be filtered for SNPs and Individuals with poor calling rates. Duplicates will also cause errors so they will need to be removed too.

```
plink --cow --file HD_SNP_Data --keep selected.txt --chr 1-29 --geno 0.05 --maf 0.05 --make-bed --out filtered_data
```

```
plink --cow --bfile filtered_data --list-duplicate-vars suppress-first --out dups
```

```
plink --cow --bfile filtered_data --exclude dups.dupvar --make-bed --out clean_data
```

Once filtered and cleaned the data will need to be split into chromosomes. This can be done by running the *chromosomes.sh* script, with the first argument being the name of the cleaned data, in this case clean_data and the second argument, which is the name for the output data, being cattle. <u>Make sure you are in the directory containing the cleaned data.</u>

```
bash chromosomes.sh clean_data cattle
```

With the individual chromosome files now generated, SHAPEIT can be run. This can be done using the *shapeit.sh* script, with the first argument being the name being cattle and the second argument being the effective population size, in this 400. You can change the script to set the number of threads if you wish.

```
bash shapeit.sh cattle 400
```

With the SHAPEIT outputs generated, they will need to be converted to those which can be used by MOSAIC. This can be done using the *haps_to_mosaic.R* script. This script will require 6 arguments. 

* The path to the .haps and samples info datasets # ~/projects/data/ for example.

* Which chromosome to convert # just an integer input, 27 for example.
* The part of .haps filename before chrno # Taking the example above it would be, cattle.chr.
* The part of .haps filename after chrno # Again taking the example above it would be, .phased.haps, this will be constant.
* This should be a list of the sample population names # The file used to pull the populations of interest should suffice.
* The path to direct the output of this script to # ~/projects/data/MOSAIC/inputs/ for example.

This can be done for all chromosomes with a for loop on the h*aps_to_mosaic.R* script using the *mosaic_inputs.sh* script. This script will only require 4 arguments if the *haps_to_mosaic.R* script is in the same location as the haps files. These arguments are:

* The path to haps files for example: ~/projects/data/
* The he part of .haps filename before chrno or example: cattle.chr 
* The name of the file containing information on the samples. 
* The name of the file containing the path for the output files for example: ~/projects/data/MOSAIC/inputs/

```
bash mosaic_inputs.sh ~/projects/data/ cattle.chr sample_info.txt /projects/data/MOSAIC/inputs/
```



##### 2. Recombination Rate File #####
The recombination rates files are made up of 3 rows and is generated from the recombination map obtained from this [paper](https://doi.org/10.1371/jou). The the three rows are as  follows:

* The first contains the numbers of sites - :sites: XXXX
* The second contains the positions - 5467839 etc.
* The third contains the cumulative recombination rates, so we consecutively add the recombination rates. 

In order to get the recombination map we have to the format used by MOSAIC, the *r_rates.R* script can be used. This script takes two arguments. 

* The first argument is the name of the recombination map file, if unchanged from the paper it should be cattle_rmap.txt
* The second argument is the path to where you want to put the output files, this should be the same as the output location from above, so: /projects/data/MOSAIC/inputs/

```
Rscript r_rates.R cattle_rmap.txt /projects/data/MOSAIC/inputs/
```

This should mean you have all the necessary input files needed to run MOSAIC in the same location.

