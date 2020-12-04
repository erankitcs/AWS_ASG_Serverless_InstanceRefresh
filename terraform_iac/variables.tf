variable "github_token_ssmps" {
  type = string
  description = "Parameter store name for token of GIT Hub Pipeline"
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

