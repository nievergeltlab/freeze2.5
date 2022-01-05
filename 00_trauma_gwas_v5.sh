###Prelim steps

## Summary stat conversion from genome-wide to chromosome

#For any dataset using only existing sumstats:
# sbatch --time=02:00:00 --error errandout/convert.e --output errandout/convert.o  reformat.slurm -D $working_dir 
sbatch --time=00:15:00 --error errandout/convert.e --output errandout/convert.o  reformat.slurm -D $working_dir 


#For any new dataset run in this script, conversion to chromosome format done automatically by the code


###Analysis steps: 

##GWAS of each dataset

ancgroup=eur #For data with eu subsets
cov=pcs
sex=males # females
working_dir=$(pwd)

#Make sure time codes are correct
IFS=$'\n'
for line in $(cat dosage_locations.csv | grep coga )
do
 study_1=$(echo $line | awk 'BEGIN{FS=","}  {print $1}')
 study_2=$(echo $line | awk 'BEGIN{FS=","}  {print $2}')
 timecode=$(echo $line | awk 'BEGIN{FS=","} {print $3}')
 exclude=$(echo $line | awk 'BEGIN{FS=","}  {print $4}')
 echo $exclude
#if [ $exclude != "1" ] 
#then
 echo gwas for $study_1 $study_2 $timecode 
 sbatch --time=$timecode --error errandout/"$study_1"_"$study_2"_"$cov"_"$sex".e --output errandout/"$study_1"_"$study_2"_"$cov"_"$sex".o  \
  --export=ALL,study="$study_1",cov="$cov",study_2="$study_2",ancgroup="$ancgroup",sex="$sex" run_trauma_gwas_v2.slurm -D $working_dir 
#fi

done


##Meta analysis

#User: Make a meta-analysis script. Follow format of eur_ptsd_m0.mi
#User: Studies should be weighted by effective sample size. Weights are set in the meta-script
#00_weight_checkr.r contains code to take input phenotypes and estimate a weighting factor


#Modifies meta-analysis code to work over chromosomes
 for chr in {1..22}
 do

  #Basic analysis of all data
#  sed s/XXX/$chr.gz/g eur_ptsd_m0.mi  >   metal_scripts/eur_ptsd_m0.mi_$chr
  
    #Basic analysis of all data
  #sed s/XXX/$chr.gz/g eur_ptsd_m0_noyalepenn_noipsych.mi  >   metal_scripts/eur_ptsd_m0_noyalepenn_noipsych.mi_$chr
  
  #freeze twopoint5 without mrs
 # sed s/XXX/$chr.gz/g freezetwopointfive_nomrs.mi  >   metal_scripts/freezetwopointfive_nomrs.mi_$chr
  
  #only QT, reweighted
 #   sed s/XXX/$chr/g eur_ptsd_m0_qtonly_ivw.mi  >   metal_scripts/eur_ptsd_m0_qtonly_ivw.mi_$chr
   
   sed s/XXX/$chr/g eur_ptsd_divya_m0.mi  >   metal_scripts/eur_ptsd_divya_m0.mi_$chr
  
 # Only trauma sampled 
  #sed s/XXX/$chr.gz/g eur_ptsd_m0_ts.mi  >   metal_scripts/eur_ptsd_m0_ts.mi_$chr
 # Only NOT trauma sampled (excluding UKBB)
  #sed s/XXX/$chr.gz/g eur_ptsd_m0_nots.mi  >   metal_scripts/eur_ptsd_m0_nots.mi_$chr
  #Only not trauma sampled (plus UKBB)
 # sed s/XXX/$chr.gz/g eur_ptsd_m0_nots_plusukbb.mi >   metal_scripts/eur_ptsd_m0_nots_plusukbb.mi_$chr
  #Basic analysis plus trauma covariate
 #  sed s/XXX/$chr.gz/g eur_ptsd_m0_traumacov.mi  >   metal_scripts/eur_ptsd_m0_traumacov.mi_$chr
  #QT studies only
  #  sed s/XXX/$chr.gz/g eur_ptsd_m0_qtonly.mi  >   metal_scripts/eur_ptsd_m0_qtonly.mi_$chr
  #CC studies only
   # sed s/XXX/$chr.gz/g eur_ptsd_m0_cconly.mi  >   metal_scripts/eur_ptsd_m0_cconly.mi_$chr
  
   #sed s/XXX/$chr/g eur_ptsd_m0_qtccmeta.mi  >   metal_scripts/eur_ptsd_m0_qtandccreweighted.mi_$chr
   
 done
 


