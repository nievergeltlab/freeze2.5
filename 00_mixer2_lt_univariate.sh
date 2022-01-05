#!/bin/bash
# module load 2019
#  module load Python/3.7.5-foss-2018b
# module load Boost.Python/1.67.0-foss-2018b-Python-3.6.6
 cd  /home/maihofer/trauma_gwas

#For TOT
python3 /home/maihofer/trauma_gwas/mixer/precimed/mixer.py fit1 \
      --trait1-file results_filtered/MVP.EUR.TOT.txt.gz_f3.mixer2.gz \
      --out results_filtered/MVP.EUR.TOT.txt.gz_f3.mixer_results \
      --extract /home/maihofer/trauma_gwas/mixer/w_hm3.justrs \
      --bim-file /home/maihofer/trauma_gwas/mixer/1000G_EUR_Phase3_plink/1000G.EUR.QC.@.bim \
      --ld-file /home/maihofer/trauma_gwas/mixer/1000G_EUR_Phase3_plink/1000G.EUR.QC.@.run4.ld \
      --lib  /home/maihofer/trauma_gwas/mixer/src/build/lib/libbgmg.so \


python3 /home/maihofer/trauma_gwas/mixer/precimed/mixer.py test1 \
      --trait1-file results_filtered/MVP.EUR.TOT.txt.gz_f3.mixer2.gz \
      --load-params-file results_filtered/MVP.EUR.TOT.txt.gz_f3.mixer_results.json \
      --out results_filtered/MVP.EUR.TOT.txt.gz_f3.mixer_results.test \
      --bim-file /home/maihofer/trauma_gwas/mixer/1000G_EUR_Phase3_plink/1000G.EUR.QC.@.bim \
      --ld-file /home/maihofer/trauma_gwas/mixer/1000G_EUR_Phase3_plink/1000G.EUR.QC.@.run4.ld \
      --lib  /home/maihofer/trauma_gwas/mixer/src/build/lib/libbgmg.so \

python3 /home/maihofer/trauma_gwas/mixer/precimed/mixer_figures.py one --json results_filtered/MVP.EUR.TOT.txt.gz_f3.mixer_results.test.json --out results_filtered/MVP.EUR.TOT.txt.gz_f3.mixer_results.mixer_results.test.plots



#For UKBB PTS
# python3 /home/maihofer/trauma_gwas/mixer/precimed/mixer.py fit1 \
      # --trait1-file results_filtered/ptsd_qt_ukbb_mar23_2020_unrelated.bgen.stats.gz.mixer2.gz \
      # --out results_filtered/ptsd_qt_ukbb_mar23_2020_unrelated.bgen.stats.gz.mixer_results \
      # --extract /home/maihofer/trauma_gwas/mixer/w_hm3.justrs \
      # --bim-file /home/maihofer/trauma_gwas/mixer/1000G_EUR_Phase3_plink/1000G.EUR.QC.@.bim \
      # --ld-file /home/maihofer/trauma_gwas/mixer/1000G_EUR_Phase3_plink/1000G.EUR.QC.@.run4.ld \
      # --lib  /home/maihofer/trauma_gwas/mixer/src/build/lib/libbgmg.so \


# python3 /home/maihofer/trauma_gwas/mixer/precimed/mixer.py test1 \
      # --trait1-file results_filtered/ptsd_qt_ukbb_mar23_2020_unrelated.bgen.stats.gz.mixer2.gz \
      # --load-params-file results_filtered/ptsd_qt_ukbb_mar23_2020_unrelated.bgen.stats.gz.mixer_results.json \
      # --out results_filtered/ptsd_qt_ukbb_mar23_2020_unrelated.bgen.stats.gz.mixer_results.test \
      # --bim-file /home/maihofer/trauma_gwas/mixer/1000G_EUR_Phase3_plink/1000G.EUR.QC.@.bim \
      # --ld-file /home/maihofer/trauma_gwas/mixer/1000G_EUR_Phase3_plink/1000G.EUR.QC.@.run4.ld \
      # --lib  /home/maihofer/trauma_gwas/mixer/src/build/lib/libbgmg.so \

# python3 /home/maihofer/trauma_gwas/mixer/precimed/mixer_figures.py one --json results_filtered/ptsd_qt_ukbb_mar23_2020_unrelated.bgen.stats.gz.mixer_results.test.json --out results_filtered/ptsd_qt_ukbb_mar23_2020_unrelated.bgen.stats.gz.mixer_results.test.plots



#sbatch --time=12:05:00 --error errandout/mixer2_lt_univariate.e --output errandout/mixer2_lt_univariate.o 00_mixer2_lt_univariate.sh 
 