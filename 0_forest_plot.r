args <- commandArgs(trailingOnly = TRUE)
 snpresults <- args[1]
 header_classes <- args[2]
 descriptor <-args[3]
 outfile <- args[4]


# snpresults="results_filtered/forest_plots/rs10266297"
# header_classes="results_filtered/forest_plots/header_classes.csv"
# descriptor="results_filtered/forest_plots/forestplot_descriptor.csv"
# outfile="results_filtered/forest_plots/rs10266297"

#Load metafor library and plyr (for mapped values)
library(metafor)
library(plyr)
library(data.table)

#study info
descriptors <- read.csv(descriptor,header=T,stringsAsFactors=F)
# if (anc != "all") 
# { 
 # if (anc =="aam") 
 # { 
  # descriptors <- subset(descriptors,ancestry %in% c("aam","saf-afr" )) 
 # }else {
   # descriptors <- subset(descriptors,ancestry == anc) 
  # } 
# }

# if (gender == "males")
# {
 # descriptors$study <- descriptors$study_males
 # descriptors <- subset(descriptors, included_male == 1)
# }
# if (gender == "females")
# {
 # descriptors$study <- descriptors$study_females
 # descriptors <- subset(descriptors, included_fem == 1)
# }

#print(dim(descriptors)[1])

headers <- fread(header_classes,data.table=F,header=F)

#Load data (should be in described format of file name followed by 
d1 <- read.table(paste(snpresults,'_class1.use',sep=""),stringsAsFactors=F)
d2 <- read.table(paste(snpresults,'_class2.use',sep=""),stringsAsFactors=F)
d3 <- read.table(paste(snpresults,'_class3.use',sep=""),stringsAsFactors=F)
d4 <- read.table(paste(snpresults,'_class4.use',sep=""),stringsAsFactors=F)

names(d1) <- headers$V1[1:18]
names(d2) <- headers$V2[1:21]
names(d3) <- headers$V3[1:13]
names(d4) <- headers$V4[1:17]

d1$A1n <- d1$A1
d1$A2n <- d1$AX
d2$A1n <- d2$A1
d2$A2n <- d2$AX
d3$A1n <- d3$A1
d3$A2n <- d3$A2
d4$A1n <- d4$ALLELE1
d4$A2n <- d4$ALLELE0


d1$B <- d1$BETA
d1$S <- d1$SE
d1$SNP <- d1$ID

d2$B <- log(d2$OR)
d2$S <- d2$SE

d2$SNP <- d2$ID


d3$B <- log(d3$OR)
d3$S <- d3$SE

d4$B <- d4$BETA
d4$S <- d4$SE

d1$classd <- 1
d2$classd <- 2
d3$classd <- 3
d4$classd <- 4




dat0 <- rbind.fill(d1,d2,d3,d4)
dat0 <- subset(dat0,Study %in% descriptors$filename2)

#R is fucking retarded, this turns TRUE back to T ALLELE!
dat0$A1n <- as.factor(revalue(dat0$A1n, c("TRUE" = "T", "FALSE" = "F")))
dat0$A2n <- as.factor(revalue(dat0$A2n, c("TRUE" = "T", "FALSE" = "F")))
dat0$A1n <- as.character(dat0$A1n)
dat0$A2n <- as.character(dat0$A2n)
dat0$B2 <- NA 


##Align alleles

#Set a reference for pivoting (Just choose row 1 in the data)
pivot=c(dat0[1,"A1n"],dat0[1,"A2n"])

#this is not coded for C G alleles!!

