#add in the FIDs/IIDs automatically

library(data.table)
d1 <- fread('1_record_linker_file_20180808.csv',data.table=F)


d1[d1$study_abbrev == "KCMT",]$study_abbrev <- "KMCT" #fix typo


datalist <- system('ls data1 | grep p2 | grep csv | grep kmct ',intern=TRUE)

for (dataset in datalist)
{
 d2 <-fread(paste('data1/',dataset,sep=''),data.table=F)
 d2$IID_OLD <- d2$IID
 d2$IID <- NULL
 d3 <- merge(d1,d2,by=c("study_abbrev","IID_OLD"),suffixes=c('','_old'))
 write.csv(d3,paste('data/',dataset,sep=''),row.names=F)
}

#For kmct

 d2 <-fread(paste('data1/',dataset,sep=''),data.table=F)
 d2$FID <- NULL
 d2$IID_OLD <- d2$IID
 d2$IID <- NULL
 d3 <- merge(d1,d2,by=c("study_abbrev","IID_OLD"),suffixes=c('','_old'))
 write.csv(d3,paste('data/',dataset,sep=''),row.names=F)