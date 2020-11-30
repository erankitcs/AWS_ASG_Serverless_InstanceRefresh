# AWS_ASG_Serverless_InstanceRefresh
This project is created to build a serverless CICD pipeline for ASG Instance refresh. We would be using HashiCorp Packer to create AMI and create notification to kick start serverless ASG Instance refresh.

## Install Packer
- Learn more: `https://learn.hashicorp.com/tutorials/packer/getting-started-install`
- install `choco install packer`
- Verify: `packer`

## Run packer to build image.
- cd ami_build_packer
- packer build images/web_ami_image.json

## Run Terraform to deploy Web ASG and serverless setup to automation for ASG instance refresh later.
- 
