#! /bin/env bash
# Step 1: get data
##wget http://cf.10xgenomics.com/samples/cell-exp/1.3.0/hgmm_100/hgmm_100_fastqs.tar;
##/wsu/home/groups/piquelab/scHOLD/scRNAseq/fastq/HV2FYBGXC/outs/fastq_path/HV2FYBGXC/scHOLD-RNA-1/
##tar -xf hgmm_100_fastqs.tar;

set -e;
set -v;


folder="/wsu/home/groups/piquelab/scHOLD/scRNAseq/fastq/HV2FYBGXC/outs/fastq_path/HV2FYBGXC/scHOLD-RNA-1"
prefix="scHOLD-RNA-1"

## REMEMBER TO LOAD umitools
##module load anaconda3.python
##conda activate umitools

cat ${folder}/${prefix}*_R1_001.fastq.gz > ${prefix}_R1.fastq.gz;
cat ${folder}/${prefix}*_R2_001.fastq.gz > ${prefix}_R2.fastq.gz;

# Step 2: Identify correct cell barcodes
umi_tools whitelist --stdin ${prefix}_R1.fastq.gz \
                    --bc-pattern=CCCCCCCCCCCCCCCCNNNNNNNNNN \
                    --set-cell-number=100 \
                    --log2stderr > whitelist.txt;
                    
# Step 3: Extract barcdoes and UMIs and add to read names
umi_tools extract --bc-pattern=CCCCCCCCCCCCCCCCNNNNNNNNNN \
                  --stdin ${prefix}_R1.fastq.gz \
                  --stdout ${prefix}_R1_extracted.fastq.gz \
                  --read2-in ${prefix}_R2.fastq.gz \
                  --read2-out=${prefix}_R2_extracted.fastq.gz \
                  --filter-cell-barcode \
                  --whitelist=whitelist.txt; 
