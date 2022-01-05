
 pdf('histograms/01_mrsc.pdf')
 
 p1 <- hist(subset(dm1, P == 1)$Current_PTSD_Continuous,plot=FALSE)
 p2 <- hist(subset(dm1, P == 2)$Current_PTSD_Continuous,plot=FALSE)
 yli <- max(p1$density,p2$density  ) #p3$density,p4$density 
 transparency_level=0.5

  par(mar=c(5, 4, 4, 2) + 0.5)
  plot(p1, col=rgb(1,0,0,transparency_level),freq=FALSE,ylim=c(0,yli),ylab="Frequency", xlab="PTSD",main="",cex.axis=1.45,cex.lab=1.6) 
  plot(p2, col=rgb(0,1,1,transparency_level),freq=FALSE,add=T)  # second
 dev.off()
 
