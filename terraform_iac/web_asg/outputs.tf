output "ami_id_ssmps" {
    value = aws_ssm_parameter.webserver_ami_id_ssmps.name
}