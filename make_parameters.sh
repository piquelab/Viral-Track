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



cat ./covid-19-fastqV2/run_list.txt | \
while read col1 ;
do                                                                                                                                                                                        
    echo "#################"
    echo $col1 

                                                                                                                 
    echo "cd $PWD;"
    
    while read a; do 
	echo ${a//replace/${col1}}
    done < ./Parameters.txt > ./Parameters/${col1}_parameters.txt
   ## sed 's/replace/${name}/g' Parameters.txt > ./Parameters/${col2}_parameters.txt
done


