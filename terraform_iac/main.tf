# data "aws_ami_ids" "webserver_ami" {
#   owners = ["856960422202"]
#   filter {
#     name   = "name"
#     values = ["webami_v*"]
#   }
# }

module "webservers" {
    source = "./webserver"
    ami_id = var.ami_id
    vpc_id = var.vpc_id
    keypair_name = var.keypair_name
    
}

module "instance_refresh" {
    source = "./instance_refresh_lambda"
    ami_id_ssmps = module.webservers.ami_id_ssmps
    webservers_asg_name = module.webservers.webserver_asg
}

module "cicd_pipeline" {
    source = "./cicd"
    github_token       = var.github_token
    repository         = var.repository
    ami_id_ssmps       = module.webservers.ami_id_ssmps
    region             = var.region
    emailids_tobe_notified = var.emailids_tobe_notified
    github_Oauthtoken   = var.github_Oauthtoken
    aws_profile         = var.aws_profile
    base_ami_id         = var.ami_id
}