# data "aws_ami_ids" "webserver_ami" {
#   owners = ["856960422202"]
#   filter {
#     name   = "name"
#     values = ["webami_v*"]
#   }
# }

module "webservers" {
    source = "./web_asg"
    ami_id = "ami-04d29b6f966df1537"
    
}

module "instance_refresh" {
    source = "./instance_refresh_lambda"
    ami_id_ssmps = module.webservers.ami_id_ssmps
    webservers_asg_name = module.webservers.webserver_asg
}

module "cicd_pipeline" {
    source = "./cicd"
    github_token_ssmps = var.github_token_ssmps
    repository         = var.repository
    ami_id_ssmps       = module.webservers.ami_id_ssmps
    region             = var.region
    emailids_tobe_notified = var.emailids_tobe_notified
    github_Oauthtoken   = var.github_Oauthtoken
    aws_profile         = var.aws_profile
}