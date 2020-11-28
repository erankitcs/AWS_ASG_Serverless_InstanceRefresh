## Creating AMI Parameter store with default value.
resource "aws_ssm_parameter" "webserver_ami_id_ssmps" {
  name  = "webserver/amiid"
  type  = "String"
  value = var.ami_id
}

## Creating Web Server ASG
resource "aws_launch_template" "webserver_lt" {
  name_prefix   = "webserver"
  image_id      = var.ami_id
  instance_type = "t2.micro"
}

## Get Availability zone for given region


## Create ASG
resource "aws_autoscaling_group" "bar" {
  availability_zones = ["us-east-1a"]
  desired_capacity   = 2
  max_size           = 4
  min_size           = 1

  launch_template {
    id      = aws_launch_template.webserver_lt.id
    version = "$Latest"
  }
}