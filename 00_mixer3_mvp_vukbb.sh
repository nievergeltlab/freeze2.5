#!/bin/bash
 module load 2019
  module load Python/3.7.5-foss-2018b
# module load Boost.Python/1.67.0-foss-2018b-Python-3.6.6
 cd  /home/maihofer/trauma_gwas

#MVP v freeze 2
python3 /home/maihofer/trauma_gwas/mixer/precimed/mixer.py fit2 \
      --trait1-file results_filtered/eur_PTSD_Continuous_m0_pcs_alldata_may8_2020.fuma.gz.mixer2.gz \
      --trait2-file results_filtered/MVP.EUR.TOT.txt.gz_f3.mixer2.gz \
      --trait1-params-file results_filtered/eur_PTSD_Continuous_m0_pcs_alldata_may8_2020.fuma.gz.mixer_results.json \
      --trait2-params-file results_filtered/MVP.EUR.TOT.txt.gz_f3.mixer_results.json \
      --out results_filtered/mvp_TOTeur_PTSD_Continuous_m0_pcs_alldata_may8_2020.fuma.gz.mixer_results \
      --extract /home/maihofer/trauma_gwas/mixer/w_hm3.justrs \
      --bim-file /home/maihofer/trauma_gwas/mixer/1000G_EUR_Phase3_plink/1000G.EUR.QC.@.bim \
      --ld-file /home/maihofer/trauma_gwas/mixer/1000G_EUR_Phase3_plink/1000G.EUR.QC.@.run4.ld \
      --lib  /home/maihofer/trauma_gwas/mixer/src/build/lib/libbgmg.so \
      
      
      python3 /home/maihofer/trauma_gwas/mixer/precimed/mixer.py  test2 \
    --trait1-file results_filtered/eur_PTSD_Continuous_m0_pcs_alldata_may8_2020.fuma.gz.mixer2.gz \
      --trait2-file results_filtered/MVP.EUR.TOT.txt.gz_f3.mixer2.gz \
      --load-params-file results_filtered/mvp_TOTeur_PTSD_Continuous_m0_pcs_alldata_may8_2020.fuma.gz.mixer_results.json \
      --out results_filtered/mvp_TOTeur_PTSD_Continuous_m0_pcs_alldata_may8_2020.fuma.gz.mixer_results.test \
      --bim-file /home/maihofer/trauma_gwas/mixer/1000G_EUR_Phase3_plink/1000G.EUR.QC.@.bim \
      --ld-file /home/maihofer/trauma_gwas/mixer/1000G_EUR_Phase3_plink/1000G.EUR.QC.@.run4.ld \
      --lib  /home/maihofer/trauma_gwas/mixer/src/build/lib/libbgmg.so \
      
      

python3 /home/maihofer/trauma_gwas/mixer/precimed/mixer_figures.py two --json results_filtered/mvp_TOTeur_PTSD_Continuous_m0_pcs_alldata_may8_2020.fuma.gz.mixer_results.test.json --out results_filtered/mvp_TOTeur_PTSD_Continuous_m0_pcs_alldata_may8_2020.fuma.gz.mixer_results.test.plots

python3 /home/maihofer/trauma_gwas/mixer/precimed/mixer_figures.py two --json-fit  results_filtered/mvp_TOTeur_PTSD_Continuous_m0_pcs_alldata_may8_2020.fuma.gz.mixer_results.json --json-test results_filtered/mvp_TOTeur_PTSD_Continuous_m0_pcs_alldata_may8_2020.fuma.gz.mixer_results.test.json \
  --trait1-file results_filtered/eur_PTSD_Continuous_m0_pcs_alldata_may8_2020.fuma.gz.mixer2.gz \
  --trait2-file results_filtered/MVP.EUR.TOT.txt.gz_f3.mixer2.gz \
  --out results_filtered/mvp_TOTeur_PTSD_Continuous_m0_pcs_alldata_may8_2020.fuma.gz.mixer_results.fit_test.json
  
  
