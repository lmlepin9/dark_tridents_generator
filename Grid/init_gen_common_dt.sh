#!/bin/bash

MY_FCL_FILE=$1 #prodgenie_bnb_nu_filtered_NCPiZero_uboone.fcl                                                                                                                                               
MY_N_EVENTS=$2 #2500
MY_INPUT_FILE=$3                                                                                                                                                                                        
MY_OUTPUT_FILE=${4:-genfile.root.local}
MY_OUT_LOG=larInitGen.out
MY_ERR_LOG=larInitGen.err

echo "FCL file: " $MY_FCL_FILE
echo "Input: " $MY_INPUT_FILE
echo "Output: " $MY_OUTPUT_FILE

echo "#include \"$MY_FCL_FILE\"" > local_gen.fcl
echo "physics.producers.generator.InputFileName: \"$MY_INPUT_FILE\"" >> local_gen.fcl
echo "physics.producers.generator.FluxCopyMethod: \"IFDH\"" >> local_gen.fcl
echo "physics.producers.generator.MaxFluxFileMB: 500" >> local_gen.fcl
echo "services.IFDH: {}" >> local_gen.fcl

echo "#include \"$MY_FCL_FILE\"" > local_gen_include.fcl
echo "physics.producers.generator.FluxCopyMethod: \"IFDH\"" >> local_gen_include.fcl
echo "physics.producers.generator.MaxFluxFileMB: 500" >> local_gen_include.fcl
echo "services.IFDH: {}" >> local_gen_include.fcl
echo "gen_detail: { physics: {@table::physics} services: {@table::services} outputs: {@table::outputs} source: {@table::source} process_name: @local::process_name }" >> local_gen_include.fcl

if [ -f $MY_OUTPUT_FILE ]; then
    echo "File $MY_OUTPUT_FILE exists, so not generating again."
else
    echo "File $MY_OUTPUT_FILE does not exist, so running generation of it..."
    echo "Running command 'lar -c local_gen.fcl -T ./genfile_hist.root -o $MY_OUTPUT_FILE -n $MY_N_EVENTS > $MY_OUT_LOG 2> $MY_ERR_LOG' "
    lar -c local_gen.fcl -T ./genfile_hist.root -o genfile.root.temp -n $MY_N_EVENTS
    lar -c standard_overlay_gen_SubRunPOTInEvent.fcl -s genfile.root.temp -T ./genfile_pot_hist.root -o $MY_OUTPUT_FILE -n -1
    rm genfile.root.temp
fi
