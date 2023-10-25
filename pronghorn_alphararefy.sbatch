#!/bin/bash
#SBATCH -J Pronghorn_16S_Rarefaction
#SBATCH -o log.o%j 
#SBATCH --account=gutbiome
#SBATCH -N 1
#SBATCH -n 14
#SBATCH -t 1-00:00:00
#SBATCH --mail-type=END
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=cbuchan3@uwyo.edu

# Ensure the temporary directory is in your scratch, so that big files don't take up too much space.
# Ensure that you call conda activate qiime2-2021.2 before you start. 

export TMPDIR=/gscratch/cbuchan3
module load qiime2/2021.4

# Create a 'shortcut' to the folder you're going to be working out of:
Pronghorn_16S=/project/gutbiome/cbuchan3/pronghorn

qiime taxa filter-table \
--i-table ${Pronghorn_16S}/demux_output/table-dada2.qza \
--i-taxonomy ${Pronghorn_16S}/taxonomy.qza \
--p-mode contains \
--p-exclude D_0__Archaea,D_0__Eukaryota \
--o-filtered-table ${Pronghorn_16S}/filtered_table.qza

qiime diversity alpha-rarefaction \
--i-table ${Pronghorn_16S}/filtered_table.qza \
--i-phylogeny ${Pronghorn_16S}/sepp-tree.qza \
--p-max-depth 5000 \
--m-metadata-file ${Pronghorn_16S}/pronghorn_metadata_plus.tsv \
--o-visualization ${Pronghorn_16S}/alpha-rarefaction.qzv
