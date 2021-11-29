#!/bin/bash

set -e

#### TERRAFORM SPECIFIC COMMANDS #######
TF_COMMAND=$1

CODE_BUILD_LOCATION=$PWD/code-build
STATE_FILE_LOCATION=$CODE_BUILD_LOCATION/state.conf

# check TF_COMMAND variable from environment else set default to `apply`
function set_cmd() {
    if [ -z "$TF_COMMAND" ]
        then TF_COMMAND="apply"
    else
        lcase=`echo $TF_COMMAND | tr A-Z a-z`
        if [ "$lcase" = "apply" ]
            then  TF_COMMAND="apply"
        elif [ "$lcase" = "destroy" ]
            then TF_COMMAND="destroy"
        else 
            TF_COMMAND="apply"
        fi
    fi 
    # echo $TF_COMMAND > temp.txt
}

function terraformValidate() {
    cd $CODE_BUILD_LOCATION
    terraform --version
    terraform init -input=false --upgrade --backend-config=$STATE_FILE_LOCATION
    terraform validate
}

function terraformPlan() {
    cd $CODE_BUILD_LOCATION
    terraform plan -lock=false -input=false
}

function terraformApply() {
    cd $CODE_BUILD_LOCATION
    terraform $TF_COMMAND -input=false -auto-approve
}

# print env variable values
function print() {
echo "****************************************************************************************"
echo "********************************* CODE BUILD SETUP COMPLETED****************************"
echo -e "****************************************************************************************\n\n\n\n"
}

echo "****************************************************************************************"
echo "********************************* CODE BUILD SETUP STARTED******************************"
echo -e "****************************************************************************************\n\n\n\n"

set_cmd

terraformValidate
terraformPlan
terraformApply
print