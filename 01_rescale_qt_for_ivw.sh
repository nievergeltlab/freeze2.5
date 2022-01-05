for studycomb in $(cat conversion_factors_for_ivw.csv  |   tail -n+2)
do
 echo converting $studycomb
 study=$(echo $studycomb | awk 'BEGIN{ FS=","}{ print $1}')
 #subset=$(echo $studycomb | awk 'BEGIN{ FS=","}{ print $2}')
 fraction=$(echo $studycomb | awk 'BEGIN{ FS=","}{ print $4}')

 for chr in {1..22}
 do
  zcat "$study"_"$chr".gz | awk -v multiplier=$fraction '{if (NR>1) {$12=$12*multiplier; $13=$13*multiplier}; print}'  | gzip > "$study"_"$chr".rescale.gz
 done
 
 #special handling for UKBB and VETSA (BOLT LMM STUDIES)
 #NOT DONE YET!!
 
 done
 
  #special handling for UKBB and VETSA (BOLT LMM STUDIES)
 #NOT DONE YET!!
 
 for studycomb in $(cat conversion_factors_for_ivw.csv  |  tail -n 2)
do
  echo converting $studycomb
 study=$(echo $studycomb | awk 'BEGIN{ FS=","}{ print $1}')
 #subset=$(echo $studycomb | awk 'BEGIN{ FS=","}{ print $2}')
 fraction=$(echo $studycomb | awk 'BEGIN{ FS=","}{ print $4}')

 for chr in {1..22}
 do
  zcat "$study"_"$chr".gz | awk -v multiplier=$fraction '{if (NR>1) {$11=$11*multiplier; $12=$12*multiplier}; print}'  | gzip > "$study"_"$chr".rescale.gz
 done
done
