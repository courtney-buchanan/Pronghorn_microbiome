# Pronghorn_microbiome

## QIIME2 Pipeline
For those wishing to replicate the QIIME2 pipeline we used from the raw reads, they can currently be downloaded from Qiita.
https://qiita.ucsd.edu/study/description/12842 (Note: this project is public but you need to create a Qiita account) 

Qiita download will supply the data in the /FASTQ folder and the 110562_mapping_file.txt used in .sbatch files below. 
Our code uses 110562_mapping_file_rename.tsv as an input which is simply the above mentioned downloaded Qiita mapping file renamed as a .tsv.

If using the .sbatch files to follow our QIIME2 workflow, you will have to do so in the following order.
Note: File locations in the code will have to be altered from our code to fit your file locations. Pronghorn metadata file used with the QIIME pipeline is pronghorn_metadata_plus.tsv file


1) pronghorn_demux_sublime.sbatch
2) pronghorn_dada2.sbatch
3) pronghorn_taxonomy.sbatch
4) pronghorn_alphararefy.sbatch (Note- despite name, this file will produce a non-rarefied table (filtered_table.qza) as well as an alpha rarefaction visualization at the chosen level (coded for 5000 here))

Note: before running taxonomy, make sure that Silva databases are stored in your working folder
To get the Silva files run the following code:

wget https://data.qiime2.org/2021.2/common/silva-138-99-seqs-515-806.qza
wget https://data.qiime2.org/2021.2/common/silva-138-99-tax-515-806.qza
wget https://data.qiime2.org/2021.2/common/sepp-refs-silva-128.qza

## Downstream R Analysis
Following the above QIIME2 pipeline will produce the following outputs needed for R analysis. These 3 files area also included in this project on github. 
1) filtered_table.qza
2) taxonomy.qza
3) sepp-tree.qza

Code for downstream analysis in R is in the final_pronghorn_updated_R.Rmd file

Metadata file for downstream R anlaysis will be included with paper upon publication. It is also included in this project (S6Table.csv). This can be substituted in the R code for the metadata file "7_11_final_pronghorn_metadata.csv" 
