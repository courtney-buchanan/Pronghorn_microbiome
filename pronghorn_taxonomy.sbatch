#!/bin/bash
#SBATCH -J Pronghorn_16S_Taxonomy
#SBATCH -o log.o%j 
#SBATCH --account=gutbiome
#SBATCH -N 1
#SBATCH -n 14
#SBATCH --mem=0
#SBATCH -t 1-00:00:00
#SBATCH --mail-type=END
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=cbuchan3@uwyo.edu

# Ensure the temporary directory is in your scratch, so that big files don't take up too much space.
# Ensure that you call conda activate qiime2-2021.4 before you start. 

export TMPDIR=/gscratch/cbuchan3
module load qiime2/2021.4

# Create a 'shortcut' to the folder you're going to be working out of:
Pronghorn_16S=/project/gutbiome/cbuchan3/pronghorn

echo ${Pronghorn_16S}

# Taxonomy: Train the classifier
qiime feature-classifier fit-classifier-naive-bayes \
  --i-reference-reads ${Pronghorn_16S}/silva-138-99-seqs-515-806.qza \
  --i-reference-taxonomy ${Pronghorn_16S}/silva-138-99-tax-515-806.qza \
  --o-classifier ${Pronghorn_16S}/classifier.qza 

#Phylogenetic Tree
qiime fragment-insertion sepp \
    --i-representative-sequences ${Pronghorn_16S}/demux_output/rep-seqs-dada2.qza \
    --i-reference-database ${Pronghorn_16S}/sepp-refs-silva-128.qza \
    --p-threads 4 \
    --o-tree ${Pronghorn_16S}/sepp-tree.qza \
    --o-placements ${Pronghorn_16S}/sepp-placements.qza

qiime feature-classifier classify-sklearn \
	--i-reads ${Pronghorn_16S}/demux_output/rep-seqs-dada2.qza \
	--i-classifier /project/gutbiome/cbuchan3/pronghorn/classifier.qza \
	--o-classification ${Pronghorn_16S}/taxonomy.qza

