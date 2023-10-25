#!/bin/bash
#SBATCH -J GRSG_16S_DADA2
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
# Ensure that you call conda activate qiime2-2021.4 before you start. 

export TMPDIR=/gscratch/cbuchan3
module load qiime2/2021.4

# Create a 'shortcut' to the folder you're going to be working out of:
Pronghorn_16S=/project/gutbiome/cbuchan3/pronghorn

# Denoise
qiime dada2 denoise-paired \
  --i-demultiplexed-seqs ${Pronghorn_16S}/demux_output/demux.qza \
  --p-trim-left-f 12 \
  --p-trim-left-r 12 \
  --p-trunc-len-f 150 \
  --p-trunc-len-r 150 \
  --p-n-threads 10 \
  --o-representative-sequences ${Pronghorn_16S}/demux_output/rep-seqs-dada2.qza \
  --o-table ${Pronghorn_16S}/demux_output/table-dada2.qza \
  --o-denoising-stats ${Pronghorn_16S}/demux_output/stats-dada2.qza

# Feature table
qiime feature-table summarize   \
  --i-table ${Pronghorn_16S}/demux_output/table-dada2.qza \
  --o-visualization ${Pronghorn_16S}/demux_output/table-dada2.qzv \
  --m-sample-metadata-file ${Pronghorn_16S}/pronghorn_metadata_plus.tsv


# Representative sequences
qiime feature-table tabulate-seqs \
  --i-data ${Pronghorn_16S}/demux_output/rep-seqs-dada2.qza \
  --o-visualization ${Pronghorn_16S}/demux_output/rep-seqs-dada2.qzv

# Denoising Stats
qiime metadata tabulate \
  --m-input-file ${Pronghorn_16S}/demux_output/stats-dada2.qza \
  --o-visualization ${Pronghorn_16S}/demux_output/stats-dada2.qzv

## Export ASV table

qiime tools export \
  --input-path ${Pronghorn_16S}/demux_output/table-dada2.qza \
  --output-path ${Pronghorn_16S}/exported-files

biom convert -i ${Pronghorn_16S}/exported-files/feature-table.biom \
-o ${Pronghorn_16S}/exported-files/asv-table-dada2.txt \
--to-tsv 
