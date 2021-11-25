#!/bin/bash


RANDOM=$$
PROJECT_REPO_NAME=${PWD##*/}
CODE_BUILD_LOCATION=$PWD/code-build
STATE_FILE_LOCATION=$CODE_BUILD_LOCATION/state.conf

#### AWS S3 Bucket Details
S3_BUCKET_NAME="mac-codebuild-terraform-state"
AWS_REGION="us-east-1"

function prepareStateFileConfig() {
    if [ ! -f $STATE_FILE_LOCATION ]; then
    echo "****************************************************************************************"
    echo "*************************************INFORMATION ***************************************"
    echo "****************************************************************************************"
    echo "bucket = \"$S3_BUCKET_NAME\"" > $STATE_FILE_LOCATION
    echo "key = \"mac/project-state/$PROJECT_REPO_NAME/$RANDOM.tfstate\"" >> $STATE_FILE_LOCATION
    echo "region = \"$AWS_REGION\"" >> $STATE_FILE_LOCATION
    echo "PUSH file $STATE_FILE_LOCATION into master branch of your code repository."
    echo "****************************************************************************************"
    echo "****************************************************************************************"
    else
        echo "****************************************************************************************"
        echo "*************************************INFORMATION ***************************************"
        echo "****************************************************************************************"
        echo "state.conf file exists so not modifying the same."
        echo "Beware of modifying the state.conf file as this file contains information which might be lost if you change it."
        echo "This file should only be generated only once."
        echo "****************************************************************************************"
        echo "****************************************************************************************"
    fi
}

prepareStateFileConfig