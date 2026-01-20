#!/bin/sh
### The following section is the batch-job specific content which places your "order" 
### –- specify queue where you want to run your job --
#BSUB -q gpuv100
### -- set the job name: this is used for monitoring your job later --
#BSUB -J my_cool_job
### -- ask for number of CPU cores (in most cases just leave it as 4) --
#BSUB -n 4
### -- Select 1 gpu in exclusive process mode (in most cases leave it as is) --
#BSUB -gpu "num=1:mode=exclusive_process"
### -- set walltime limit: hh:mm --  maximum 24 hours for GPU-queues. Your job is killed if it exceeds.
#BSUB -W 1:00
### request 1GB of GPU-memory
#BSUB -R "rusage[mem=1GB]"
### set the job to run on a single host machine (don't change this)
#BSUB -R "span[hosts=1]"
### -- set an email address - a mail will be sent with some important statistics about your job and whether it succeeded/failed --
#BSUB -u s123456@dtu.dk
### -- send e-mail notification when job starts -- 
#BSUB -B
### -- send e-mail notification when job ends with statistics/status --
#BSUB -N
### -- Specify the file to which all your terminal output (e.g. print statements) are saved to
### -- %J will here give it the JobID number which the scheduler assigns when submitting. 
#BSUB -o logs/gpu_%J.out
### -- Specify the file to which all errors are saved to. Important for debugging if it crashes!
#BSUB -e logs/gpu_%J.err

### -- end of batch job options - from here it is just shell code - below is an example --
module load python3/3.10.12
source path/to/your/environment
echo "Training model..."
start=$(date +%s) #example timer start
python3 src/train.py  #train your model
stop=$(date '+%s') #stop the timer to time how long it took
elapsed=$(awk "BEGIN {print $stop - $start}")
echo "training finished in $elapsed seconds" #print how long it took
echo "Running inference"
python3 src/model_inference.py
echo "Plotting results..."
python3 src/some_result_plots.py
echo "Finished all scripts. "
