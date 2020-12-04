provider "aws" {
  region = var.region
  profile = var.aws_profile
}

provider "github" {
  version = "2.4.0"
  organization = "erankitcs"
  token = var.github_Oauthtoken
}