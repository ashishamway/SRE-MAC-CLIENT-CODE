#! /bin/bash

json_file=$CODEBUILD_SRC_DIR/tf_output.json
cd  $CODEBUILD_SRC_DIR/main/app
terraform output -json | jq '.dynatrace_outputs.value' > $json_file

# if [[ -s $json_file ]] && grep -q "null" $json_file ; then
#     echo "File Contain NULL!!!" 
# else
    cd $CODEBUILD_SRC_DIR/SRE-MAC-CLIENT-CODE/scripts
    python3 -m venv testtfoutput && source testtfoutput/bin/activate && pip3 install -r requirements.txt  
    python3 read_tf_output.py $TF_COMMAND 
# fi
rm -f $json_file
echo "run_py.sh execution completed..."