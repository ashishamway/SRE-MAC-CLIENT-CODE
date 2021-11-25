#!/bin/bash


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
        elif [ "$lcase" = "state list" ]
            then TF_COMMAND="state list"
        elif [ "$lcase" =~ .*"state rm".* ]
            then TF_COMMAND="state rm ""${u:8}"
        else 
            TF_COMMAND="apply"
        fi
    fi 
    echo $TF_COMMAND > temp.txt
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

echo terraform execution started on `date`
set_cmd
prepareStateFileConfig
setupGitAccess
print