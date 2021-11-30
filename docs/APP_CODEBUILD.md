# Codebuild Setup

This code will setup codebuild in `AWS AMER Automation Platform PROD` account for client applications using terraform. Terraform will its state file in the same aws account at location `s3://mac-codebuild-terraform-state/mac/<preprod/prod>/terraform.tfstate`. It is internally using codebuild modeule provided by **SRC-MAC** team present in [this](https://github.com/AmwayACS/SRE-MAC-CORE-REPO.git) repo.