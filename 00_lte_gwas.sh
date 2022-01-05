
#Convert UKBB sumstats to per chromosome format
sbatch --time=00:15:00 --error errandout/convert.e --output errandout/convert.o  reformat.slurm -D $working_dir 


ancgroup=eur #For data with eu subsets
cov=pcs
sex=all # females
working_dir=$(pwd)

#Do GWAS of LTE
for line in $(cat dosage_locations.csv  | grep nss1)
do
 study_1=$(echo $line | awk 'BEGIN{FS=","}  {print $1}')
 study_2=$(echo $line | awk 'BEGIN{FS=","}  {print $2}')
 timecode=$(echo $line | awk 'BEGIN{FS=","} {print $3}')
 exclude=$(echo $line | awk 'BEGIN{FS=","}  {print $4}')
 #echo $exclude
#if [ $exclude != "1" ] 
#then
 echo gwas for $study_1 $study_2 $timecode 
 sbatch --time=12:00:00 --error errandout/"$study_1"_"$study_2"_"$cov"_"$sex".e --output errandout/"$study_1"_"$study_2"_"$cov"_"$sex".o  \
  --export=ALL,study="$study_1",cov="$cov",study_2="$study_2",ancgroup="$ancgroup",sex="$sex" run_lt_gwas_v2.slurm -D $working_dir 
#fi

done


#Modifies meta-analysis code to work over chromosomes
 for chr in {1..22}
 do
  #Basic analysis of all data
  sed s/XXX/$chr.gz/g eur_lte_m0.mi  >   metal_scripts/eur_lte_m0.mi_$chr
 done
 
#GET NEFF for Exposure studies..
R
library(data.table)
d1 <- fread('pheno/p2_wrby_eur_wrby_pcstrauma.cov.LT.pheno',data.table=F)
table(d1[,3])
 0   1   2
 10 238 181
#neff=412
d1 <- fread('pheno/p2_psy3_eur_bry2_pcstrauma.cov.LT.pheno',data.table=F)
table(d1[,3])

 1  2
56 68
>
#neff = 123
d1 <- fread('pheno/p2_pris_eur_pris_pcstrauma.cov.LT.pheno',data.table=F)
table(d1[,3])

  1   2
 62 544
#neff = 223


#List all of these meta .mi files into a metafilelist.txt file. One per line
 ls  metal_scripts/eur_lte_m0.mi_*  > metafilelist.txt
 
#User: phenotype name 
pheno=LTE_m0_july8_2021

#User: Abbreviated list of covariates. This will be in the output file name 
 cov=pcs
 
 sbatch -t 01:45:00  --error errandout/eur_"$pheno"_"$cov".e --output errandout/eur_"$pheno"_"$cov".o   --export=ALL,metafile=metafilelist.txt -D /home/maihofer/trauma_gwas run_meta_v2_loo_v2.slurm
 
 
 cat metal_results/eur_LTE_Continuous_m0_pcs_alldata_may8_2020_*.gz1.tbl | awk '{if (NR == 1 || ($3 != "MarkerName" )) print}' > metal_results/eur_LTE_Continuous_m0_may8_2020.gz1.tbl
 cat metal_results/eur_LTE_Continuous_m0_pcs_alldata_may8_2020_*.gz1.tbl | awk '{ if (NR ==1 || ($6 >= 0.01 && $6 <= 0.99 && $3 != "MarkerName" && $10 > 0.9*166225.00)) print $1,$2,$3,$4,$5,$6,$10,$11,$12}' | sort -g -k 9 | gzip > results_filtered/eur_LTE_Continuous_m0_may8_2020.gz1.tbl.fuma.gz
 
