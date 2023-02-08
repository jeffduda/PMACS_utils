#!/bin/bash

usage() { echo "Usage: $0 -i input_dir -o output_dir [-r run,bsub,echo] [-q queue_name] [-f]"; exit 1; }

idir="" # base directory for inpu
odir="" # base directory for output
queue="" # queue name if submitting to cluster
run="echo" # run, bsub, echo
force=0

while getopts fi:o:q:r:h flag
do
  case "${flag}" in
     f) force=1;;
     i) idir=${OPTARG};;
     o) odir=${OPTARG};;
     q) queue=${OPTARG};;
     r) run=${OPTARG};;
     h) usage;;
  esac
done

if [[ "${idir}" == "" ]]; then
  echo "No input directory specified"
  exit 1
fi
if [[ "${odir}" == "" ]]; then
  echo "No output directory specified"
  exit 1
fi

# Check for run type
if [[ "${run}" == "echo" ]]; then
    echo "Running in test mode. Use '-r run' to run"
elif [[ "${run}" != "bsub" ]]; then
    echo "Submitting jobs to queue: ${queue}"
elif [[ "${run}" != "run" ]]; then
    echo "Running jobs locally"
else
    echo "Invalid run option: ${run}"
    exit 1
fi    

echo "Input: $idir"
echo "Output: $odir"

# Load required modules if not running locally
if [[ "${run}" != "run" ]]; then
    module load python/3.9
fi


for i in `ls -d ${idir}/*`; do

    sub=`basename $i`
    out_dir="${odir}/${sub}"
    echo $out_dir

    runsub=1
    if [[ -e "${out_dir}" ]]; then
        if [[ "${force}" == 1 ]]; then
            echo "Rerunning in ${out_dir}"
            runsub=1
        else
            echo "Output directory already exists for ${sub}. Remove to force rerun"
            runsub=0
        fi
    fi

    if [[ ${runsub} == 1 ]]; then 

        mkdir -p ${out_dir}
        log="${out_dir}/log_${sub}.txt"
        job="${out_dir}/job_${sub}.sh"

        echo "#!/bin/bash" > ${job}

        if [[ "${run}" == "bsub" ]]; then
            echo "#BSUB -J my_app_${sub}" >> ${job}
            echo "#BSUB -o ${out_dir}/log_${sub}.out" >> ${job}
            echo "#BSUB -e ${out_dir}/log_${sub}.err" >> ${job}
            echo "module load python/3.9" >> ${job}
        fi

        # Run the command required
        echo "python my_app.py ${i}" >> ${job}

        if [[ "${run}" == "bsub" ]]; then
            bsub -q ${queue} < ${job}
        elif [[ "${run}" == "run" ]]; then
            bash ${job}
        else
            echo "Created job: ${job}"
        fi  

    else
        echo "Output directory already exists for ${sub}. Remove to force rerun"
    fi

done
