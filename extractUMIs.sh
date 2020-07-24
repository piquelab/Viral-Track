#!/bin/bash
# Step 1: get data
##wget http://cf.10xgenomics.com/samples/cell-exp/1.3.0/hgmm_100/hgmm_100_fastqs.tar;
##/wsu/home/groups/piquelab/scHOLD/scRNAseq/fastq/HV2FYBGXC/outs/fastq_path/HV2FYBGXC/scHOLD-RNA-1/
##tar -xf hgmm_100_fastqs.tar;

set -e;
set -v;


##folder="/wsu/home/groups/piquelab/scHOLD/scRNAseq/fastq/HV2FYBGXC/outs/fastq_path/HV2FYBGXC/scHOLD-RNA-1"
folder="/nfs/rprdata/our10xData/fastq/"
##prefix="scHOLD-RNA-1"
prefix=$1 
newprefix=$2

echo "Processing $prefix"

##/nfs/rprdata/julong/SCAIP/count/newLibList.txt

outFolder="./newfastq/${newprefix}"

## REMEMBER TO LOAD umitools
module load anaconda3.python
source activate umitools

mkdir -p ${outFolder}

cat `find ${folder} -name "${prefix}*_R1_001.fastq.gz"` > ${outFolder}/${newprefix}_R1.fastq.gz;
cat `find ${folder} -name "${prefix}*_R2_001.fastq.gz"` > ${outFolder}/${newprefix}_R2.fastq.gz;




# Step 2: Identify correct cell barcodes
umi_tools whitelist --stdin ${outFolder}/${newprefix}_R1.fastq.gz \
                    --bc-pattern=CCCCCCCCCCCCCCCCNNNNNNNNNN \
                    --set-cell-number=100 \
                    --log2stderr > ${outFolder}/${newprefix}_whitelist.txt;
                    
# Step 3: Extract barcdoes and UMIs and add to read names
umi_tools extract --bc-pattern=CCCCCCCCCCCCCCCCNNNNNNNNNN \
                  --stdin ${outFolder}/${newprefix}_R1.fastq.gz \
                  --stdout ${outFolder}/${newprefix}_R1_extracted.fastq.gz \
                  --read2-in ${outFolder}/${newprefix}_R2.fastq.gz \
                  --read2-out=${outFolder}/${newprefix}_R2_extracted.fastq.gz \
                  --filter-cell-barcode \
                  --whitelist=${outFolder}/${newprefix}_whitelist.txt; 
