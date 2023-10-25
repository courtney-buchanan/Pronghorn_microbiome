#!/bin/bash
#SBATCH -J Pronghorn_16S_Demux
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

export TMPDIR= /gscratch/cbuchan3

module load qiime2/2021.4

# Create a 'shortcut' to the folder you're going to be working out of:
Pronghorn_16S=/project/gutbiome/cbuchan3/pronghorn

# To analyze these data, the sequences must first be imported into an artifact of type EMPPairedEndSequences.
# Create the *.qza file: 

qiime tools import \
  --type EMPPairedEndSequences \
  --input-path ${Pronghorn_16S}/FASTQ \
  --output-path ${Pronghorn_16S}/emp-paired-end-sequences.qza

# Demux
qiime demux emp-paired \
	--m-barcodes-file ${Pronghorn_16S}/110562_mapping_file_rename.tsv \
	--m-barcodes-column BarcodeSequence \
	--p-rev-comp-barcodes \
	--p-rev-comp-mapping-barcodes \
	--i-seqs ${Pronghorn_16S}/emp-paired-end-sequences.qza \
	--o-per-sample-sequences ${Pronghorn_16S}/demux_output/demux.qza \
	--o-error-correction-details ${Pronghorn_16S}/demux_output/demux-details.qza

# Summarize
qiime demux summarize \
  --i-data ${Pronghorn_16S}/demux_output/demux.qza \
  --o-visualization ${Pronghorn_16S}/demux_output/per_sample_sequences.qzv
