## Creating AMI Parameter store with default value.
resource "aws_ssm_parameter" "webserver_ami_id_ssmps" {
  name  = "/webserver/amiid"
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
resource "aws_autoscaling_group" "webserver_asg" {
  name = "webserver_asg"
  availability_zones = ["us-east-1a"]
  desired_capacity   = 0
  max_size           = 0
  min_size           = 0

  launch_template {
    id      = aws_launch_template.webserver_lt.id
    version = "$Latest"
  }
}