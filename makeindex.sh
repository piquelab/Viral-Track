#!/usr/bin/bash

module load star

mkdir index-hg19
cd index

virusFasta="/wsu/home/groups/piquelab/data/viralGenomes/genomes.fasta"
hostFasta="/wsu/home/groups/piquelab/data/refGenome10x/refdata-cellranger-hg19-3.0.0/fasta/genome.fa"


STAR --runThreadN 28 --runMode genomeGenerate --genomeDir ./ --genomeFastaFiles ${virusFasta} ${hostFasta} 
