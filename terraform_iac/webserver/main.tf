## Creating AMI Parameter store with default value.
resource "aws_ssm_parameter" "webserver_ami_id_ssmps" {
  name  = "/webserver/amiid"
  type  = "String"
  value = var.ami_id
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_http"
  }
}

## Creating Web Server ASG
resource "aws_launch_template" "webserver_lt" {
  name_prefix   = "webserver"
  image_id      = var.ami_id
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.allow_http.id]
  lifecycle {
    ignore_changes = [image_id]
  }
}

## Create ASG
resource "aws_autoscaling_group" "webserver_asg" {
  name = "webserver_asg"
  vpc_zone_identifier = data.aws_subnet_ids.webserver_subnets.ids
  desired_capacity   = 2
  max_size           = 2
  min_size           = 1

  launch_template {
    id      = aws_launch_template.webserver_lt.id
    version = "$Latest"
  }
  lifecycle {
    ignore_changes = [load_balancers, target_group_arns]
  }
}

############### Application Load Balancer ###############################

resource "aws_lb" "webserver_alb" {
  name               = "webserveralb"
  internal           = false
  load_balancer_type = "application"
  subnets            = data.aws_subnet_ids.webserver_subnets.ids
  tags = {
    Environment = "dev"
  }
}

resource "aws_lb_target_group" "webserver_tg" {
  name     = "webservertg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "webserver_listner" {
  load_balancer_arn = aws_lb.webserver_alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webserver_tg.arn
  }
}

resource "aws_autoscaling_attachment" "asg_attachment_webserver" {
  autoscaling_group_name = aws_autoscaling_group.webserver_asg.id
  alb_target_group_arn   = aws_lb_target_group.webserver_tg.arn
}