
library(tidyverse)


fl <- list.files(path="./SCAIP_all/","QC_unfiltered.txt",full.names=TRUE,recursive=TRUE)
names(fl) <- gsub("_R2.*","",gsub(".*SCAIP","SCAIP",fl))


dd <- map_dfr(names(fl),function(i){
    ##i <- "SCAIP1-CTRL"
    aux <- read.table(fl[i],sep="\t") %>%
        rownames_to_column("rn") %>% 
        mutate(virusName=gsub("refseq.*\\|","",rn),sample=i)
    })

dim(dd)



write_tsv(dd,"fullTable.tsv")

dd %>% filter(Sequence_entropy>1.2)


pdf("/nfs/rprscratch/wwwShare/gzhang/testplot.pdf")
ggplot(dd,aes(Sequence_entropy,Percent_uniquely_mapped,color=DUST_score)) +
    geom_point()
dev.off()


pdf("/nfs/rprscratch/wwwShare/gzhang/SCAIP_Summary.pdf")
ggplot(dd,aes(Sequence_entropy,Spatial_distribution*100,color=Longest_contig)) +
        geom_point() + xlab("Sequence Complexity") + ylab("% Mapped Genome")
dev.off()



pdf("/nfs/rprscratch/wwwShare/gzhang/EntropyVsContigLength.pdf")
ggplot(dd,aes(Sequence_entropy,Longest_contig,color=DUST_score)) +
    geom_point()
dev.off()

dd %>% filter(Sequence_entropy>1.2,Longest_contig>500)

table(dd$rn) %>% sort()

pdf("/nfs/rprscratch/wwwShare/gzhang/EncephalomyocarditisViralReadsUnique.pdf")
dd %>% filter(grepl("NC_001479",rn)) %>%
    ggplot(aes(N_unique_reads)) + geom_histogram()
dev.off()

pdf("/nfs/rprscratch/wwwShare/gzhang/HepViralReadsUnique.pdf")
dd %>% filter(grepl("NC_009827",rn)) %>%
        ggplot(aes(N_unique_reads)) + geom_histogram()
dev.off()

mysum<- dd %>% group_by(rn) %>%
    summarize(N_reads=max(N_reads),
              N_unique_reads=max(N_unique_reads),
              Percent_uniquely_mapped=max(Percent_uniquely_mapped),
              Sequence_entropy=max(Sequence_entropy),
              Spatial_distribution=max(Spatial_distribution),
              Longest_contig=max(Longest_contig),
              DUST_score=min(DUST_score),
              Percent_high_quality_reads=max(Percent_high_quality_reads),
              virusName=first(virusName),
              nsamples=n())

aux <- mysum %>% arrange(-N_unique_reads) %>%
    filter(Sequence_entropy>1.25) %>%
    select(virusName,Sequence_entropy,N_unique_reads,rn)

pdf("/nfs/rprscratch/wwwShare/gzhang/Barplot2.pdf") 
ggplot(aux,aes(virusName,N_unique_reads)) + geom_col() + coord_flip() + ylab("Number of uniquely mapped reads") + xlab("Virus")
dev.off()



aux <- mysum %>% arrange(-N_unique_reads) %>%                                                      
    filter(Spatial_distribution*100>9) %>%                                                          
    select(virusName,Sequence_entropy,N_unique_reads,rn)

pdf("/nfs/rprscratch/wwwShare/gzhang/Barplot2.pdf")
ggplot(aux,aes(virusName,N_unique_reads)) + geom_col() + coord_flip() + ylab("Number of uniquely mapped reads") + xlab("Virus")
dev.off()


###################

fl2 <- list.files(path="./frompaper_all/","QC_unfiltered.txt",full.names=TRUE,recursive=TRUE)
names(fl2) <- gsub("_R2.*","",fl2)

dd2 <- map_dfr(names(fl2),function(i){
    aux2 <- read.table(fl2[i],sep="\t") %>%
        rownames_to_column("rn") %>%
        mutate(virusName=gsub("refseq.*\\|","",rn),sample=i)
    })



write_tsv(dd2,"fullTable.tsv")

pdf("/nfs/rprscratch/wwwShare/gzhang/frompaper_EvC_plot.pdf")
ggplot(dd2,aes(Sequence_entropy,Longest_contig,color=DUST_score)) +
        geom_point()
dev.off()


pdf("/nfs/rprscratch/wwwShare/gzhang/paper_Summary.pdf")
ggplot(dd2,aes(Sequence_entropy,Spatial_distribution*100,color=Longest_contig)) +
            geom_point() + xlab("Sequence Complexity") + ylab("% Mapped Genome")
dev.off()
