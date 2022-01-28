#!/bin/bash
set -e

# check TF_COMMAND variable from environment else set default to `apply`
function set_cmd() {
    if [ -z "$TF_COMMAND" ]
        then TF_COMMAND="apply"
    else
        lcase=`echo $TF_COMMAND | tr A-Z a-z`
        if [ "$lcase" = "apply" ]
            then  TF_COMMAND="apply"
        elif [ "$lcase" = "destroy" ]
            if [ -z "$REMOVE_MODULES" ]
                then TF_COMMAND="destroy"
            else
                TF_COMMAND="destroy "
                IFS=','; rem_list=($REMOVE_MODULES); unset IFS;
                for ele in "${rem_list[@]}"
                do
                TF_COMMAND+=" -target $ele "
                done
            fi
        else 
            TF_COMMAND="apply"
        fi
    fi 
    echo $TF_COMMAND > temp.txt
    echo "======temp.txt=========== "
    cat temp.txt
    echo "================= "
}

function prepareStateFileConfig() {
    echo "bucket = \"$tfStateBucket\"" >> $CODEBUILD_SRC_DIR/state.conf
    echo "key = \"$tfStateFile\"" >> $CODEBUILD_SRC_DIR/state.conf
    echo "region = \"$awsRegion\"" >> $CODEBUILD_SRC_DIR/state.conf
}

function setupGitAccess() {
    # Setting up GitHub access to connect to ma-terraform-repo.git repo
    git config --global url."https://oauth2:$GITHUB_PERSONAL_TOKEN@github.com".insteadOf https://github.com
    cat ~/.gitconfig
}

# print env variable values
function print() {
    msg="************* \n
            Environment=$environment
            CommitId=$CommitId  \n
            CommitMessage=$CommitMessage  \n
            BranchName=$BranchName  \n
            AuthorDate=$AuthorDate \n 
            RepositoryName=$RepositoryName  \n
            TF_COMMAND=$TF_COMMAND
         ************* "
    echo -e "$msg"
}

# run at prebuild time
function prebuild() {
    echo "************************ Runing prebuild() ************************"
    echo terraform execution started on `date`
    set_cmd
    prepareStateFileConfig
    setupGitAccess
    print
    echo "************************ prebuild() finish ************************"
}

# run at build time
function build() {
    echo "************************ Runing build() ************************"
    TF_COMMAND=`cat temp.txt`
    cd "$CODEBUILD_SRC_DIR/main/app"
    ls -lrt "$CODEBUILD_SRC_DIR/main/app"
    terraform --version
    echo "check state.conf file present!!" && ls -lta $CODEBUILD_SRC_DIR/code-build/
    terraform init -input=false --upgrade --backend-config=$CODEBUILD_SRC_DIR/state.conf
    terraform validate
    terraform plan -lock=false -input=false       
    terraform $TF_COMMAND -input=false -auto-approve
    echo "************************ build() finish ************************"
}

# Check if the function exists (bash specific)
if declare -f "$1" > /dev/null
then
  "$@"
else
    if [ -z "$1" ]
        then echo "Please pass valid functon name to execute."
    else  echo "'$1' function does not exist." >&2
    fi
  exit 1
fi