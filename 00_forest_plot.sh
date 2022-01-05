echo "rs10266297,7
rs10821140,9
rs10821154,9
rs146918648,6
rs1504930,5
rs2721802,7
rs2721817,7
rs2894699,7
rs35888516,20
rs4557006,2
rs6896669,5
rs71149745,7
rs7264419,20
rs72657988,1
rs8059002,16" > may8_2020_hits.csv #Latino hit is just the overall anc tophit, but a few markers away


#Load summary GWAS data for forest plot SNPS

for fp in $(cat may8_2020_hits.csv  )
do
  forestsnp=$(echo $fp | awk 'BEGIN {FS=","}{print $1}') 
  forestsnpchr=$(echo $fp | awk 'BEGIN {FS=","}{print $2}')

  # zgrep -w -m1 $forestsnp results_cat/*PTSD*.assoc.gz_"$forestsnpchr".gz | sed 's/:/ /' | sed 's/results_cat\///g' | sed 's/\.gz_[0-9]*.gz/.gz/g' | awk 'BEGIN{OFS="\t"}{print}' | column -t > results_filtered/forest_plots/"$forestsnp"_class1.use
  # zgrep -w -m1 $forestsnp results_cat/*.Case.assoc.gz_"$forestsnpchr".gz | sed 's/:/\t/' | sed 's/results_cat\///g' | sed 's/\.gz_[0-9]*.gz/.gz/g' | awk 'BEGIN{OFS="\t"}{print}' | column -t > results_filtered/forest_plots/"$forestsnp"_class2.use
  # zgrep -w -m1 $forestsnp sumstats/bychr/*_"$forestsnpchr".gz | grep -v vetsa | grep -v ukbb | sed 's/:/ /' | sed 's/sumstats\/bychr\///g' | sed 's/\.gz_[0-9]*.gz/.gz/g' | column -t > results_filtered/forest_plots/"$forestsnp"_class3.use
  # zgrep -w -m1 $forestsnp sumstats/bychr/*_"$forestsnpchr".gz | grep -E ukbb\|vetsa | sed 's/:/ /' | sed 's/sumstats\/bychr\///g' | sed 's/\.gz_[0-9]*.gz/.gz/g' | column -t > results_filtered/forest_plots/"$forestsnp"_class4.use


 echo "Extracting data for $forestsnp $forestsnpchr"

Rscript 0_forest_plot.r results_filtered/forest_plots/"$forestsnp" results_filtered/forest_plots/header_classes.csv results_filtered/forest_plots/forestplot_descriptor.csv results_filtered/forest_plots/"$forestsnp"

done


snpresults="results_filtered/forest_plots/rs10266297"
header_classes="results_filtered/forest_plots/header_classes.csv"
descriptor="results_filtered/forest_plots/forestplot_descriptor.csv"
outfile="results_filtered/forest_plots/rs10266297"
