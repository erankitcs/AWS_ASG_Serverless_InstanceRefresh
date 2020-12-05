variable "github_token" {
  type = string
  description = "Token of GIT Hub Pipeline Webhook"
}

variable "repository" {
  type = string
  description = "Repository name for GIT Hub Web Hook."
}

variable "region" {
  type = string
  description = "Name of the Region to be deployed."
}

variable "emailids_tobe_notified" {
  type = string
  description = "List of email addresses as string(space separated) to be notified with new image."
}

variable "github_Oauthtoken" {
  type = string
  description = "Git Hub OAuth token for GIT hub connection."
}

variable "aws_profile" {
  type = string
  description = "AWS Profile to be used to create resources."
}

variable "vpc_id" {
  type = string
  description = "VPC Id for Web Servers."
}

variable "ami_id" {
  type = string
  description= "Base AMI ID for web server."
}

variable "keypair_name" {
  type = string
  description= "Key Pair Name for Instances."
}

