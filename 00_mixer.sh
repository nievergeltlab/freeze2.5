#!/bin/bash

# #Compile mixer
# module load 2019
# module load Boost.Python/1.67.0-foss-2018b-Python-3.6.6  CMake/3.12.1-GCCcore-7.3.0

# git clone --recurse-submodules -j8 https://github.com/precimed/mixer.git
# mkdir mixer/src/build && cd mixer/src/build
# cmake .. && make bgmg -j16   

# #Reference data
# wget https://data.broadinstitute.org/alkesgroup/LDSCORE/1000G_Phase3_plinkfiles.tgz
# wget https://data.broadinstitute.org/alkesgroup/LDSCORE/w_hm3.snplist.bz2
# tar -xzvf 1000G_Phase3_plinkfiles.tgz
# bzip2 -d w_hm3.snplist.bz2
cd  /home/maihofer/trauma_gwas
#Compute LD info
 #module load 2019
 #module load Boost.Python/1.67.0-foss-2018b-Python-3.6.6

 # pip  install numdifftools --user
 # pip install matplotlib --user
 # pip install matplotlib_venn --user
 # pip install numpy --upgrade --user 
 
 # pip install scipy --upgrade --user 

# for chr in {1..22}
# do
# python3 /home/maihofer/trauma_gwas/mixer//precimed/mixer.py ld \
   # --lib /home/maihofer/trauma_gwas/mixer//src/build/lib/libbgmg.so \
   # --bfile /home/maihofer/trauma_gwas/mixer//1000G_EUR_Phase3_plink/1000G.EUR.QC."$chr" \
   # --out /home/maihofer/trauma_gwas/mixer//1000G_EUR_Phase3_plink/1000G.EUR.QC."$chr".run4.ld \
   # --r2min 0.05 --ldscore-r2min 0.05 --ld-window-kb 30000
# done    

#Get just teh snp lists
 #cut -f1 /home/maihofer/trauma_gwas/mixer/w_hm3.snplist | tail -n +2 > /home/maihofer/trauma_gwas/mixer/w_hm3.justrs
 
 
#Get the python conversion tool for sumstats
#git clone https://github.com/precimed/python_convert

#Convert sumstats

# #Freeze 2 basic sumstats
# python python_convert/sumstats.py csv --sumstats results_filtered/eur_PTSD_Continuous_m0_pcs_alldata_may8_2020.fuma.gz --auto --frq Freq1  --head 10 --out results_filtered/eur_PTSD_Continuous_m0_pcs_alldata_may8_2020.fuma.gz.mixer1
# python python_convert/sumstats.py qc --sumstats results_filtered/eur_PTSD_Continuous_m0_pcs_alldata_may8_2020.fuma.gz.mixer1  --exclude-ranges 6:26000000-34000000 --max-or 1e37 --max-or 1e37  --out results_filtered/eur_PTSD_Continuous_m0_pcs_alldata_may8_2020.fuma.gz.mixer2
# gzip results_filtered/eur_PTSD_Continuous_m0_pcs_alldata_may8_2020.fuma.gz.mixer2

# #MVP REXsumstats
# awk '{if (NR == 1) {$4 ="A1" ; $9 = "A2"}  ; print}' sumstats/MVP.EUR.REX.txt.gz_f2 > sumstats/MVP.EUR.REX.txt.gz_f3
# python python_convert/sumstats.py csv --sumstats sumstats/MVP.EUR.REX.txt.gz_f3 --auto --head 10 --out results_filtered/MVP.EUR.REX.txt.gz_f3.mixer1
# python python_convert/sumstats.py zscore --sumstats results_filtered/MVP.EUR.REX.txt.gz_f3.mixer1 | \
# python python_convert/sumstats.py qc --exclude-ranges 6:26000000-34000000 --max-or 1e37 --max-or 1e37  --out results_filtered/MVP.EUR.REX.txt.gz_f3.mixer2
# gzip results_filtered/MVP.EUR.REX.txt.gz_f3.mixer2

#LT count UKBB
# python python_convert/sumstats.py csv --sumstats sumstats/lt_qt_ukbb_mar23_2020_unrelated.bgen.stats.gz --auto  --n-val 134586 --pval P_BOLT_LMM_INF --a2 ALLELE0 --frq A1FREQ --head 10 --out results_filtered/lt_qt_ukbb_mar23_2020_unrelated.bgen.stats.gz.mixer1
# python python_convert/sumstats.py zscore --sumstats results_filtered/lt_qt_ukbb_mar23_2020_unrelated.bgen.stats.gz.mixer1 | \
# python python_convert/sumstats.py qc --exclude-ranges 6:26000000-34000000 --max-or 1e37 --max-or 1e37  --out results_filtered/lt_qt_ukbb_mar23_2020_unrelated.bgen.stats.gz.mixer2
# gzip results_filtered/lt_qt_ukbb_mar23_2020_unrelated.bgen.stats.gz.mixer2

