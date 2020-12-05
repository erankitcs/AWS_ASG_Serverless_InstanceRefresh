output "ami_id_ssmps" {
    value = module.webservers.ami_id_ssmps
}

output "webserver_asg" {
    value = module.webservers.webserver_asg
}

output "webserver_url" {
  value = module.webservers.webserver_ApplicationLoadBalancer
}

output "eventbridge_id" {
  value = module.instance_refresh.eventbridge_id 
}

output "instancerefesh_lambdafunction" {
  value = module.instance_refresh.instancerefesh_lambdafunction 
}

output "instancerefesh_lambdafunction_arn" {
  value = module.instance_refresh.instancerefesh_lambdafunction_arn 
}

output "codepileline" {
  value = module.cicd_pipeline.codepileline 
}

output "sns_topic" {
  value = module.cicd_pipeline.sns_topic 
}
