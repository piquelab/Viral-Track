#!/bin/bash

set -v 
set -e 

echo $PWD

##fastqfolder=../fastq/
##fastqfolder=/nfs/rprdata/our10xData/fastq/
#fastqfolder=/nfs/rprdata/scilab/CC1-Placenta/fastq

##transcriptome=/nfs/rprdata/refGenome10x/refdata-cellranger-hg19-1.2.0/
##transcriptome=/wsu/home/groups/piquelab/data/refGenome10x/refdata-cellranger-hg19-3.0.0/

#find ${fastqfolder} -name 'SCAIP*fastq.gz' | sed 's/.*SCAIP/SCAIP/;s/_S.*.fastq.gz//' | sort | uniq > libList.txt
##cat libList.txt | sed 's/4-/4/;s/-[Ee][tT]OH//;s/ctrl/CTRL/' > id.txt
##paste libList.txt id.txt > newLibList.txt



cat libList.txt | \
while read col1;
do 
##    fastqs=`find ${fastqfolder} -name "${sample}*fastq.gz" | sed 's/\/SCAIP.*//' | sort | uniq`
##    fastqlist=`echo ${fastqs} | tr ' ' ,`
    echo "#################"
    echo $col1
##    echo $fastqlist
    echo "cd $PWD; module load R; module unload ptython; 
time bash extractUMIs.sh $col1" | qsub -q wsuq -l nodes=1:ppn=10 -l mem=80g -N $col2
 ##   sleep 0.5;
done


## --force-cells=10000
## --jobmode=erprq
## qsub -I -q erprq -l nodes=1:ppn=28 -l mem=120g