# #UKBB basic
# python python_convert/sumstats.py csv --sumstats sumstats/ptsd_qt_ukbb_mar23_2020_unrelated.bgen.stats.gz --auto  --n-val 134586 --pval P_BOLT_LMM_INF --a2 ALLELE0 --frq A1FREQ --head 10 --out results_filtered/ptsd_qt_ukbb_mar23_2020_unrelated.bgen.stats.gz.mixer1
# python python_convert/sumstats.py zscore --sumstats results_filtered/ptsd_qt_ukbb_mar23_2020_unrelated.bgen.stats.gz.mixer1 | \
 # python python_convert/sumstats.py qc --exclude-ranges 6:26000000-34000000 --max-or 1e37 --max-or 1e37  --out results_filtered/ptsd_qt_ukbb_mar23_2020_unrelated.bgen.stats.gz.mixer2
# gzip results_filtered/ptsd_qt_ukbb_mar23_2020_unrelated.bgen.stats.gz.mixer2

# #MTAG
# python python_convert/sumstats.py csv --sumstats eur_PTSD_Continuous_m0_pcs_alldata_may8_2020_ukbb_trauma_trait_1.txt.gz --auto  --n-val 176568 --pval mtag_pval --a1 A1 --a2  A2 --frq FRQ --head 10 --out results_filtered/eur_PTSD_Continuous_m0_pcs_alldata_may8_2020_ukbb_trauma_trait_1.txt.gz.mixer1
 # python python_convert/sumstats.py zscore --sumstats results_filtered/eur_PTSD_Continuous_m0_pcs_alldata_may8_2020_ukbb_trauma_trait_1.txt.gz.mixer1 | \
  # python python_convert/sumstats.py qc --exclude-ranges 6:26000000-34000000 --max-or 1e37 --max-or 1e37  --out results_filtered/eur_PTSD_Continuous_m0_pcs_alldata_may8_2020_ukbb_trauma_trait_1.txt.gz.mixer2
 # gzip results_filtered/eur_PTSD_Continuous_m0_pcs_alldata_may8_2020_ukbb_trauma_trait_1.txt.gz.mixer2

#MVP total

# python python_convert/sumstats.py csv --sumstats TotalPCL_MVP_eur.gz --auto --head 10 --n-val 186689 --out results_filtered/MVP.EUR.TOT.txt.gz_f3.mixer1
# python python_convert/sumstats.py zscore --sumstats results_filtered/MVP.EUR.TOT.txt.gz_f3.mixer1 | \
# python python_convert/sumstats.py qc --exclude-ranges 6:26000000-34000000 --max-or 1e37 --max-or 1e37  --out results_filtered/MVP.EUR.TOT.txt.gz_f3.mixer2
# gzip results_filtered/MVP.EUR.TOT.txt.gz_f3.mixer2





# #UKBB trauma
#module load 2019
# module load Python/3.7.5-foss-2018b #need this to have adequate version of scipi
#module load  Tk/8.6.8-GCCcore-7.3.0 #need this for plots!!
#may need to set path to packages every time using pip when I login or set the pypath at the start
module load Tk/8.6.8-GCCcore-8.3.0 #they updated 

##Univariat mixer for PTSD

# python3 /home/maihofer/trauma_gwas/mixer/precimed/mixer.py fit1 \
      # --trait1-file results_filtered/eur_PTSD_Continuous_m0_pcs_alldata_may8_2020.fuma.gz.mixer2.gz \
      # --out results_filtered/eur_PTSD_Continuous_m0_pcs_alldata_may8_2020.fuma.gz.mixer_results \
      # --extract /home/maihofer/trauma_gwas/mixer/w_hm3.justrs \
      # --bim-file /home/maihofer/trauma_gwas/mixer/1000G_EUR_Phase3_plink/1000G.EUR.QC.@.bim \
      # --ld-file /home/maihofer/trauma_gwas/mixer/1000G_EUR_Phase3_plink/1000G.EUR.QC.@.run4.ld \
      # --lib  /home/maihofer/trauma_gwas/mixer/src/build/lib/libbgmg.so \



# python3 /home/maihofer/trauma_gwas/mixer/precimed/mixer.py test1 \
      # --trait1-file results_filtered/eur_PTSD_Continuous_m0_pcs_alldata_may8_2020.fuma.gz.mixer2.gz \
      # --load-params-file results_filtered/eur_PTSD_Continuous_m0_pcs_alldata_may8_2020.fuma.gz.mixer_results.json \
      # --out results_filtered/eur_PTSD_Continuous_m0_pcs_alldata_may8_2020.fuma.gz.mixer_results.test \
      # --bim-file /home/maihofer/trauma_gwas/mixer/1000G_EUR_Phase3_plink/1000G.EUR.QC.@.bim \
      # --ld-file /home/maihofer/trauma_gwas/mixer/1000G_EUR_Phase3_plink/1000G.EUR.QC.@.run4.ld \
      # --lib  /home/maihofer/trauma_gwas/mixer/src/build/lib/libbgmg.so \


