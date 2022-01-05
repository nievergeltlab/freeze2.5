#Find all studies with an LT measure. If they have it, it will be column 3. Some times files are just dummy files and didnt have covariates

#note that p2_psy3_eur_bry2_pcstrauma.cov.LT.pheno is really an exposure pheno
for files in $(ls pheno | grep trauma | grep -v age) # have to avoid recursion
do

 haslt=$(head pheno/$files -n1 | awk '{print $3}' | grep -v C1) #turn off the C1 if you want to see how doesnt have it
  #echo $files $haslt
  if [  -z $haslt ]
  then
   echo skipping $files $haslt
   else 
     echo making file for $files $haslt
     awk '{print $1,$2,$3}' pheno/"$files"> pheno/"$files".LT.pheno 
   fi
  
 done
 
 #All subjects exposed in GALI, MINV unknown, eacar unknown, feen unknown, ring,stro,vets, unknown.. But not going to do them, just for future reference
 
 #How many have phenotypes
 ls  pheno | grep .LT.pheno
 
 #How many of these were found after doing GWAS?
 ls results_cat | grep LTEPHENO  | grep -v [0-9*].gz
 
 #Get sample sizes..
 for pheno in $(ls  pheno | grep .LT.pheno)
 do
  fs=$(grep -v NA pheno/$pheno | wc -l)
  echo  $pheno $fs
  done
  