#!/bin/bash

# #Compile mixer
# module load 2019
# module load Boost.Python/1.67.0-foss-2019b-Python-3.6.6  #CMake/3.12.1-GCCcore-7.3.0
 
 module load 2019
 # module load Python/3.7.5-foss-2019b
module load Boost.Python/1.67.0-intel-2019b-Python-3.6.6
module load Tk/8.6.8-GCCcore-8.3.0 #they updated 


#IF YOU COMPILE NOW, IT WILL COMPLAIN ABOUT LIBARCHIVE.SO 
#TO FIX:

#Download libarchive 
#tar xvzf libarchive 
#./configure --prefix=/home/maihofer/libraries
#make
#make install
#possibly set path at this point

# Libraries have been installed in:
   # /home/maihofer/libraries/lib

#This part is important:
# If you ever happen to want to link against installed libraries
# in a given directory, LIBDIR, you must either use libtool, and
# specify the full pathname of the library, or use the '-LLIBDIR'
# flag during linking and do at least one of the following:
   # - add LIBDIR to the 'LD_LIBRARY_PATH' environment variable
     # during execution
   # - add LIBDIR to the 'LD_RUN_PATH' environment variable
     # during linking
   # - use the '-Wl,-rpath -Wl,LIBDIR' linker flag
   # - have your system administrator add LIBDIR to '/etc/ld.so.conf'

#Therefore, you must do this when you restart your LISA session so it can FIND this!
# LD_LIBRARY_PATH=/home/maihofer/libraries/lib:$LD_LIBRARY_PATH


 git clone --recurse-submodules -j8 https://github.com/precimed/mixer.git
 mkdir mixer/src/build && cd mixer/src/build
 cmake .. && make bgmg -j16   
 
#Build LD
 # for chr in {1..22}
# do
# python3 /home/maihofer/trauma_gwas/mixer//precimed/mixer.py ld \
   # --lib /home/maihofer/trauma_gwas/mixer//src/build/lib/libbgmg.so \
   # --bfile /home/maihofer/trauma_gwas/mixer//1000G_EUR_Phase3_plink/1000G.EUR.QC."$chr" \
   # --out /home/maihofer/trauma_gwas/mixer//1000G_EUR_Phase3_plink/1000G.EUR.QC."$chr".run4.ld \
   # --r2min 0.05 --ldscore-r2min 0.05 --ld-window-kb 30000
# done    


 