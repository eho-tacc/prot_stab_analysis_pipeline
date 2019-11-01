#!/bin/bash

HERE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
new_env=$1
new_env_yml=$2

# Handle defaults
if [ -z ${new_env_yml} ]; then
    echo "No YAML file passed. Reverting to default..."
    new_env_yml=${HERE}/template_notebook_env.yml
fi
filename=$(basename -- ${new_env_yml})
if [ -z ${new_env} ]; then
    echo "No env name passed. Reverting to default..."
    new_env="${filename%.*}"
fi


# Sanity checks
if [ ! -f ${new_env_yml} ]; then
    echo "No conda env YAML file exists at ${new_env_yml}"
    exit 1
fi
if [ -d $LOCAL_ENVS/${new_env} ]; then
    echo "Directory at $LOCAL_ENVS/${new_env} already exists"
    exit 1
fi

# Create conda env from file
conda env list
echo "Creating conda env ${new_env} from file ${new_env_yml}"
conda env create --prefix $LOCAL_ENVS/${new_env} --file ${new_env_yml}
create_exited=$?
if [ ${create_exited} -ne 0 ]; then
    echo "ERROR: conda env creation exited with code ${create_exited}"
    exit ${create_exited}
fi

# Install kernel for Jupyter
conda env list
echo "Creating kernel file for conda env ${new_env}..."
$LOCAL_ENVS/${new_env}/bin/python -m ipykernel install \
    --prefix $JUPYTER_WORK \
    --name ${new_env} \
    --display-name ${new_env}
