output "ami_id_ssmps" {
    value = aws_ssm_parameter.webserver_ami_id_ssmps.name
}

output "webserver_asg" {
    value = aws_autoscaling_group.webserver_asg.name
}

output "webserver_ApplicationLoadBalancer" {
  value = "http://${aws_lb.webserver_alb.dns_name}/hello.html"
}