#!/bin/bash
# Script to produce dark tridents overlays in the fermilab grid 
echo 
echo "======= Moving to CONDODR DIR INPUT ====== " 
cd $CONDOR_DIR_INPUT
pwd

echo "======== Untaring files ==================="

tar -xzvf *.tar.gz

ls 

echo "======== Setting up uboonecode v08_00_00_58 ====================="
source /cvmfs/uboone.opensciencegrid.org/products/setup_uboone.sh
setup uboonecode v08_00_00_58 -q e17:prof


echo "======= Creating overlay ================================="

N_EVENTS=$(wc -l < hepevt_0.05_NCE_nucleon_*_cut.txt)


echo "Number of events in the hepevt file: $(($N_EVENTS/5))"

echo "./init_gen_common_dt.sh dark_tridents_wirecell_g4_uboone.fcl $(($N_EVENTS/5)) ./hepevt_0.05_NCE_nucleon_*_cut.txt genfile.root.local" >> init_gen_dark_tridents_temp.sh
source init_gen_dark_tridents_temp.sh

lar -c ./dark_tridents_overlay.fcl -s *ext_unbiased*.root -o $OUT_NAME 

mv $OUT_NAME $CONDOR_DIR_DARKTRIDENT


echo "===== DONE...========"