#For every row, check allele alignment
for ( i in 1:dim(dat0)[1])
{
 betaval=dat0[i,]$B
 snp=c(dat0[i,"A1n"],dat0[i,"A2n"])
 flipped=mapvalues(snp, c("A", "C", "G", "T"),  c("T", "G", "C", "A"))

 if (pivot[1] == snp[1] & pivot[2] == snp[2])
 {
  #No changes need to be made, alleles already aligned
     print(paste("No changes for", dat0[i,]$Study,sep=" "))
 } else if (pivot[1] == snp[2] & pivot[2] == snp[1]) 
 {
  #A1n and A2n need to be flipped, change sign of beta value
   betaval=-1*betaval
   print(paste("Direction flip for", dat0[i,]$Study,sep=" "))
 } else if ( !(flipped[1] %in% pivot) |  !(flipped[2] %in% pivot)) 
 {
  print(paste("Study is unflippable", dat0[i,]$Study,sep=" "))
  #Check if allele might be flippable, if not, give NA value 
  betaval=NA
 } else if (flipped[1] == snp[1] &  flipped[2] == snp[2]) 
 {
    print(paste("Wrong strand but correct flip for ", dat0[i,]$Study,sep=" "))
   #It's on the wrong strand but nothing actually needs to be done
 } else if (flipped[1] == snp[2] &  flipped[2] == snp[1]) 
 {
  #It's on the wrong strand and needs to be flipped
   print(paste("Direction and allele flip for", dat0[i,]$Study,sep=" "))
   betaval=-1*betaval
 } else {
 betaval=NA
 }
 
 #Now reassign adjusted beta
 dat0[i,]$B2 <- betaval

}


sink(file=paste(outfile,'.log',sep='_'))



#Merge in study descriptors for the plot


descriptors$Study = descriptors$filename2              
dat <- merge(dat0,descriptors,by="Study")

evalfun <- function(x)
{
 eval(parse(text=x))
}

dat$rescaling_factor2 <- sapply(dat$rescaling_factor,evalfun)

dat$B3 <- dat$B2 * as.numeric(dat$rescaling_factor2) * 100
dat$SE3 <- dat$S * as.numeric(dat$rescaling_factor2) * 100


dat <- dat[order(as.numeric(dat$N),decreasing=c(T)),]

#Which studys are NOT in the original data 
print("Not included (missing data):")
print(descriptors[-which(descriptors$Study %in% dat$Study),]$Study)

print("N Studies analyzed:")
print(dim(dat)[1])


#These will match if the number of inputs in the starting directory 
#matches the number of inputs in the study description file

dat_qt <- subset(dat,Included.As == "Quantitative")
dat_cc <- subset(dat,Included.As != "Quantitative")

rma(yi=dat_qt$B3, sei=dat_qt$SE3, mods=  ~ I(Trauma.Exposure.Sampled ==1) ,data=dat_qt)


meta_res_qt <- rma(yi=dat_qt$B3,sei=dat_qt$SE3,method="FE",slab=dat_qt$abbr)
print("P value is")
meta_res_qt$pval
print("B value is")
meta_res_qt$estimate

save(meta_res_qt,file=paste(outfile,"_fp",'.R',sep=''))
pdf(paste(outfile,'_qt.pdf',sep=''),7,9)
forest(meta_res_qt)
dev.off()


meta_res_cc <- rma(yi=dat_cc$B2,sei=dat_cc$S,method="FE",slab=dat_cc$abbr)
print("P value is")
meta_res_cc$pval
print("B value is")
meta_res_cc$estimate

save(meta_res_cc,file=paste(outfile,"_fp",'.R',sep=''))
pdf(paste(outfile,'_cc.pdf',sep=''),7,9)
forest(meta_res_cc)
dev.off()



# #Write output file for metasoft
# dout <- unlist(matrix(c(dat$B, dat$SE),ncol=2,byrow=F))

# write.table(t(c(outfile,t(dout + 0.0000001))),paste("results_cat/", outfile,"_",anc,'.msin',sep=''),quote=F,row.names=F,col.names=F)
# write.table(paste(dat$abbr,sep="" ),paste("results_cat/", outfile,"_",anc,'.msinstudynames',sep=''),quote=F,row.names=F,col.names=F) # Label by Study Number and abbr
# write.table(dat$caroline_order2,paste("results_cat/", outfile,"_",anc,'.msinstudyorder',sep=''),quote=F,row.names=F,col.names=F) #Order by number of cases

# print(warnings())


# sum(dat$B * 1/dat$SE^2) / sum(1/dat$SE^2)

