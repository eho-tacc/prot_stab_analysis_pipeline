#!/bin/bash

new_env=$1
new_env_yml=$2

if [ ! -f ${new_env_yml} ]; then
    echo "No conda env YAML file exists at ${new_env_yml}"
    exit 1
fi
if [ -d $LOCAL_ENVS/${new_env} ]; then
    echo "Directory at $LOCAL_ENVS/${new_env} already exists"
    exit 1
fi

conda env list
echo "Creating conda env ${new_env} from file ${new_env_yml}"
conda env create --prefix $LOCAL_ENVS/${new_env} --file ${new_env_yml}
conda env list
echo "Creating kernel file for conda env ${new_env}..."
$LOCAL_ENVS/${new_env}/bin/python -m ipykernel install \
    --prefix $JUPYTER_WORK \
    --name ${new_env} \
    --display-name ${new_env}
