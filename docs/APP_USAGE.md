### This repo will be used by Project team in there build process to configure desired monitoring.

Users of this application having intent to setup monitoring for there application or lambda to move logs from cloudwatch to Splunk can create new `.tf` files using modules provided by **SRE-MAC** team. They will trigger aws codebuild setup in `AWS AMER Automation Platform PROD` account for that specific app using terraform. Terraform will its state file in S3 bucket in the same aws account at path `s3://mac-terraform-state/mac/test/<project-name>-terraform.tfstate`.

**Note** 

Clients are strickly requested to keep field name for output node as **dynatrace_outputs** in `.tf` file  because this field name will be retrieved in script to create confluence page for displaying terraform output having resources details. Clients can have any number of `.tf` files and they can maintain stand alone single *output.tf* file having node with name **dynatrace_outputs**. 
  Below is the sample block for reference:

    
    output "dynatrace_outputs" {
    description = "Dynatrace Outputs"
    value       = module.<module-name>.<field-name>
    }