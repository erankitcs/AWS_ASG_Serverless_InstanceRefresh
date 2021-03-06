variable "ami_id" {
  type = string
  description= "AMI ID for web server."
}

variable "vpc_id" {
  type = string
  description = "VPC Id for Web Servers."
}

variable "keypair_name" {
  type = string
  description= "Key Pair Name for Instances."
}