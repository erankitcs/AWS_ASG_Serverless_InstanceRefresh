output "codepileline" {
  value = aws_codepipeline.amibuild_codepipeline.id 
}

output "sns_topic" {
  value = aws_sns_topic.amibuild_notification.id 
}