#MVP v UKBB LT
# python3 /home/maihofer/trauma_gwas/mixer/precimed/mixer.py fit2 \
      # --trait1-file results_filtered/lt_qt_ukbb_mar23_2020_unrelated.bgen.stats.gz.mixer2.gz \
      # --trait2-file results_filtered/MVP.EUR.TOT.txt.gz_f3.mixer2.gz \
      # --trait1-params-file results_filtered/lt_qt_ukbb_mar23_2020_unrelated.bgen.stats.gz.mixer_results.json \
      # --trait2-params-file results_filtered/MVP.EUR.TOT.txt.gz_f3.mixer_results.json \
      # --out results_filtered/mvp_TOTlt_qt_ukbb_mar23_2020_unrelated.bgen.stats.gz.mixer_results \
      # --extract /home/maihofer/trauma_gwas/mixer/w_hm3.justrs \
      # --bim-file /home/maihofer/trauma_gwas/mixer/1000G_EUR_Phase3_plink/1000G.EUR.QC.@.bim \
      # --ld-file /home/maihofer/trauma_gwas/mixer/1000G_EUR_Phase3_plink/1000G.EUR.QC.@.run4.ld \
      # --lib  /home/maihofer/trauma_gwas/mixer/src/build/lib/libbgmg.so \
      
      
      # python3 /home/maihofer/trauma_gwas/mixer/precimed/mixer.py  test2 \
    # --trait1-file results_filtered/lt_qt_ukbb_mar23_2020_unrelated.bgen.stats.gz.mixer2.gz \
      # --trait2-file results_filtered/MVP.EUR.TOT.txt.gz_f3.mixer2.gz \
      # --load-params-file results_filtered/mvp_TOTlt_qt_ukbb_mar23_2020_unrelated.bgen.stats.gz.mixer_results.json \
      # --out results_filtered/mvp_TOTlt_qt_ukbb_mar23_2020_unrelated.bgen.stats.gz.mixer_results.test \
      # --bim-file /home/maihofer/trauma_gwas/mixer/1000G_EUR_Phase3_plink/1000G.EUR.QC.@.bim \
      # --ld-file /home/maihofer/trauma_gwas/mixer/1000G_EUR_Phase3_plink/1000G.EUR.QC.@.run4.ld \
      # --lib  /home/maihofer/trauma_gwas/mixer/src/build/lib/libbgmg.so \
      
      

# python3 /home/maihofer/trauma_gwas/mixer/precimed/mixer_figures.py two --json results_filtered/mvp_TOTlt_qt_ukbb_mar23_2020_unrelated.bgen.stats.gz.mixer_results.test.json --out results_filtered/mvp_TOTlt_qt_ukbb_mar23_2020_unrelated.bgen.stats.gz.mixer_results.test.plots

# python3 /home/maihofer/trauma_gwas/mixer/precimed/mixer_figures.py two --json-fit  results_filtered/mvp_TOTlt_qt_ukbb_mar23_2020_unrelated.bgen.stats.gz.mixer_results.json --json-test results_filtered/mvp_TOTlt_qt_ukbb_mar23_2020_unrelated.bgen.stats.gz.mixer_results.test.json \
  # --trait1-file results_filtered/lt_qt_ukbb_mar23_2020_unrelated.bgen.stats.gz.mixer2.gz \
  # --trait2-file results_filtered/MVP.EUR.TOT.txt.gz_f3.mixer2.gz \
  # --out results_filtered/mvp_TOTlt_qt_ukbb_mar23_2020_unrelated.bgen.stats.gz.mixer_results.fit_test.json
  
  
  
#sbatch --time=18:05:00 --error errandout/mixer3_mvp_vukbb.e --output errandout/mixer3_mvp_vukbb.o 00_mixer3_mvp_vukbb.sh 
 