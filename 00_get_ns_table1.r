for file in $(ls pheno | grep .pheno)
do
 fname=$(echo $file | awk 'BEGIN {FS="_"}{print $2}')
 fname2=$(echo $file | awk 'BEGIN {FS="_"}{print $3}' | sed 's/.pheno//g')
 
# scount=$(awk '{print $3}' pheno/$file | grep -v NA | wc -l | awk '{print $1}')
 scount=$(LC_ALL=C join <(awk '{print $1"_"$2,$3}' pheno/$file  | LC_ALL=C sort -k1b,1 ) <( awk '{print $1"_"$2}' pheno/p2_"$fname"_eur_"$fname2"_agesex.cov | LC_ALL=C sort -k1b,1) | awk '{print $2}' | grep -v NA | wc -l | awk '{print $1}')
 
 
 
 
 echo $fname $fname2 $scount 
 head -n1 pheno/$file
done



#Have to intersect with those with valid covariate...

#Do I calculate seprate N in case of missing trauma info?? or maybe a column of % with trauma info?

betr	s1	71
coga	s1	991
cogb	s1	823
comc	s1	165
fscd	s1	533
ftca	s1	1040
gali	s1	208
grac	s1	170
gsdc	s1	1490
gtpc	s1	184
meg2	s1	113
minv	s1	105
minv	s2	111
mrsc	s1	2311
mrsc	s2	168
nhrv	s1	533
		
nhrv	s2	1466
nhs2	s1	1321
nss1	s1	4851
nss1	s2	4973
nss2	s1	1859
onga	s1	213
pris	s1	635
psy2	s1	5264
psy2	s2	517
psy3	s1	90
psy3	s2	49
psy3	s3	118
psy3	s4	299
psy3	s5	96
psy3	s7	1245
psy4	s1	451
pts1	s1	139
pts1	s2	218
pts1	s3	42
pts1	s4	77
ring	s1	148

psy3	bryb	s3
psy3	dcsr	s2
psy3	eacr	s4
psy3	feen	s5
psy3	ncmh	s7
psy3	niut	s1
psy3	teic	s6


