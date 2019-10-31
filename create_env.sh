#!/bin/bash

new_env="test1"
new_env_yml=$1


conda env list
echo "Creating conda env ${new_env} from file ${new_env_yml}"
conda env create --prefix $LOCAL_ENVS/${new_env} --file ${new_env_yml}
conda env list
echo "Creating kernel file for conda env ${new_env}..."
$LOCAL_ENVS/${new_env}/bin/python -m ipykernel install \
    --prefix $JUPYTER_WORK \
    --name ${new_env} \
    --display-name ${new_env}
