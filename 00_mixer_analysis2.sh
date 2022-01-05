#!/bin/bash

 cd  /home/maihofer/trauma_gwas

#Lifetime trauma GWAS

#study=results_filtered/lt_qt_ukbb_mar23_2020_unrelated.bgen.stats.gz

# #Limited SNP subset analysis
# python3 /home/maihofer/trauma_gwas/mixer/precimed/mixer.py fit1 \
      # --trait1-file "$study".mixer2.gz \
      # --out "$study".rep${SLURM_ARRAY_TASK_ID} \
      # --extract /home/maihofer/trauma_gwas/mixer/1000G_EUR_Phase3_plink/1000G.EUR.QC.prune_maf0p05_rand2M_r2p8.rep${SLURM_ARRAY_TASK_ID}.snps \
      # --bim-file /home/maihofer/trauma_gwas/mixer/1000G_EUR_Phase3_plink/1000G.EUR.QC.@.bim \
      # --ld-file /home/maihofer/trauma_gwas/mixer/1000G_EUR_Phase3_plink/1000G.EUR.QC.@.run4.ld \
      # --lib  /home/maihofer/trauma_gwas/mixer/src/build/lib/libbgmg.so \

##Full SNp analysis
# python3 /home/maihofer/trauma_gwas/mixer/precimed/mixer.py test1 \
      # --trait1-file "$study".mixer2.gz \
      # --load-params-file "$study".rep${SLURM_ARRAY_TASK_ID}.json \
      # --out "$study".mixer_results.test.rep${SLURM_ARRAY_TASK_ID} \
      # --bim-file /home/maihofer/trauma_gwas/mixer/1000G_EUR_Phase3_plink/1000G.EUR.QC.@.bim \
      # --ld-file /home/maihofer/trauma_gwas/mixer/1000G_EUR_Phase3_plink/1000G.EUR.QC.@.run4.ld \
      # --lib  /home/maihofer/trauma_gwas/mixer/src/build/lib/libbgmg.so \


#generate plots using just the subset snps
# python3 /home/maihofer/trauma_gwas/mixer/precimed/mixer_figures.py combine --json "$study".rep@.json --out "$study".mixer_results.fit
# python3 /home/maihofer/trauma_gwas/mixer/precimed/mixer_figures.py one --json "$study".mixer_results.fit.json --out "$study".mixer_results.fit.plots --statistic mean std

#Generate plots based on whole model
#python3 /home/maihofer/trauma_gwas/mixer/precimed/mixer_figures.py combine --json "$study".mixer_results.test.rep@.json --out "$study".mixer_results.fitB
#python3 /home/maihofer/trauma_gwas/mixer/precimed/mixer_figures.py one --json "$study".mixer_results.fitB.json --out "$study".mixer_results2.test.plots --statistic mean std


#sbatch --array=1-20 --time=5:05:00 --error errandout/mixer_13_%a.e --output errandout/mixer_13_%a.o 00_mixer_analysis2.sh --export=ALL,study="$study"


#Bivariate analyses

#MVP v freeze 2
study1=results_filtered/eur_PTSD_Continuous_m0_pcs_alldata_may8_2020.fuma.gz
study2=results_filtered/lt_qt_ukbb_mar23_2020_unrelated.bgen.stats.gz
studycomb=results_filtered/eur_PTSD_Continuous_m0_pcs_alldata_may8_2020.fuma.gz_ukbbLT
# python3 /home/maihofer/trauma_gwas/mixer/precimed/mixer.py fit2 \
      # --trait1-file "$study1".mixer2.gz \
      # --trait2-file "$study2".mixer2.gz \
      # --trait1-params-file "$study1".rep${SLURM_ARRAY_TASK_ID}.json \
      # --trait2-params-file "$study2".rep${SLURM_ARRAY_TASK_ID}.json \
      # --out "$studycomb".rep${SLURM_ARRAY_TASK_ID} \
      # --extract /home/maihofer/trauma_gwas/mixer/1000G_EUR_Phase3_plink/1000G.EUR.QC.prune_maf0p05_rand2M_r2p8.rep${SLURM_ARRAY_TASK_ID}.snps \
      # --bim-file /home/maihofer/trauma_gwas/mixer/1000G_EUR_Phase3_plink/1000G.EUR.QC.@.bim \
      # --ld-file /home/maihofer/trauma_gwas/mixer/1000G_EUR_Phase3_plink/1000G.EUR.QC.@.run4.ld \
      # --lib  /home/maihofer/trauma_gwas/mixer/src/build/lib/libbgmg.so \
      
#BGMG_SHARED_LIBRARY=/home/maihofer/trauma_gwas/mixer/src/build/lib/libbgmg.so 
python3 /home/maihofer/trauma_gwas/mixer/precimed/mixer.py  test2 \
      --trait1-file "$study1".mixer2.gz \
      --trait2-file "$study2".mixer2.gz \
      --load-params-file "$studycomb".rep${SLURM_ARRAY_TASK_ID}.json \
      --out "$studycomb".test.rep${SLURM_ARRAY_TASK_ID} \
      --bim-file /home/maihofer/trauma_gwas/mixer/1000G_EUR_Phase3_plink/1000G.EUR.QC.@.bim \
      --ld-file /home/maihofer/trauma_gwas/mixer/1000G_EUR_Phase3_plink/1000G.EUR.QC.@.run4.ld \
      --lib  /home/maihofer/trauma_gwas/mixer/src/build/lib/libbgmg.so 
      
      
     python /home/maihofer/trauma_gwas/mixer/precimed/mixer_figures.py combine --json "$studycomb".rep@.json --out      "$studycomb".rep.fit
     python /home/maihofer/trauma_gwas/mixer/precimed/mixer_figures.py combine --json "$studycomb".test.rep@.json --out "$studycomb".test.rep.fit
      
     python /home/maihofer/trauma_gwas/mixer/precimed/mixer_figures.py two --json-fit "$studycomb".rep.fit.json  --json-test "$studycomb".test.rep.fit.json --out "$studycomb".rep.fit_combine  --statistic mean std
     python /home/maihofer/trauma_gwas/mixer/precimed/mixer_figures.py two --json "$studycomb".rep.fit.json  --out "$studycomb".rep.fit1_combine  --statistic mean std
     

# python3 /home/maihofer/trauma_gwas/mixer/precimed/mixer_figures.py two --json results_filtered/mvp_TOTeur_PTSD_Continuous_m0_pcs_alldata_may8_2020.fuma.gz.mixer_results.test.json --out results_filtered/mvp_TOTeur_PTSD_Continuous_m0_pcs_alldata_may8_2020.fuma.gz.mixer_results.test.plots

# python3 /home/maihofer/trauma_gwas/mixer/precimed/mixer_figures.py two --json-fit  results_filtered/mvp_TOTeur_PTSD_Continuous_m0_pcs_alldata_may8_2020.fuma.gz.mixer_results.json --json-test results_filtered/mvp_TOTeur_PTSD_Continuous_m0_pcs_alldata_may8_2020.fuma.gz.mixer_results.test.json \
  # --trait1-file "$study1".mixer2.gz \
  # --trait2-file "$study2".mixer2.gz \
  # --out results_filtered/mvp_TOTeur_PTSD_Continuous_m0_pcs_alldata_may8_2020.fuma.gz.mixer_results.fit_test.json
  
 # sbatch --array=1-20 --time=10:05:00 --error errandout/mixer_13_biv%a.e --output errandout/mixer_13_biv%a.o 00_mixer_analysis2.sh --export=ALL # ,study="$study"



#Note: Have observed that first round 


 
