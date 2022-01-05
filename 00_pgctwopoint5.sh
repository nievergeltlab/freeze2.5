#!/bin/bash
/home/maihofer/trauma_gwas/METAL-master/build/bin/metal freezetwopointfive.mi

# sbatch -t 02:45:00  --error errandout/freezetwopointfive.e --output errandout/freezetwopointfive.o  -D /home/maihofer/trauma_gwas 00_pgctwopoint5.sh
 
 
 cat freezetwopointfive1.tbl | grep -v \? | awk '{ if (NR ==1 || ($6 >= 0.01 && $6 <= 0.99 && $3 != "MarkerName" && $10 > 150000)) print $1,$2,$3,$4,$5,$6,$10,$11,$12,$13}'  | gzip > freezetwopointfive1.fuma.gz
 