# MOSAIC
Instructions, scripts, etc. needed to run MOSAIC.

### Installation of MOSAIC ###
On the server use the following command in the directory that contains the file:
R CMD INSTALL -l rlib MOSAIC_1.3.7.tar.gz

### Inputs ###
There should be a folder with 4 types of input file:

#### 1. phased haplotypes: "pop.genofile.chr" in the format #snps rows and #haps columns.
#### 2. pop names: "sample.names" format unimportant apart from first column should have all the population names.
#### 3. snp files: "snpfile.chr" #snps rows and 6 columns of rsID, chr, distance, position, allele ?, allele ?. 
#### 4. recombination map: "rates.chr" 3 rows of #sites, position, cumulative recombination rate (in centiMorgans). 

### Generating Input Files ###
# 1.Phased Haplotypes, SNP files and Sample names files.
Generating these files will require several steps to get it to the format needed to get MOSAIC working. 

In order to generate the phased haplotypes we will need to use the SHAPEIT tool for phasing (https://mathgen.stats.ox.ac.uk/genetics_software/shapeit/).

Before running shapeit SNPs will have to be filtered for SNPs and Individuals with poor calling rates. Duplicates will also cause errors so they will need to be removed too.

plink --cow --file HD_SNP_Data --keep selected.txt --chr 1-29 --geno 0.05 --maf 0.05 --make-bed --out filtered_data
plink --cow --bfile filtered_data --list-duplicate-vars suppress-first --out dups
plink --cow --bfile filtered_data --exclude dups.dupvar --make-bed --out clean_data

Once filtered and cleaned the data will need to be split into chromosomes. This can be done by running the chromosomes.sh script, with the first argument being the name of the cleaned data, in this case clean_data and the second argument, which is the name for the output data, being cattle. 

bash chromosomes.sh clean_data cattle

With the individual chromosome files now generated, SHAPEIT can be run. This can be done using the shapeit.sh script, with the first argument being the name being cattle and the second argument being the effective population size, in this 400. You can change the script to set the number of threads if you wish.

bash shapeit.sh cattle 400

With the SHAPEIT outputs generated, they will need to be converted to those which can be used by MOSAIC. This can be done using the haps_to_mosaic.R script. This script will require 6 arguments. 

1. The path to the .haps and samples info datasets # ~/projects/data/ for example.
2. Which chromosome to convert # just an integer input, 27 for example.
3. The part of .haps filename before chrno # Taking the example above it would be, cattle.chr.
4. The part of .haps filename after chrno # Again taking the example above it would be, .phased.haps, this will be constant.
5. This should be a list of the sample population names # The file used to pull the populations of interest should suffice.
6. The path to direct the output of this script to # ~/projects/data/MOSAIC/inputs/ for example.

This can be done for all chromosomes with a for loop on the haps_to_mosaic.R script using the mosaaic_inputs.sh script. This script will only require 4 arguments if the haps_to_mosaic.R script is in the same location as the haps files. These arguments are:
First argument is path to haps files for example: ~/projects/data/
Second argument is the he part of .haps filename before chrno or example: cattle.chr 
Third argument is the name of the file containing information on the samples. 
Fourth argument is the name of the file containing the path for the output files for example: ~/projects/data/MOSAIC/inputs/

bash mosaic_inputs.sh ~/projects/data/ cattle.chr sample_info.txt /projects/data/MOSAIC/inputs/


