variable "ami_id_ssmps" {
  type = string
  description = "Parameter store name for web server AMI ID."
}

variable "webservers_asg_name" {
  type = string
  description = "Autoscaling group name of Web Servers."
}