# #plot analysis of trait  
# python3 /home/maihofer/trauma_gwas/mixer/precimed/mixer_figures.py one --json results_filtered/eur_PTSD_Continuous_m0_pcs_alldata_may8_2020.fuma.gz.mixer_results.test.json --out results_filtered/eur_PTSD_Continuous_m0_pcs_alldata_may8_2020.fuma.gz.mixer_results.test.plots

#For lt

# python3 /home/maihofer/trauma_gwas/mixer/precimed/mixer.py fit1 \
      # --trait1-file results_filtered/lt_qt_ukbb_mar23_2020_unrelated.bgen.stats.gz.mixer2.gz \
      # --out results_filtered/lt_qt_ukbb_mar23_2020_unrelated.bgen.stats.gz.mixer_results \
      # --extract /home/maihofer/trauma_gwas/mixer/w_hm3.justrs \
      # --bim-file /home/maihofer/trauma_gwas/mixer/1000G_EUR_Phase3_plink/1000G.EUR.QC.@.bim \
      # --ld-file /home/maihofer/trauma_gwas/mixer/1000G_EUR_Phase3_plink/1000G.EUR.QC.@.run4.ld \
      # --lib  /home/maihofer/trauma_gwas/mixer/src/build/lib/libbgmg.so \



# python3 /home/maihofer/trauma_gwas/mixer/precimed/mixer.py test1 \
      # --trait1-file results_filtered/lt_qt_ukbb_mar23_2020_unrelated.bgen.stats.gz.mixer2.gz \
      # --load-params-file results_filtered/lt_qt_ukbb_mar23_2020_unrelated.bgen.stats.gz.mixer_results.json \
      # --out results_filtered/lt_qt_ukbb_mar23_2020_unrelated.bgen.stats.gz.mixer_results.test \
      # --bim-file /home/maihofer/trauma_gwas/mixer/1000G_EUR_Phase3_plink/1000G.EUR.QC.@.bim \
      # --ld-file /home/maihofer/trauma_gwas/mixer/1000G_EUR_Phase3_plink/1000G.EUR.QC.@.run4.ld \
      # --lib  /home/maihofer/trauma_gwas/mixer/src/build/lib/libbgmg.so \


# #plot analysis of trait  
# python3 /home/maihofer/trauma_gwas/mixer/precimed/mixer_figures.py one --json results_filtered/lt_qt_ukbb_mar23_2020_unrelated.bgen.stats.gz.mixer_results.test.json --out results_filtered/lt_qt_ukbb_mar23_2020_unrelated.bgen.stats.gz.mixer_results.test.plots



##For PTSD + MTAG

python3 /home/maihofer/trauma_gwas/mixer/precimed/mixer.py fit1 \
      --trait1-file results_filtered/eur_PTSD_Continuous_m0_pcs_alldata_may8_2020_ukbb_trauma_trait_1.txt.gz.mixer2.gz \
      --out results_filtered/eur_PTSD_Continuous_m0_pcs_alldata_may8_2020_ukbb_trauma_trait_1.txt.gz.mixer_results \
      --extract /home/maihofer/trauma_gwas/mixer/w_hm3.justrs \
      --bim-file /home/maihofer/trauma_gwas/mixer/1000G_EUR_Phase3_plink/1000G.EUR.QC.@.bim \
      --ld-file /home/maihofer/trauma_gwas/mixer/1000G_EUR_Phase3_plink/1000G.EUR.QC.@.run4.ld \
      --lib  /home/maihofer/trauma_gwas/mixer/src/build/lib/libbgmg.so \



python3 /home/maihofer/trauma_gwas/mixer/precimed/mixer.py test1 \
      --trait1-file results_filtered/eur_PTSD_Continuous_m0_pcs_alldata_may8_2020_ukbb_trauma_trait_1.txt.gz.mixer2.gz \
      --load-params-file results_filtered/eur_PTSD_Continuous_m0_pcs_alldata_may8_2020_ukbb_trauma_trait_1.txt.gz.mixer_results.json \
      --out results_filtered/eur_PTSD_Continuous_m0_pcs_alldata_may8_2020_ukbb_trauma_trait_1.txt.gz.mixer_results.test \
      --bim-file /home/maihofer/trauma_gwas/mixer/1000G_EUR_Phase3_plink/1000G.EUR.QC.@.bim \
      --ld-file /home/maihofer/trauma_gwas/mixer/1000G_EUR_Phase3_plink/1000G.EUR.QC.@.run4.ld \
      --lib  /home/maihofer/trauma_gwas/mixer/src/build/lib/libbgmg.so \

python3 /home/maihofer/trauma_gwas/mixer/precimed/mixer_figures.py one --json results_filtered/eur_PTSD_Continuous_m0_pcs_alldata_may8_2020_ukbb_trauma_trait_1.txt.gz.mixer_results.test.json --out results_filtered/eur_PTSD_Continuous_m0_pcs_alldata_may8_2020_ukbb_trauma_trait_1.txt.gz.mixer_results.test.plots



#lt_qt_ukbb_mar23_2020_unrelated.bgen.stats.gz


#sbatch --time=12:05:00 --error errandout/mixer.e --output errandout/mixer.o 00_mixer.sh 
 