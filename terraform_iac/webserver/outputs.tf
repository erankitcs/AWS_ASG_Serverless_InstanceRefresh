output "ami_id_ssmps" {
    value = aws_ssm_parameter.webserver_ami_id_ssmps.name
}

output "webserver_asg" {
    value = aws_autoscaling_group.webserver_asg.name
}