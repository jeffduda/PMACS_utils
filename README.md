# PMACS_utils

## Usage
```
sh run_jobs.sh -i /my/data/input -o /my/data/output -r echo 
-i input base directory
-o output base directory
-r run type
-f force run if output already exists
-h show usage

input base directory: a directory with files or subdirectories to process
output base directory: a directory where output will be place. 
run type: one of echo, bsub, or run
  echo - just create jobs (this is the default)
  bsub - create jobs and submit to queue
  run - create jobs and run locally

```

## What it does
The script will cycle through everything in the input directory. In line 53 you can adjust the wildcard to only look at specific file extensions. If the extension is changed on line 53, line 55 will also need to be changed to match. For each input, a corresponding output directory will be created in the output base directory. The new directory will have the name of the input file with the extension removed. For each input, a processing script will be created in the new directory. Around line 84 you will need to add in whatever modules your script needs to run. At line 92 you will need to edit or add lines that do the desired processing. 

Once the jobs are created, you can test out a script by starting and interactive session with 'ibash' and running a job script. If that works, remove the output and try submitting the same script to the queue with 'bsub < job_1.sh' (replace job_1.sh with one of the created scripts). If that works, just submit the rest of the scripts (or clean the output directory and rerun with '-r bsub')