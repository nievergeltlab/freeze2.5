#todo: intersect with .fam file and pc file
R
library(ZIM)
library(data.table)
library(pscl)
phenolist=system("ls pheno | grep .pheno | grep coga",intern=TRUE)
for (files in phenolist)
{
 d1 <- fread(paste('pheno/',files,sep=''),data.table=F)
 
 #Check if binary
 
 #Get proportion of zeros
 d1$Lifetime_PTSD_Continuous_zinb <- d1$Lifetime_PTSD_Continuous_m5 # - 17
 m1 <- zeroinfl(Lifetime_PTSD_Continuous_zinb ~ 1 ,dist='negbin',data=d1)
 theta <- m1$theta
 zeroprop <- length (which((d1$Lifetime_PTSD_Continuous_zinb == 0))) / length (which((d1$Lifetime_PTSD_Continuous_zinb >= 0)))
 
 
 #theta = dispersion
 ks.test(d1$Lifetime_PTSD_Continuous_zinb, pzinb, lambda=mean(d1$Lifetime_PTSD_Continuous_zinb,na.rm=T), k=theta,omega=zeroprop)
 
 par(mfrow=c(1,2))
 hist(rzinb(1000,lambda=mean(d1$Lifetime_PTSD_Continuous_zinb,na.rm=T), k=theta,omega=zeroprop))
 hist(d1$Lifetime_PTSD_Continuous_zinb)
 
 ks.test(d1$Lifetime_PTSD_Continuous_zinb, pnorm,mean=mean(d1$Lifetime_PTSD_Continuous_zinb,na.rm=T),sd=sd(d1$Lifetime_PTSD_Continuous_zinb,na.rm=T))
 
 length (which((d1$Lifetime_PTSD_Continuous_m5 == 0))) / length (which((d1$Lifetime_PTSD_Continuous_m5 >= 0)))
 length (which((d1$Lifetime_PTSD_Continuous == 0))) / length (which((d1$Lifetime_PTSD_Continuous >= 0)))
 