#List all of these meta .mi files into a metafilelist.txt file. One per line
 ls  metal_scripts/eur_ptsd_m0_qtonly.mi_*  > metafilelist.txt
 ls  metal_scripts/eur_ptsd_m0_cconly.mi_*  >> metafilelist.txt
 ls  metal_scripts/eur_ptsd_m0_qtandccreweighted.mi_*  > metafilelist.txt
 ls  metal_scripts/eur_ptsd_m0_noyalepenn_noipsych.mi_*  > metafilelist.txt
 ls  metal_scripts/freezetwopointfive_nomrs.mi*  > metafilelist.txt
 
  ls  metal_scripts/freezetwopointfive_nomrs.mi*  > metafilelist.txt
 
 ls  metal_scripts/eur_ptsd_divya_m0.mi_* | grep 12 > metafilelist.txt


 metal_scripts/eur_ptsd_m0_noyalepenn_noipsych.mi_$chr
 
 
 ls  metal_scripts/* | grep  _ts  > metafilelist.txt
 
 ls  metal_scripts/* | grep  _nots  >> metafilelist.txt
 
 ls  metal_scripts/* | grep  plus >> metafilelist.txt



#User: Give name of phenotype. This will be in the output file name
 pheno=PTSD_Continuous_m0_qtdivya_may8_2020

#User: Abbreviated list of covariates. This will be in the output file name
 cov=pcs
 sbatch -t 01:45:00  --error errandout/eur_"$pheno"_"$cov".e --output errandout/eur_"$pheno"_"$cov".o   --export=ALL,metafile=metafilelist.txt -D /home/maihofer/trauma_gwas run_meta_v2_loo_v2.slurm
 

#Concatenate meta-analysis results
#User: find out what hte max N is and make sure only decently covered loci are returned
#If you recompile these results, atch out, I dumbly put new data with names after the date, so the wildcard wont work!
 cat metal_results/eur_PTSD_Continuous_m0_cconly_pcs_alldata_may8_2020_*.gz1.tbl | awk '{if (NR == 1 || ($3 != "MarkerName" )) print}' > metal_results/eur_PTSD_Continuous_m0_cconly_pcs_alldata_may8_2020.gz1.tbl
 cat metal_results/eur_PTSD_Continuous_m0_cconly_pcs_alldata_may8_2020_*.gz1.tbl | awk '{if (NR == 1 || ($3 != "MarkerName" )) print}' > metal_results/eur_PTSD_Continuous_m0_cconly_pcs_alldata_may8_2020.gz1.tbl

 cat metal_results/eur_PTSD_Continuous_m0_pcs_alldata_may8_2020_noyalepenn_noipsych_*.gz1.tbl |  awk '{ if (NR ==1 || ($6 >= 0.01 && $6 <= 0.99 && $3 != "MarkerName" && $10 > 0.9*173709.00)) print $1,$2,$3,$4,$5,$6,$10,$11,$12}' | sort -g -k 9 | gzip > results_filtered/eur_PTSD_Continuous_m0_pcs_alldata_may8_2020_noyalepenn_noipsych.tbl.fuma.gz
 
 cat metal_results/eur_PTSD_Continuous_m0_pcs_nomrs_may8_2020_*.gz1.tbl |  awk '{ if (NR ==1 || ($6 >= 0.01 && $6 <= 0.99 && $3 != "MarkerName" && $10 > 0.9*171234)) print $1,$2,$3,$4,$5,$6,$10,$11,$12}' | sort -g -k 9 | gzip > results_filtered/eur_PTSD_Continuous_m0_pcs_nomrs_may8_2020.tbl.fuma.gz
 
 cat metal_results/eur_PTSD_Continuous_m0_pcs_alldata_may8_2020_gmrf_*.tbl |  awk '{ if (NR ==1 || ($6 >= 0.01 && $6 <= 0.99 && $3 != "MarkerName" && $10 > 0.9*176508.00)) print $1,$2,$3,$4,$5,$6,$10,$11,$12}' | sort -g -k 9 | gzip > results_filtered/eur_PTSD_Continuous_m0_pcs_may8_2020_gmrf.tbl.fuma.gz
 
 zcat results_filtered/eur_PTSD_Continuous_m0_pcs_nomrs_may8_2020.tbl.fuma.gz | awk '{if (NR==1) BETA="Beta"; if(NR>1) BETA=3.09*$8/sqrt(2*$7 * $6 * (1-$6)); print $0,BETA}'  | gzip > results_filtered/eur_PTSD_Continuous_m0_pcs_nomrs_may8_2020.tbl.fuma.beta.gz
 
  sed=3.09 #Give standard error for tinnitus measure
 tinnitus_meta$BETA = tinnitus_meta$Zscore * sed / sqrt(2*tinnitus_meta$Weight*tinnitus_meta$Freq1*(1-tinnitus_meta$Freq1))
 
   cat freezetwopointfive_noyalepenn_noipsych1.tbl |  awk '{ if (NR ==1 || ($6 >= 0.01 && $6 <= 0.99 && $3 != "MarkerName" && $10 > 0.9*320369.00)) print $1,$2,$3,$4,$5,$6,$10,$11,$12}' | sort -g -k 9 | gzip > freezetwopointfive_noyalepenn_noipsych1.fuma.gz
 metal_results/eur_PTSD_Continuous_m0_qtonlyreweight_pcs_alldata_may8_2020_*.rescale.gz1.tbl
 echo freezetwopointfive_noyalepenn_noipsych.mi > metafilelist.txt
 
 
 #0-1 rescaled PTSD
 #This first one is not quite right because it does not use ivw, but we can use it to count N and thus obtain a good marker list...
 # cat metal_results/eur_PTSD_Continuous_m0_qtonlyreweight_pcs_alldata_may8_2020_*.rescale.gz1.tbl | awk '{if (NR == 1 || ($3 != "MarkerName" )) print}' > metal_results/eur_PTSD_Continuous_m0_qtonlyreweight_pcs_alldata_may8_2020.rescale.gz.tbl
 
 # cat   metal_results/eur_PTSD_Continuous_m0_qtonlyreweight_pcs_alldata_may8_2020.rescale.gz.tbl |  awk '{ if (NR ==1 || ($6 >= 0.01 && $6 <= 0.99 && $3 != "MarkerName" && $10 > 0.9*165825.00)) print $1,$2,$3,$4,$5,$6,$10,$11,$12}' | sort -g -k 9 | gzip > metal_results/eur_PTSD_Continuous_m0_qtonlyreweight_pcs_alldata_may8_2020.rescale.gz.tbl.fuma.gz
 zcat metal_results/eur_PTSD_Continuous_m0_qtonlyreweight_pcs_alldata_may8_2020.rescale.gz.tbl.fuma.gz | awk '{print $3,$7}' | LC_ALL=C sort -k1b,1 > metal_results/eur_PTSD_Continuous_m0_qtonlyreweight_pcs_alldata_may8_2020.rescale.gz.tbl.fuma.gz.snplist
 
cat metal_results/eur_PTSD_Continuous_m0_qtonlyreweight_pcs_alldata_may8_2020_*.rescale.gz1.tbl | awk '{if (NR == 1 || ($3 != "MarkerName" )) print}' | LC_ALL=C sort -k3b,3 > metal_results/eur_PTSD_Continuous_m0_qtonlyreweight_pcs_alldata_may8_2020.rescale.gz.tbl.ivw
 LC_ALL=C join -1 1 -2 3 metal_results/eur_PTSD_Continuous_m0_qtonlyreweight_pcs_alldata_may8_2020.rescale.gz.tbl.fuma.gz.snplist metal_results/eur_PTSD_Continuous_m0_qtonlyreweight_pcs_alldata_may8_2020.rescale.gz.tbl.ivw | sort -g -k13 | grep -v nan |  gzip > results_filtered/eur_PTSD_Continuous_m0_qtonlyreweight_pcs_alldata_may8_2020.rescale.gz.tbl.ivw.goodsnps.gz


metal_results/eur_PTSD_Continuous_m0_pcs_alldata_may8_2020.gz1.tbl

freezetwopointfive_noyalepenn_noipsych1.tbl
#Reweight meta-analysis results using formula
for chr in {1..22}
do
 popprev=0.1
 sampleprev=0.5
 h2qt=0.0547
 h2cc=0.0612
 rg=0.9646
 lj=124.718 
 M=5961159 
 zv=0.1755 # zv <- dnorm(qnorm(popprev))
 
 awk -v zv=$zv -v popprev=$popprev -v sampleprev=$sampleprev '{if(NR==1) N_cc_eff = "N_cc_eff"; else N_cc_eff = $10*sampleprev*(1-sampleprev)*zv^2/(popprev*(1-popprev))^2; print $0,N_cc_eff}' metal_results/eur_PTSD_Continuous_m0_cconly_pcs_alldata_may8_2020_"$chr".gz1.tbl > metal_results/eur_PTSD_Continuous_m0_cconlyreweight_pcs_alldata_may8_2020_"$chr".gz1.tbl 
 
 awk -v h2qt=$h2qt -v h2cc=$h2cc  -v rg=$rg -v lj=$lj  -v Msnp=$M '{if(NR==1) { N_qt_eff="N_qt_eff"; Z_eff="Z_eff"} else { denom2=(1-rg)*$10*h2qt*lj/Msnp; denomA=1+denom2; N_qt_eff=$10*h2qt/h2cc/denomA; Z_eff=$11/sqrt(denomA) }; print $0,N_qt_eff,Z_eff}' metal_results/eur_PTSD_Continuous_m0_qtonly_pcs_alldata_may8_2020_"$chr".gz1.tbl > metal_results/eur_PTSD_Continuous_m0_qtonlyreweight_pcs_alldata_may8_2020_"$chr".gz1.tbl 
 done
  
  #For the IVW performed grotzinger analysis
  cat metal_results/eur_PTSD_Continuous_m0_cconly_pcs_alldata_may8_2020_*.gz1.tbl | awk '{if (NR == 1 || ($3 != "MarkerName" )) print}' > metal_results/eur_PTSD_Continuous_m0_cconly_pcs_alldata_may8_2020.gz1.tbl


#Meta-analyze both of these
 sbatch -t 00:45:00  --error errandout/eur_"$pheno"_"$cov"_qtcc.e --output errandout/eur_"$pheno"_"$cov"_qtcc.o   --export=ALL,metafile=metafilelist.txt -D /home/maihofer/trauma_gwas run_meta_v2_loo_v2.slurm
 
 cat metal_results/eur_PTSD_Continuous_m0_qtandccreweighted_pcs_alldata_may8_2020_*.tbl |  awk '{ if (NR ==1 || ($6 >= 0.01 && $6 <= 0.99 && $3 != "MarkerName" && $10 > 0.9*157576.3)) print $1,$2,$3,$4,$5,$6,$10,$11,$12}'   | grep -v : | sort -g -k 9 | gzip  > results_filtered/eur_PTSD_Continuous_m0_qtandccreweighted_pcs_alldata_may8_2020.fuma.gz
 
 
 cat metal_results/eur_PTSD_Continuous_m0_qtandccreweighted_pcs_alldata_may8_2020_*.tbl  | awk '{if (NR == 1 || ($3 != "MarkerName" )) print}'  >  metal_results/eur_PTSD_Continuous_m0_qtandccreweighted_pcs_alldata_may8_2020.gz1.tbl


##ldsc analysis
 module load pre2019
 module load ldsc 

#NOTE: careful, right now this main thing is for hte qtandccreweighted, this was NOT used in the final... need to fix this!

 #Filter data down to just LDSC SNPs then munge
 LC_ALL=C join -1 1 -2 3  <(awk '{print $1}' ldsc-master/ldsc_data/eur_w_ld_chr/w_hm3.snplist.sorted | LC_ALL=C sort -k1b,1 ) <(cat metal_results/eur_PTSD_Continuous_m0_qtandccreweighted_pcs_alldata_may8_2020.gz1.tbl | awk '{if (NR == 1) $3="SNP"; print}'   | LC_ALL=C sort -k3b,3 ) | gzip > results_filtered/eur_PTSD_Continuous_m0_qtandccreweighted_pcs_alldata_may8_2020.gz1.tbl.premunge.gz 
 /home/maihofer/trauma_gwas/ldsc-master/munge_sumstats.py --sumstats results_filtered/eur_PTSD_Continuous_m0_qtandccreweighted_pcs_alldata_may8_2020.gz1.tbl.premunge.gz  --out results_filtered/eur_PTSD_Continuous_m0_qtandccreweighted_pcs_alldata_may8_2020.gz1.tbl.munge.gz #add --N-col OBS_CT for the sample size
 
 #Get format for LDhub
 gzip -d results_filtered/eur_PTSD_Continuous_m0_qtandccreweighted_pcs_alldata_may8_2020.gz1.tbl.munge.gz > results_filtered/eur_PTSD_Continuous_m0_qtandccreweighted_pcs_alldata_may8_2020.gz1.tbl.munge.txt
 zip results_filtered/eur_PTSD_Continuous_m0_qtandccreweighted_pcs_alldata_may8_2020.gz1.tbl.munge.txt.zip results_filtered/eur_PTSD_Continuous_m0_qtandccreweighted_pcs_alldata_may8_2020.gz1.tbl.munge.txt
 
 #Run LDSC
  /home/maihofer/trauma_gwas/ldsc-master/ldsc.py \
 --h2 results_filtered/eur_PTSD_Continuous_m0_qtandccreweighted_pcs_alldata_may8_2020.gz1.tbl.munge.gz.sumstats.gz \
 --ref-ld-chr ldsc-master/ldsc_data/eur_w_ld_chr/ \
 --w-ld-chr  ldsc-master/ldsc_data/eur_w_ld_chr/ \
 --out results_filtered/eur_PTSD_Continuous_m0_qtandccreweighted_pcs_alldata_may8_2020.gz1.tbl.munge.gz.tbl.ldsc




##For analysis of QT only/ CC only..
 module load pre2019
 module load ldsc 

 cat metal_results/eur_PTSD_Continuous_m0_qtonly_pcs_alldata_may8_2020_*.gz1.tbl | awk '{if (NR == 1 || ($3 != "MarkerName"  )) print}' > metal_results/eur_PTSD_Continuous_m0_qtonly_pcs_alldata_may8_2020.gz1.tbl
 LC_ALL=C join -1 1 -2 3  <(awk '{print $1}' ldsc-master/ldsc_data/eur_w_ld_chr/w_hm3.snplist.sorted | LC_ALL=C sort -k1b,1 ) <(cat metal_results/eur_PTSD_Continuous_m0_qtonly_pcs_alldata_may8_2020.gz1.tbl | awk '{if (NR == 1) $3="SNP"; print}'   | LC_ALL=C sort -k3b,3 ) | gzip > results_filtered/eur_PTSD_Continuous_m0_qtonly_pcs_alldata_may8_2020.gz1.tbl.premunge.gz 
 /home/maihofer/trauma_gwas/ldsc-master/munge_sumstats.py --sumstats results_filtered/eur_PTSD_Continuous_m0_qtonly_pcs_alldata_may8_2020.gz1.tbl.premunge.gz  --out results_filtered/eur_PTSD_Continuous_m0_qtonly_pcs_alldata_may8_2020.gz1.tbl.munge.gz #add --N-col OBS_CT for the sample size
 
 cat metal_results/eur_PTSD_Continuous_m0_cconly_pcs_alldata_may8_2020_*.gz1.tbl | awk '{if (NR == 1 || ($3 != "MarkerName"  )) print}' > metal_results/eur_PTSD_Continuous_m0_cconly_pcs_alldata_may8_2020.gz1.tbl
 LC_ALL=C join -1 1 -2 3  <(awk '{print $1}' ldsc-master/ldsc_data/eur_w_ld_chr/w_hm3.snplist.sorted | LC_ALL=C sort -k1b,1 ) <(cat metal_results/eur_PTSD_Continuous_m0_cconly_pcs_alldata_may8_2020.gz1.tbl | awk '{if (NR == 1) $3="SNP"; print}'   | LC_ALL=C sort -k3b,3 ) | gzip > results_filtered/eur_PTSD_Continuous_m0_cconly_pcs_alldata_may8_2020.gz1.tbl.premunge.gz 
 /home/maihofer/trauma_gwas/ldsc-master/munge_sumstats.py --sumstats results_filtered/eur_PTSD_Continuous_m0_cconly_pcs_alldata_may8_2020.gz1.tbl.premunge.gz  --out results_filtered/eur_PTSD_Continuous_m0_cconly_pcs_alldata_may8_2020.gz1.tbl.munge.gz #add --N-col OBS_CT for the sample size

  
 #Run LDSC
  /home/maihofer/trauma_gwas/ldsc-master/ldsc.py \
 --rg results_filtered/eur_PTSD_Continuous_m0_qtonly_pcs_alldata_may8_2020.gz1.tbl.munge.gz.sumstats.gz,results_filtered/eur_PTSD_Continuous_m0_cconly_pcs_alldata_may8_2020.gz1.tbl.munge.gz.sumstats.gz \
 --ref-ld-chr ldsc-master/ldsc_data/eur_w_ld_chr/ \
 --w-ld-chr  ldsc-master/ldsc_data/eur_w_ld_chr/ \
 --out results_filtered/rg_qtonly_cconly_eur_PTSD_Continuous_m0_pcs_alldata_may8_2020.tbl.munge.gz.tbl.ldsc

 #For what I am going to give to grotzinger...
 
 LC_ALL=C join -1 1 -2 1  <(awk '{print $1}' ldsc-master/ldsc_data/eur_w_ld_chr/w_hm3.snplist.sorted | LC_ALL=C sort -k1b,1 ) <(zcat results_filtered/eur_PTSD_Continuous_m0_qtonlyreweight_pcs_alldata_may8_2020.rescale.gz.tbl.ivw.goodsnps.gz | awk '{if (NR == 1) $1="SNP"; print}'   | LC_ALL=C sort -k1b,1 ) | gzip > results_filtered/eur_PTSD_Continuous_m0_qtonlyreweight_pcs_alldata_may8_2020.rescale.gz.tbl.ivw.goodsnps.premunge.gz 
 /home/maihofer/trauma_gwas/ldsc-master/munge_sumstats.py --sumstats results_filtered/eur_PTSD_Continuous_m0_qtonlyreweight_pcs_alldata_may8_2020.rescale.gz.tbl.ivw.goodsnps.premunge.gz  --out results_filtered/eur_PTSD_Continuous_m0_qtonlyreweight_pcs_alldata_may8_2020.rescale.gz.tbl.ivw.goodsnps.munge.gz #add --N-col OBS_CT for the sample size
 
 /home/maihofer/trauma_gwas/ldsc-master/ldsc.py \
 --h2 results_filtered/eur_PTSD_Continuous_m0_qtonlyreweight_pcs_alldata_may8_2020.rescale.gz.tbl.ivw.goodsnps.munge.gz.sumstats.gz \
 --ref-ld-chr ldsc-master/ldsc_data/eur_w_ld_chr/ \
 --w-ld-chr  ldsc-master/ldsc_data/eur_w_ld_chr/ \
 --out results_filtered/eur_PTSD_Continuous_m0_qtonlyreweight_pcs_alldata_may8_2020.rescale.gz.tbl.ivw.goodsnps.munge.gz.ldsc


  
##For the analysis comparing trauma/no trauma..
  
##ldsc analysis
 module load pre2019
 module load ldsc 

 cat metal_results/eur_PTSD_Continuous_m0_trauma_pcs_alldata_may8_2020_*.gz1.tbl | awk '{if (NR == 1 || ($3 != "MarkerName" && $10 > 15000 )) print}' > metal_results/eur_PTSD_Continuous_m0_trauma_pcs_alldata_may8_2020.gz1.tbl
 LC_ALL=C join -1 1 -2 3  <(awk '{print $1}' ldsc-master/ldsc_data/eur_w_ld_chr/w_hm3.snplist.sorted | LC_ALL=C sort -k1b,1 ) <(cat metal_results/eur_PTSD_Continuous_m0_trauma_pcs_alldata_may8_2020.gz1.tbl | awk '{if (NR == 1) $3="SNP"; print}'   | LC_ALL=C sort -k3b,3 ) | gzip > results_filtered/eur_PTSD_Continuous_m0_trauma_pcs_alldata_may8_2020.gz1.tbl.premunge.gz 
 munge_sumstats.py --sumstats results_filtered/eur_PTSD_Continuous_m0_trauma_pcs_alldata_may8_2020.gz1.tbl.premunge.gz  --out results_filtered/eur_PTSD_Continuous_m0_trauma_pcs_alldata_may8_2020.gz1.tbl.munge.gz #add --N-col OBS_CT for the sample size
 
 cat metal_results/eur_PTSD_Continuous_m0_NOtrauma_pcs_alldata_may8_2020_*.gz1.tbl | awk '{if (NR == 1 || ($3 != "MarkerName" && $10 > 15000 )) print}' > metal_results/eur_PTSD_Continuous_m0_NOtrauma_pcs_alldata_may8_2020.gz1.tbl
 LC_ALL=C join -1 1 -2 3  <(awk '{print $1}' ldsc-master/ldsc_data/eur_w_ld_chr/w_hm3.snplist.sorted | LC_ALL=C sort -k1b,1 ) <(cat metal_results/eur_PTSD_Continuous_m0_NOtrauma_pcs_alldata_may8_2020.gz1.tbl | awk '{if (NR == 1) $3="SNP"; print}'   | LC_ALL=C sort -k3b,3 ) | gzip > results_filtered/eur_PTSD_Continuous_m0_NOtrauma_pcs_alldata_may8_2020.gz1.tbl.premunge.gz 
 munge_sumstats.py --sumstats results_filtered/eur_PTSD_Continuous_m0_NOtrauma_pcs_alldata_may8_2020.gz1.tbl.premunge.gz  --out results_filtered/eur_PTSD_Continuous_m0_NOtrauma_pcs_alldata_may8_2020.gz1.tbl.munge.gz #add --N-col OBS_CT for the sample size

#Format for fuma # be sure to set Ns
 cat metal_results/eur_PTSD_Continuous_m0_trauma_pcs_alldata_may8_2020_*.gz1.tbl    |  awk '{ if (NR ==1 || ($6 >= 0.01 && $6 <= 0.99 && $3 != "MarkerName" && $10 > 0.7*17614)) print $1,$2,$3,$4,$5,$6,$10,$11,$12}'   | grep -v : | sort -g -k 9 | gzip  > results_filtered/eur_PTSD_Continuous_m0_trauma_pcs_alldata_may8_2020.fuma.gz
 cat metal_results/eur_PTSD_Continuous_m0_NOtrauma_pcs_alldata_may8_2020_*.gz1.tbl |  awk '{ if (NR ==1 || ($6 >= 0.01 && $6 <= 0.99 && $3 != "MarkerName" && $10 > 0.7*24515.00)) print $1,$2,$3,$4,$5,$6,$10,$11,$12}'   | grep -v : | sort -g -k 9 | gzip  > results_filtered/eur_PTSD_Continuous_m0_NOtrauma_pcs_alldata_may8_2020.fuma.gz
 cat metal_results/eur_PTSD_Continuous_m0_NOtraumaplusukb_pcs_alldata_may8_2020_*.gz1.tbl |  awk '{ if (NR ==1 || ($6 >= 0.01 && $6 <= 0.99 && $3 != "MarkerName" && $10 > 0.7*159101.00)) print $1,$2,$3,$4,$5,$6,$10,$11,$12}'   | grep -v : | sort -g -k 9 | gzip  > results_filtered/eur_PTSD_Continuous_m0_NOtraumaplusukb_pcs_alldata_may8_2020.fuma.gz
  
 
 #Run LDSC
  /home/maihofer/trauma_gwas/ldsc-master/ldsc.py \
 --rg results_filtered/eur_PTSD_Continuous_m0_trauma_pcs_alldata_may8_2020.gz1.tbl.munge.gz.sumstats.gz,results_filtered/eur_PTSD_Continuous_m0_NOtrauma_pcs_alldata_may8_2020.gz1.tbl.munge.gz.sumstats.gz \
 --ref-ld-chr ldsc-master/ldsc_data/eur_w_ld_chr/ \
 --w-ld-chr  ldsc-master/ldsc_data/eur_w_ld_chr/ \
 --out results_filtered/rg_trauma_notrauma_eur_PTSD_Continuous_m0_pcs_alldata_may8_2020.tbl.munge.gz.tbl.ldsc

 #Correlate trauma/no trauma to UKBB results as well
  LC_ALL=C join -1 1 -2 1  <(awk '{print $1}' ldsc-master/ldsc_data/eur_w_ld_chr/w_hm3.snplist.sorted | LC_ALL=C sort -k1b,1 ) <(zcat sumstats/ptsd_qt_ukbb_mar23_2020_unrelated.bgen.stats.gz | LC_ALL=C sort -k1b,1 ) | gzip > results_filtered/ptsd_qt_ukbb_mar23_2020_unrelated.bgen.stats.gz.premunge.gz
  zcat results_filtered/eur_PTSD_Continuous_m0_trauma_pcs_alldata_may8_2020.gz1.tbl.munge.gz.sumstats.gz | awk '{print $1,$2,$3}' >  results_filtered/eur_PTSD_Continuous_m0_trauma_pcs_alldata_may8_2020.gz1.tbl.munge.gz.sumstats.gz.alleles #need correct alleles
  munge_sumstats.py --sumstats results_filtered/ptsd_qt_ukbb_mar23_2020_unrelated.bgen.stats.gz.premunge.gz --merge-alleles  results_filtered/eur_PTSD_Continuous_m0_trauma_pcs_alldata_may8_2020.gz1.tbl.munge.gz.sumstats.gz.alleles --p P_BOLT_LMM_INF --N 134586 --a1 ALLELE1 --a2 ALLELE0 --frq A1FREQ  --out results_filtered/ptsd_qt_ukbb_mar23_2020_unrelated.bgen.stats.gz.munge.gz #add --N-col OBS_CT for the sample size
 
 #With TS
   /home/maihofer/trauma_gwas/ldsc-master/ldsc.py \
 --rg results_filtered/eur_PTSD_Continuous_m0_trauma_pcs_alldata_may8_2020.gz1.tbl.munge.gz.sumstats.gz,results_filtered/ptsd_qt_ukbb_mar23_2020_unrelated.bgen.stats.gz.munge.gz.sumstats.gz \
 --ref-ld-chr ldsc-master/ldsc_data/eur_w_ld_chr/ \
 --w-ld-chr  ldsc-master/ldsc_data/eur_w_ld_chr/ \
 --out results_filtered/rg_trauma_ukbb_eur_PTSD_Continuous_m0_pcs_alldata_may8_2020.tbl.munge.gz.tbl.ldsc

 #No TS
   /home/maihofer/trauma_gwas/ldsc-master/ldsc.py \
 --rg results_filtered/eur_PTSD_Continuous_m0_NOtrauma_pcs_alldata_may8_2020.gz1.tbl.munge.gz.sumstats.gz,results_filtered/ptsd_qt_ukbb_mar23_2020_unrelated.bgen.stats.gz.munge.gz.sumstats.gz \
 --ref-ld-chr ldsc-master/ldsc_data/eur_w_ld_chr/ \
 --w-ld-chr  ldsc-master/ldsc_data/eur_w_ld_chr/ \
 --out results_filtered/rg_notrauma_ukbb_eur_PTSD_Continuous_m0_pcs_alldata_may8_2020.tbl.munge.gz.tbl.ldsc
   #Note: genetic correlation is significantly less than 1 (0.51!)
   
 ##genetic correlations of my sumstats with MVP
  zcat TMVP.EUR.REX.txt.gz_f  | awk '{print $1,$2,$3,$6,$7,$8,$9,$10,$11}' > sumstats/MVP.EUR.REX.txt.gz_f2
  LC_ALL=C join -1 1 -2 1  <(awk '{print $1}' ldsc-master/ldsc_data/eur_w_ld_chr/w_hm3.snplist.sorted | LC_ALL=C sort -k1b,1 ) <(cat sumstats/MVP.EUR.REX.txt.gz_f2 | LC_ALL=C sort -k1b,1 ) | gzip > results_filtered/MVP.EUR.REX.txt.gz_f2.premunge.gz
  munge_sumstats.py --sumstats results_filtered/MVP.EUR.REX.txt.gz_f2.premunge.gz --merge-alleles  results_filtered/eur_PTSD_Continuous_m0_trauma_pcs_alldata_may8_2020.gz1.tbl.munge.gz.sumstats.gz.alleles --frq EAF --a1 EA --a2 Noncoded --out results_filtered/MVP.EUR.REX.txt.gz_f2.munge.gz #add --N-col OBS_CT for the sample size
 
  ##genetic correlations of my sumstats with MVP TOT

   zcat TotalPCL_MVP_eur.gz | awk '{if(NR==1) {$1 = "SNP"}; print }' > MVP.EUR.TOT.txt.gz_f2
  LC_ALL=C join -1 1 -2 1  <(awk '{print $1}' ldsc-master/ldsc_data/eur_w_ld_chr/w_hm3.snplist.sorted | LC_ALL=C sort -k1b,1 ) <(cat MVP.EUR.TOT.txt.gz_f2 | LC_ALL=C sort -k1b,1 ) | gzip > results_filtered/MVP.EUR.TOT.txt.gz_f2.premunge.gz
  munge_sumstats.py --sumstats results_filtered/MVP.EUR.TOT.txt.gz_f2.premunge.gz --merge-alleles  results_filtered/eur_PTSD_Continuous_m0_trauma_pcs_alldata_may8_2020.gz1.tbl.munge.gz.sumstats.gz.alleles --out results_filtered/MVP.EUR.TOT.txt.gz_f2.munge.gz #add --N-col OBS_CT for the sample size
 
 #Main sumstats
  /home/maihofer/trauma_gwas/ldsc-master/ldsc.py \
 --rg results_filtered/eur_PTSD_Continuous_m0_pcs_alldata_may8_2020.gz1.tbl.munge.gz.sumstats.gz,results_filtered/MVP.EUR.REX.txt.gz_f2.munge.gz.sumstats.gz \
 --ref-ld-chr ldsc-master/ldsc_data/eur_w_ld_chr/ \
 --w-ld-chr  ldsc-master/ldsc_data/eur_w_ld_chr/ \
 --out results_filtered/rg_eur_PTSD_Continuous_m0_pcs_alldata_may8_2020_mvptot.ldsc

  #ts
  /home/maihofer/trauma_gwas/ldsc-master/ldsc.py \
 --rg results_filtered/eur_PTSD_Continuous_m0_trauma_pcs_alldata_may8_2020.gz1.tbl.munge.gz.sumstats.gz,results_filtered/MVP.EUR.REX.txt.gz_f2.munge.gz.sumstats.gz \
 --ref-ld-chr ldsc-master/ldsc_data/eur_w_ld_chr/ \
 --w-ld-chr  ldsc-master/ldsc_data/eur_w_ld_chr/ \
 --out results_filtered/rg_eur_PTSD_Continuous_m0_pcs_trauma_may8_2020_mvp.ldsc

 #no ts
  /home/maihofer/trauma_gwas/ldsc-master/ldsc.py \
 --rg results_filtered/eur_PTSD_Continuous_m0_NOtrauma_pcs_alldata_may8_2020.gz1.tbl.munge.gz.sumstats.gz,results_filtered/MVP.EUR.REX.txt.gz_f2.munge.gz.sumstats.gz \
 --ref-ld-chr ldsc-master/ldsc_data/eur_w_ld_chr/ \
 --w-ld-chr  ldsc-master/ldsc_data/eur_w_ld_chr/ \
 --out results_filtered/rg_eur_PTSD_Continuous_m0_pcs_notrauma_may8_2020_mvp.ldsc
 
#UKBB and rex
  /home/maihofer/trauma_gwas/ldsc-master/ldsc.py \
 --rg results_filtered/ptsd_qt_ukbb_mar23_2020_unrelated.bgen.stats.gz.munge.gz.sumstats.gz,results_filtered/MVP.EUR.REX.txt.gz_f2.munge.gz.sumstats.gz \
 --ref-ld-chr ldsc-master/ldsc_data/eur_w_ld_chr/ \
 --w-ld-chr  ldsc-master/ldsc_data/eur_w_ld_chr/ \
 --out results_filtered/rg_eur_ukbb_mvp.ldsc


##Examine all data without untrauma people

#Examine heritability in no trauma + ukbb sample
 
 
cat metal_results/eur_PTSD_Continuous_m0_NOtraumaplusukb_pcs_alldata_may8_2020_*.gz1.tbl | awk '{if (NR == 1 || ($3 != "MarkerName" && $10 > 15000 )) print}' > metal_results/eur_PTSD_Continuous_m0_NOtraumaplusukb_pcs_alldata_may8_2020.gz1.tbl
 LC_ALL=C join -1 1 -2 3  <(awk '{print $1}' ldsc-master/ldsc_data/eur_w_ld_chr/w_hm3.snplist.sorted | LC_ALL=C sort -k1b,1 ) <(cat metal_results/eur_PTSD_Continuous_m0_NOtraumaplusukb_pcs_alldata_may8_2020.gz1.tbl | awk '{if (NR == 1) $3="SNP"; print}'   | LC_ALL=C sort -k3b,3 ) | gzip > results_filtered/eur_PTSD_Continuous_m0_NOtraumaplusukb_pcs_alldata_may8_2020.gz1.tbl.premunge.gz 
 munge_sumstats.py --sumstats results_filtered/eur_PTSD_Continuous_m0_NOtraumaplusukb_pcs_alldata_may8_2020.gz1.tbl.premunge.gz  --out results_filtered/eur_PTSD_Continuous_m0_NOtraumaplusukb_pcs_alldata_may8_2020.gz1.tbl.munge.gz #add --N-col OBS_CT for the sample size
 
   /home/maihofer/trauma_gwas/ldsc-master/ldsc.py \
 --h2 results_filtered/eur_PTSD_Continuous_m0_NOtraumaplusukb_pcs_alldata_may8_2020.gz1.tbl.munge.gz.sumstats.gz \
 --ref-ld-chr ldsc-master/ldsc_data/eur_w_ld_chr/ \
 --w-ld-chr  ldsc-master/ldsc_data/eur_w_ld_chr/ \
 --out results_filtered/eur_PTSD_Continuous_m0_NOtraumaplusukb_pcs_alldata_may8_2020.gz1.tbl.munge.gz.sumstats.gz.ldsc


   /home/maihofer/trauma_gwas/ldsc-master/ldsc.py \
 --rg results_filtered/eur_PTSD_Continuous_m0_NOtraumaplusukb_pcs_alldata_may8_2020.gz1.tbl.munge.gz.sumstats.gz,results_filtered/MVP.EUR.REX.txt.gz_f2.munge.gz.sumstats.gz \
 --ref-ld-chr ldsc-master/ldsc_data/eur_w_ld_chr/ \
 --w-ld-chr  ldsc-master/ldsc_data/eur_w_ld_chr/ \
 --out results_filtered/rg_eur_notraumaplusukbb_mvp.ldsc

  
#This is way better served for a forest plot

grep -w -m1 rs72657988  metal_results/eur_PTSD_Continuous_m0_NOtraumaplusukb_pcs_alldata_may8_2020.gz1.tbl
grep -w -m1 rs146918648  metal_results/eur_PTSD_Continuous_m0_NOtraumaplusukb_pcs_alldata_may8_2020.gz1.tbl
grep -w -m1 rs2721802  metal_results/eur_PTSD_Continuous_m0_NOtraumaplusukb_pcs_alldata_may8_2020.gz1.tbl
grep -w -m1 rs71149745 r metal_results/eur_PTSD_Continuous_m0_NOtraumaplusukb_pcs_alldata_may8_2020.gz1.tbl
grep -w -m1 rs10821154 metal_results/eur_PTSD_Continuous_m0_NOtraumaplusukb_pcs_alldata_may8_2020.gz1.tbl

grep -w -m1 rs72657988  metal_results/eur_PTSD_Continuous_m0_NOtrauma_pcs_alldata_may8_2020.gz1.tbl
grep -w -m1 rs146918648  metal_results/eur_PTSD_Continuous_m0_NOtrauma_pcs_alldata_may8_2020.gz1.tbl
grep -w -m1 rs2721802  metal_results/eur_PTSD_Continuous_m0_NOtrauma_pcs_alldata_may8_2020.gz1.tbl
grep -w -m1 rs71149745 r metal_results/eur_PTSD_Continuous_m0_NOtrauma_pcs_alldata_may8_2020.gz1.tbl
grep -w -m1 rs10821154 metal_results/eur_PTSD_Continuous_m0_NOtrauma_pcs_alldata_may8_2020.gz1.tbl

grep -w -m1 rs72657988  metal_results/eur_PTSD_Continuous_m0_trauma_pcs_alldata_may8_2020.gz1.tbl
grep -w -m1 rs146918648  metal_results/eur_PTSD_Continuous_m0_trauma_pcs_alldata_may8_2020.gz1.tbl
grep -w -m1 rs2721802  metal_results/eur_PTSD_Continuous_m0_trauma_pcs_alldata_may8_2020.gz1.tbl
grep -w -m1 rs71149745 r metal_results/eur_PTSD_Continuous_m0_trauma_pcs_alldata_may8_2020.gz1.tbl
grep -w -m1 rs10821154 metal_results/eur_PTSD_Continuous_m0_trauma_pcs_alldata_may8_2020.gz1.tbl

##Examine hits in trauma covariate data
#Note that neff 176275, slightly less in this data
cat metal_results/eur_PTSD_Continuous_m0_pcstrauma_alldata_may8_2020_*.gz1.tbl | awk '{if (NR == 1 || ($3 != "MarkerName" && $10 > 15000 )) print}' > metal_results/eur_PTSD_Continuous_m0_pcstrauma_alldata_may8_2020.gz1.tbl
cat metal_results/eur_PTSD_Continuous_m0_pcstrauma_alldata_may8_2020_*.gz1.tbl |  awk '{ if (NR ==1 || ($6 >= 0.01 && $6 <= 0.99 && $3 != "MarkerName" && $10 > 150000)) print $1,$2,$3,$4,$5,$6,$10,$11,$12}'   | grep -v : | sort -g -k 9 | gzip  > results_filtered/eur_PTSD_Continuous_m0_pcstrauma_alldata_may8_2020.fuma.gz

zgrep -w -m1 rs72657988 results_filtered/eur_PTSD_Continuous_m0_pcstrauma_alldata_may8_2020.fuma.gz
zgrep -w -m1 rs146918648 results_filtered/eur_PTSD_Continuous_m0_pcstrauma_alldata_may8_2020.fuma.gz
zgrep -w -m1 rs2721802 results_filtered/eur_PTSD_Continuous_m0_pcstrauma_alldata_may8_2020.fuma.gz
zgrep -w -m1 rs71149745 results_filtered/eur_PTSD_Continuous_m0_pcstrauma_alldata_may8_2020.fuma.gz
zgrep -w -m1 rs10821154 results_filtered/eur_PTSD_Continuous_m0_pcstrauma_alldata_may8_2020.fuma.gz

##Correlation between trauma covariate data and MVP REX

 LC_ALL=C join -1 1 -2 3  <(awk '{print $1}' ldsc-master/ldsc_data/eur_w_ld_chr/w_hm3.snplist.sorted | LC_ALL=C sort -k1b,1 ) <(cat metal_results/eur_PTSD_Continuous_m0_pcstrauma_alldata_may8_2020.gz1.tbl | awk '{if (NR == 1) $3="SNP"; print}'   | LC_ALL=C sort -k3b,3 ) | gzip > results_filtered/eur_PTSD_Continuous_m0_pcstrauma_alldata_may8_2020.gz1.tbl.premunge.gz 
 munge_sumstats.py --sumstats results_filtered/eur_PTSD_Continuous_m0_pcstrauma_alldata_may8_2020.gz1.tbl.premunge.gz  --out results_filtered/eur_PTSD_Continuous_m0_pcstrauma_alldata_may8_2020.gz1.tbl.munge.gz #add --N-col OBS_CT for the sample size
 
   /home/maihofer/trauma_gwas/ldsc-master/ldsc.py \
 --h2 results_filtered/eur_PTSD_Continuous_m0_pcstrauma_alldata_may8_2020.gz1.tbl.munge.gz.sumstats.gz \
 --ref-ld-chr ldsc-master/ldsc_data/eur_w_ld_chr/ \
 --w-ld-chr  ldsc-master/ldsc_data/eur_w_ld_chr/ \
 --out results_filtered/eur_PTSD_Continuous_m0_pcstrauma_alldata_may8_2020.ldsc



  /home/maihofer/trauma_gwas/ldsc-master/ldsc.py \
 --rg results_filtered/eur_PTSD_Continuous_m0_pcstrauma_alldata_may8_2020.gz1.tbl.munge.gz.sumstats.gz,results_filtered/MVP.EUR.REX.txt.gz_f2.munge.gz.sumstats.gz \
 --ref-ld-chr ldsc-master/ldsc_data/eur_w_ld_chr/ \
 --w-ld-chr  ldsc-master/ldsc_data/eur_w_ld_chr/ \
 --out results_filtered/rg_eur_PTSD_Continuous_m0_pcstrauma_alldata_may8_2020_mvp.ldsc


##Replications in MVP

#Main analysis 
#results_filtered/eur_PTSD_Continuous_m0_pcs_alldata_may8_2020.fuma.gz
rs72657988
rs146918648
rs2721802
rs71149745
rs10821154

zgrep -w -m1 rs72657988 results_filtered/eur_PTSD_Continuous_m0_pcs_alldata_may8_2020.fuma.gz
zgrep -w -m1 rs146918648 results_filtered/eur_PTSD_Continuous_m0_pcs_alldata_may8_2020.fuma.gz
zgrep -w -m1 rs2721802 results_filtered/eur_PTSD_Continuous_m0_pcs_alldata_may8_2020.fuma.gz
zgrep -w -m1 rs71149745 results_filtered/eur_PTSD_Continuous_m0_pcs_alldata_may8_2020.fuma.gz
zgrep -w -m1 rs10821154 results_filtered/eur_PTSD_Continuous_m0_pcs_alldata_may8_2020.fuma.gz

#Variant 1
 grep -w -m1 rs7265798 sumstats/MVP.EUR.REX.txt.gz_f2

 #Look within 20kb of top snp
 awk '{if (NR== 1 || ($2 == 1 && $3 >= 35668541 && $3 <= 35718541 )) print}' sumstats/MVP.EUR.REX.txt.gz_f2
 #Check LD with rs673604 this is the closests variant in mvp

#Variant 2 
 grep -w -m1 rs146918648 sumstats/MVP.EUR.REX.txt.gz_f2
 
#Variant 3 
 grep -w -m1 rs2721802 sumstats/MVP.EUR.REX.txt.gz_f2

#Variant 4 
 grep -w -m1 rs71149745 sumstats/MVP.EUR.REX.txt.gz_f2
 awk '{if (NR== 1 || ($2 == 7 && $3 >= 114036495 && $3 <= 114076495 )) print}' sumstats/MVP.EUR.REX.txt.gz_f2
#rs10268637 7 114074257 T 0.458809 146660 0.0522476 0.00141736 C
 check LD with this variant 
 
#Variant 5
 grep -w -m1 rs10821154 sumstats/MVP.EUR.REX.txt.gz_f2
 awk '{if (NR== 1 || ($2 == 9 && $3 >= 96282506 && $3 <= 96322506 )) print}' sumstats/MVP.EUR.REX.txt.gz_f2
 #rs12380167 9 96301570 T 0.347732 146660 -0.0550659 0.00193666 C

#check LD

##Compare these hits in trauma studies vs not
zgrep -w -m1 rs72657988 results_filtered/eur_PTSD_Continuous_m0_trauma_pcs_alldata_may8_2020.fuma.gz
zgrep -w -m1 rs146918648 results_filtered/eur_PTSD_Continuous_m0_trauma_pcs_alldata_may8_2020.fuma.gz
zgrep -w -m1 rs2721802 results_filtered/eur_PTSD_Continuous_m0_trauma_pcs_alldata_may8_2020.fuma.gz
zgrep -w -m1 rs71149745 results_filtered/eur_PTSD_Continuous_m0_trauma_pcs_alldata_may8_2020.fuma.gz
zgrep -w -m1 rs10821154 results_filtered/eur_PTSD_Continuous_m0_trauma_pcs_alldata_may8_2020.fuma.gz



##Examine trauma covariate gwas

 LC_ALL=C join -1 1 -2 1  <(awk '{print $1}' ldsc-master/ldsc_data/eur_w_ld_chr/w_hm3.snplist.sorted | LC_ALL=C sort -k1b,1 ) <(zcat sumstats/lt_qt_ukbb_mar23_2020_unrelated.bgen.stats.gz   | LC_ALL=C sort -k1b,1 ) | gzip > results_filtered/lt_qt_ukbb_mar23_2020_unrelated.bgen.stats.gz.premunge.gz
 munge_sumstats.py --sumstats results_filtered/lt_qt_ukbb_mar23_2020_unrelated.bgen.stats.gz.premunge.gz --p P_BOLT_LMM_INF --N 134586 --a1 ALLELE1 --a2 ALLELE0 --frq A1FREQ  --out results_filtered/lt_qt_ukbb_mar23_2020_unrelated.bgen.stats.gz.munge.gz #add --N-col OBS_CT for the sample size
 
   /home/maihofer/trauma_gwas/ldsc-master/ldsc.py \
 --h2 results_filtered/lt_qt_ukbb_mar23_2020_unrelated.bgen.stats.gz.munge.gz.sumstats.gz \
 --ref-ld-chr ldsc-master/ldsc_data/eur_w_ld_chr/ \
 --w-ld-chr  ldsc-master/ldsc_data/eur_w_ld_chr/ \
 --out results_filtered/lt_qt_ukbb_mar23_2020_unrelated.bgen.ldsc


|


