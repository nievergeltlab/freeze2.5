#remember, some studies have current and lifetime (coga fscd etc), make sure you pick the righ one 
d1table <- subset(dm1, !is.na(Current_PTSD_Continuous))

d1table <- subset(dm1, !is.na(Lifetime_PTSD_Continuous))
d1table <- subset(dm1, !is.na(Case))

#for feeny studies
d1table <- subset(dm1, !is.na(Current_PTSD_Continuous_harmonized))
d1table <- subset(d1table,study_abbrev == "TEIC")


#For baker etc
d1table <- subset(dm1, !is.na(Current_PTSD_Continuous))
d1table <- subset(d1table,study == "yehu")

table(d1table$G) 

round( table(d1table$G) /sum(table(d1table$G)) ,3)
 
round(mean(d1table$Age,na.rm=T),2)
round(sd(d1table$Age,na.rm=T),2)




