#!/bin/bash

#SBATCH --job-name=future                     # Job name
#SBATCH --mail-type=FAIL           		     # Turn on e-mail notification (NONE,BEGIN,END,FAIL,ALL)
#SBATCH --export=all                         # Export environment variables to the batch job session

#SBATCH --account=csde-ckpt    	             # Allocation Definition
#SBATCH --partition=ckpt
#SBATCH --nodes=1                            # Node resources
#SBATCH --ntasks-per-node=28  		         # CPUs per node
#SBATCH --mem=185G   		                 # Memory per node
#SBATCH --time=12:00:00 	                 # Wall clock time limit hrs:min:sec

pwd; hostname; date #--qos=MaxJobs4

echo "Running MATLAB script for future sims in parallel with calibrated parameter sets"
echo "${USRNAME}"
export USRNAME
echo "${DIRPATH}"
export DIRPATH
echo "${SETIDX}" 
export SETIDX
echo "${TCURR}"
export TCURR
echo "${DATE}"
export DATE

cd ${DIRPATH}

export TZ="America/Los_Angeles"
module load matlab_2018a
mkdir -p /gscratch/csde/${USRNAME}/$SLURM_JOB_ID
matlab -nodisplay -nosplash -r "calib2_runMultFutSims(${SETIDX} , ${TCURR} , '${DATE}' , '${USRNAME}')"

rm -r /gscratch/csde/${USRNAME}/$SLURM_JOB_ID

date
