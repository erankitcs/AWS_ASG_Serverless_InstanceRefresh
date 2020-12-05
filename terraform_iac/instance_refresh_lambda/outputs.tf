output "eventbridge_id" {
  value = aws_cloudwatch_event_rule.ami_updated_rule.id 
}

output "instancerefesh_lambdafunction" {
  value = aws_lambda_function.asg_ir_lambda.function_name
}

output "instancerefesh_lambdafunction_arn" {
  value = aws_lambda_function.asg_ir_lambda.arn
}