#!/bin/bash
#SBATCH --job-name=lmp_apptainer_gpu
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=16GB
#SBATCH --time=48:00:00
#SBATCH --no-requeue
#SBATCH --partition=gpu
#SBATCH --gres=gpu:1
#SBATCH --account=brieda_368
##SBATCH --mail-user=jjmeyer@usc.edu
##SBATCH --mail-type=all

# Load Apptainer
module purge
module load apptainer

# Environment setup
export OMP_NUM_THREADS=1
export APPTAINER_CACHEDIR=/scratch1/jjmeyer/apptainer_cache
export APPTAINER_BIND="$PWD,/scratch1/jjmeyer"
export OMPI_MCA_opal_warn_on_missing_libcuda=0

# Ulimits
ulimit -u 127590
ulimit -n 102400
ulimit -s unlimited

# Move to submit directory
cd "${SLURM_SUBMIT_DIR}"

# Input file
INPUT_FILE="$PWD/input_Jul15_HeteroAA_TGA_350K.lammps"

# Run LAMMPS inside Apptainer
apptainer exec --cleanenv --nv /project/brieda_368/jjmeyer/LAMMPS_Sims/lammps_patch_15Jun2023.sif \
env LD_LIBRARY_PATH=/usr/local/fftw/lib:/usr/local/lammps/sm86/lib \
/usr/local/lammps/sm86/bin/lmp -in "$INPUT_FILE"
