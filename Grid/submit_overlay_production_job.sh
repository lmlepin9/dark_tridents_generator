#!/bin/bash
# Script to submit a job to the fermigrid using jobsub 
# OS: SLF7

DO_TAR=1 
TAG="PRODUCTION"
INPUT_FILES="./input_dt_files.txt"
OVERLAY_FILES="./dt_overlay_7_files.txt"
OUTDIR_TEMP="/pnfs/uboone/scratch/users/$USER/dt_overlay/$TAG/files"
LOGDIR_TEMP="/pnfs/uboone/scratch/users/$USER/dt_overlay/$TAG/log"
CACHE_FOLDER_TEMP="/pnfs/uboone/scratch/users/$USER/dt_overlay/$TAG/CACHE"
TARFILE_NAME="/pnfs/uboone/scratch/users/lmoralep/dark_tridents_overlay_scripts.tar.gz"
OUT_TEMP="dark_trident_overlay_production_0.05"
MEMORY="16GB"
DISK="10GB"



#sed -n "${COUNTER}p" files_DM_lite.list

COUNTER=1
while IFS= read -r line
do
  tmp_file=$(sed -n "${COUNTER}p" $OVERLAY_FILES)
  newfile=`samweb locate-file "${tmp_file}"`
  # get rid of the "enstore:"
  location=${newfile#"enstore:"}

  # get rid of anything after the bracket
  location=${location%(*}

  # create the full path
  overlay_input="${location}/${tmp_file}"

  echo "Dark trident hepevt input: $line"
  echo "Overlay input: $overlay_input"

  echo "Submitting job..."
  OUT_NAME=$OUT_TEMP"_"$COUNTER".root"
  OUTDIR=$OUTDIR_TEMP/$COUNTER
  LOGDIR=$LOGDIR_TEMP/$COUNTER
  CACHE_FOLDER=$CACHE_FOLDER_TEMP/$COUNTER 
  mkdir -p $OUTDIR
  mkdir -p $LOGDIR 
  mkdir -p $CACHE_FOLDER 
  cp ./overlay_job.sh $CACHE_FOLDER

  jobsub_submit --resource-provides=usage_model=DEDICATED,OPPORTUNISTIC \
	      --role=Analysis \
          --OS=SL7 -g \
		  --append_condor_requirements='(TARGET.HAS_SINGULARITY=?=true)' \
	      --expected-lifetime=2h  \
          --mail_never \
	      --memory $MEMORY \
	      --disk $DISK \
	      -d DARKTRIDENT $OUTDIR \
	      -G uboone \
          -e OUT_NAME=$OUT_NAME \
          -f $TARFILE_NAME \
		  -f $line\
          -f $overlay_input\
	      -L $LOGDIR/dt_overlay_$COUNTER.log \
	      file://$CACHE_FOLDER/overlay_job.sh  
      
  ((COUNTER=COUNTER+1))
done < "$INPUT_FILES"

