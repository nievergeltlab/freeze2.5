#/bin/bash!


python3 /home/maihofer/trauma_gwas/mixer//precimed/mixer.py snps \
   --lib /home/maihofer/trauma_gwas/mixer//src/build/lib/libbgmg.so \
   --bim-file /home/maihofer/trauma_gwas/mixer/1000G_EUR_Phase3_plink/1000G.EUR.QC.@.bim \
   --out /home/maihofer/trauma_gwas/mixer/1000G_EUR_Phase3_plink/1000G.EUR.QC.prune_maf0p05_rand2M_r2p8.rep${SLURM_ARRAY_TASK_ID}.snps \
   --maf 0.05 --subset 2000000 --r2 0.8 --seed ${SLURM_ARRAY_TASK_ID}
   
   #sbatch --array=22 --time 02:00:00 --export=ALL 00_make_mixer_snpsfile.sh