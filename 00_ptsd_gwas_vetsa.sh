#!/bin/bash
  #must have .map and .gz file listed
 # ls /home/pgcdac/DWFV2CJb8Piv_0116_pgc_data/pts/wave2/v1/vets/qc1/* | grep map | sed 's/.map//g' | awk '{print $1".map",$1".gz"}' >  vetsa_doselist.txt
  ls /home/pgcdac/DWFV2CJb8Piv_0116_pgc_data/pts/wave2/v1/ancestry_stratified/v1_eur/vets/qc1eur/* | grep map | sed 's/.map//g' | awk '{print $1".map",$1".gz"}' >  vetsa_doselist.txt

  
  
  #module load plink2
  
 # plink --bfile /home/pgcdac/DWFV2CJb8Piv_0116_pgc_data/pts/wave2/v1/vets/qc/pts_vets_mix_am-qc --autosome --make-bed --out pts_vets_mix_am-qc_autosome
  #plink --bfile /home/pgcdac/DWFV2CJb8Piv_0116_pgc_data/pts/wave2/v1/vets/qc/pts_vets_mix_am-qc --autosome --keep /home/pgcdac/DWFV2CJb8Piv_0116_pgc_data/pts/wave2/v1/ancestry_stratified/v1_eur/vets/qc1eur/eurdos_pts_vets_mix_am-qc.hg19.ch.fl.chr10_000_003.out.dosage.fam --make-bed --out pts_vets_mix_am-qc_autosome2
  
  
  
# you only need to do this once, vetsa subjects are all exposed!! no LT variable
  #basic
  /home/maihofer/trauma_gwas/BOLT-LMM_v2.3.4/bolt \
    --bed=/home/maihofer/trauma_gwas/pts_vets_mix_am-qc_autosome2.bed \
    --bim=/home/maihofer/trauma_gwas/pts_vets_mix_am-qc_autosome2.bim \
    --fam=/home/maihofer/trauma_gwas/pts_vets_mix_am-qc_autosome2.fam \
    --LDscoresFile=/home/maihofer/trauma_gwas/BOLT-LMM_v2.3.4/tables/LDSCORE.1000G_EUR.tab.gz \
    --dosage2FileList /home/maihofer/trauma_gwas/vetsa_doselist.txt \
    --geneticMapFile=/home/maihofer/trauma_gwas/BOLT-LMM_v2.3.4/tables/genetic_map_hg19_withX.txt.gz \
    --lmmForceNonInf \
    --numThreads=15 \
    --verboseStats \
    --statsFile=ptsd_qt_vetsa_may4_2020_related_filtered.stats.gz \
    --statsFileDosage2Snps=ptsd_qt_vetsa_may4_2020_related_filtered.imputed.stats.gz \
    --phenoFile=pheno/p2_vets_vets.pheno \
    --phenoCol=Lifetime_PTSD_Continuous \
    --covarFile=pheno/p2_vets_eur_vets_pcs.cov \
    --qCovarCol=C{1:5}   \
    
    #--noBgenIDcheck
     # --modelSnps /home/maihofer/trauma_gwas/all.pruned \
       #    --statsFileBgenSnps=ptsd_qt_vetsa_may4_2020_related.bgen.stats.gz \ 
# sbatch -t 06:25:00  --error errandout/eur_vets_pcs.e --output errandout/eur_vets_pcs.o  -D /home/maihofer/trauma_gwas 00_ptsd_gwas_vetsa.sh
 #sbatch -t 00:05:00  --error errandout/eur_vets_pcs2.e --output errandout/eur_vets_pcs2.o  -D /home/maihofer/trauma_gwas 00_ptsd_gwas_vetsa.sh
 