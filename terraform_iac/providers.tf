provider "aws" {
  region = "us-east-1"
  profile = "asginstancerefresh"
}

provider "github" {
  version = "2.4.0"
  organization = "erankitcs"
  token = "XXXX"
}