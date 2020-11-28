data "aws_ami_ids" "webserver_ami" {
  filter {
    name   = "name"
    values = ["webami_v*"]
  }
}

module "webservers" {
    source = "./web_asg"
    ami_id = data.aws_ami_ids.webserver_ami[0]
    
}

module "instance_refresh" {
    source = "./instance_refresh_lambda"
    ami_id_ssmps = module.webservers.ami_id_ssmps
}

