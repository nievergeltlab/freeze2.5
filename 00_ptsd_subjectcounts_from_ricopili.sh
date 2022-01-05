#Get N cases from every PTSD analysis
#Get N SNPs passing QC in each imputed GWAS

#Just rerun metal and get line count after filtering for each?


#Get line count for each sumstats file 
for files in $(ls */* | grep -v male ) 
do
#echo $files
ncc=$(zcat $files | head -n 1 | awk '{print $6,$7}' | sed 's/FRQ_A_//g' | sed 's/FRQ_U_//g')

#nl=$(zcat $files | wc -l  | awk '{print $1}')

echo $files $ncc #$nl

done

