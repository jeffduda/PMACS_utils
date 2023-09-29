# PMACS_utils

## Usage
```
sh run_jobs.sh -i /my/data/input -o /my/data/output -r echo 
-i input base directory
-o output base directory
-r run type
-f force run if output already exists
-h show usage
```

## What it does
The script will cycle through everything in the input directory. In line 53 you can adjust the wildcard to only look at specific file extensions. If the extension is changed on line 53, line 55 will also need to be changed to match. For each input, a corresponding output directory will be created in the output base directory. The new directory will have the name of the input file with the extension removed. 