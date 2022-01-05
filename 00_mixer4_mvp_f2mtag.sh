#!/bin/bash
 module load 2019
  module load Python/3.7.5-foss-2019b
# module load Boost.Python/1.67.0-foss-2018b-Python-3.6.6
module load Tk/8.6.8-GCCcore-8.3.0 #they updated 

 cd  /home/maihofer/trauma_gwas

#MVP v freeze 2 MTAG
python3 /home/maihofer/trauma_gwas/mixer/precimed/mixer.py fit2 \
      --trait1-file results_filtered/eur_PTSD_Continuous_m0_pcs_alldata_may8_2020_ukbb_trauma_trait_1.txt.gz.mixer2.gz  \
      --trait2-file results_filtered/MVP.EUR.TOT.txt.gz_f3.mixer2.gz \
      --trait1-params-file results_filtered/eur_PTSD_Continuous_m0_pcs_alldata_may8_2020_ukbb_trauma_trait_1.txt.gz.mixer_results.test.json \
      --trait2-params-file results_filtered/MVP.EUR.TOT.txt.gz_f3.mixer_results.json \
      --out results_filtered/mvp_TOTeur_PTSD_Continuous_m0_pcs_alldata_may8_2020_ukbb_trauma_trait_1.txt.mixer_results \
      --extract /home/maihofer/trauma_gwas/mixer/w_hm3.justrs \
      --bim-file /home/maihofer/trauma_gwas/mixer/1000G_EUR_Phase3_plink/1000G.EUR.QC.@.bim \
      --ld-file /home/maihofer/trauma_gwas/mixer/1000G_EUR_Phase3_plink/1000G.EUR.QC.@.run4.ld \
      --lib  /home/maihofer/trauma_gwas/mixer/src/build/lib/libbgmg.so \
      
      
      python3 /home/maihofer/trauma_gwas/mixer/precimed/mixer.py  test2 \
      --trait1-file results_filtered/eur_PTSD_Continuous_m0_pcs_alldata_may8_2020_ukbb_trauma_trait_1.txt.gz.mixer2.gz \
      --trait2-file results_filtered/MVP.EUR.TOT.txt.gz_f3.mixer2.gz \
      --load-params-file results_filtered/mvp_TOTeur_PTSD_Continuous_m0_pcs_alldata_may8_2020_ukbb_trauma_trait_1.txt.mixer_results.json \
      --out results_filtered/mvp_TOTeur_PTSD_Continuous_m0_pcs_alldata_may8_2020_ukbb_trauma_trait_1.txt.gz.mixer_results.test \
      --bim-file /home/maihofer/trauma_gwas/mixer/1000G_EUR_Phase3_plink/1000G.EUR.QC.@.bim \
      --ld-file /home/maihofer/trauma_gwas/mixer/1000G_EUR_Phase3_plink/1000G.EUR.QC.@.run4.ld \
      --lib  /home/maihofer/trauma_gwas/mixer/src/build/lib/libbgmg.so \
      
      

python3 /home/maihofer/trauma_gwas/mixer/precimed/mixer_figures.py two --json results_filtered/mvp_TOTeur_PTSD_Continuous_m0_pcs_alldata_may8_2020_ukbb_trauma_trait_1.txt.gz.mixer_results.test.json --out results_filtered/mvp_TOTeur_PTSD_Continuous_m0_pcs_alldata_may8_2020_ukbb_trauma_trait_1.txt.gz.test.plots

python3 /home/maihofer/trauma_gwas/mixer/precimed/mixer_figures.py two --json-fit  results_filtered/mvp_TOTeur_PTSD_Continuous_m0_pcs_alldata_may8_2020_ukbb_trauma_trait_1.txt.mixer_results.json --json-test results_filtered/mvp_TOTeur_PTSD_Continuous_m0_pcs_alldata_may8_2020_ukbb_trauma_trait_1.txt.gz.mixer_results.test.json \
      --trait1-file results_filtered/eur_PTSD_Continuous_m0_pcs_alldata_may8_2020_ukbb_trauma_trait_1.txt.gz.mixer2.gz \
      --trait2-file results_filtered/MVP.EUR.TOT.txt.gz_f3.mixer2.gz \
  --out results_filtered/mvp_TOTeur_PTSD_Continuous_m0_pcs_alldata_may8_2020_ukbb_trauma_trait_1.txt.mixer_results.fit_test.json
  
  #Bivarate plot based on fit
  python /home/maihofer/trauma_gwas/mixer/precimed/mixer_figures.py combine --json "$studycomb".rep@.json --out      "$studycomb".rep.fit         
  python /home/maihofer/trauma_gwas/mixer/precimed/mixer_figures.py two --json "$studycomb".rep.fit.json  --out "$studycomb".rep.combine  --statistic mean std
 
# Bivariate plot based on total    
  python /home/maihofer/trauma_gwas/mixer/precimed/mixer_figures.py combine --json "$studycomb".test.rep@.json --out "$studycomb".test.rep.fit
      
 # python /home/maihofer/trauma_gwas/mixer/precimed/mixer_figures.py two --json "$studycomb".test.rep.fit.json  --out "$studycomb".test.rep.combine  --statistic mean std
     


  
#sbatch --time=18:05:00 --error errandout/mixer4_mvp_f2mtag.e --output errandout/mixer4_mvp_f2mtag.o 00_mixer4_mvp_f2mtag.sh 
 